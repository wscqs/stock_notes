import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/utils/meet_message_helper.dart';

void main() {
  late AppDatabase db;
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('meet_message_helper_test');
    db = AppDatabase('${dir.path}/test.db');
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('条件跳变为满足买时插入一条买入消息', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      saleTarget: '9.0',
      holdFilterEnabled: true,
      isHolding: false,
    );

    final messages = await db.getMessages();
    expect(messages, hasLength(1));
    expect(messages.first.msgType, 1);
    expect(messages.first.condKind, 1);
    expect(messages.first.stockCode, 'sz300848');
    expect(messages.first.currentValue, '11.23');
    expect(messages.first.targetValue, '12.0');
    expect(await db.getUnreadMessageCount(), 1);
  });

  test('条件跳变为满足卖且持仓时插入一条卖出消息', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetSell,
      condKind: 2,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '2000',
      buyTarget: '1500',
      saleTarget: '1800',
      holdFilterEnabled: true,
      isHolding: true,
    );

    final messages = await db.getMessages();
    expect(messages, hasLength(1));
    expect(messages.first.msgType, 2);
    expect(messages.first.condKind, 2);
    expect(messages.first.targetValue, '1800');
  });

  test('条件持续满足（无跳变）但当天未提醒时，也生成一条（每天提醒一次）', () async {
    // 老条件已是满足买（昨天及以前已满足），今天仍满足：当天无消息则补一条
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      holdFilterEnabled: true,
      isHolding: false,
    );

    expect(await db.getMessages(), hasLength(1));
    expect((await db.getMessages()).first.msgType, 1);
  });

  test('条件持续满足时，当天第二次刷新不重复插入', () async {
    for (var i = 0; i < 2; i++) {
      await MeetMessageHelper.addMeetMessageIfNeeded(
        db,
        newCondition: ConditionStatus.targetBuy,
        condKind: 1,
        stockCode: 'sz300848',
        stockName: '美瑞新材',
        currentValue: '11.23',
        buyTarget: '12.0',
        holdFilterEnabled: true,
        isHolding: false,
      );
    }

    expect(await db.getMessages(), hasLength(1));
  });

  test('当天内反复跳变（价格震荡）也只发一条', () async {
    for (var i = 0; i < 3; i++) {
      // 每次都模拟「未满足 -> 满足」的跳变（价格回落后又到达目标）
      await MeetMessageHelper.addMeetMessageIfNeeded(
        db,
        newCondition: ConditionStatus.targetBuy,
        condKind: 1,
        stockCode: 'sz300848',
        stockName: '美瑞新材',
        currentValue: '11.23',
        buyTarget: '12.0',
        holdFilterEnabled: true,
        isHolding: false,
      );
    }

    expect(await db.getMessages(), hasLength(1));
  });

  test('不同维度/方向的去重互不影响', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      buyTarget: '12.0',
      holdFilterEnabled: true,
      isHolding: false,
    );
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBuy,
      condKind: 2,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      buyTarget: '1500',
      holdFilterEnabled: true,
      isHolding: false,
    );

    expect(await db.getMessages(), hasLength(2));
  });

  test('持仓过滤开启且未持仓时，卖提醒不发、买提醒照发', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBoth,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      saleTarget: '9.0',
      holdFilterEnabled: true,
      isHolding: false,
    );

    final messages = await db.getMessages();
    expect(messages, hasLength(1));
    expect(messages.first.msgType, 1);
  });

  test('持仓过滤关闭时，未持仓也发卖提醒', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetSell,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      saleTarget: '9.0',
      holdFilterEnabled: false,
      isHolding: false,
    );

    final messages = await db.getMessages();
    expect(messages, hasLength(1));
    expect(messages.first.msgType, 2);
  });

  test('停买状态抑制买提醒，停卖状态抑制卖提醒（即使持仓）', () async {
    // 停买
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      buyTarget: '12.0',
      holdFilterEnabled: true,
      isHolding: true,
      rHoldStatus: 2,
    );
    // 停卖
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetSell,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      saleTarget: '9.0',
      holdFilterEnabled: true,
      isHolding: true,
      rHoldStatus: 3,
    );

    expect(await db.getMessages(), isEmpty);
  });

  test('临近条件不生成消息', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.nearBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      holdFilterEnabled: true,
      isHolding: false,
    );

    expect(await db.getMessages(), isEmpty);
    expect(await db.getUnreadMessageCount(), 0);
  });

  test('全部标记已读与删除消息', () async {
    await MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      newCondition: ConditionStatus.targetBoth,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      saleTarget: '9.0',
      holdFilterEnabled: true,
      isHolding: true,
    );
    expect(await db.getUnreadMessageCount(), 2);

    await db.markAllMessagesRead();
    expect(await db.getUnreadMessageCount(), 0);

    final messages = await db.getMessages();
    await db.deleteMessage(messages.first);
    expect(await db.getMessages(), hasLength(1));
  });
}
