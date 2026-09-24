import 'dart:io';

import 'package:drift/drift.dart';
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
    MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      oldCondition: ConditionStatus.none,
      newCondition: ConditionStatus.targetBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      saleTarget: '9.0',
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

  test('条件跳变为满足卖时插入一条卖出消息', () async {
    MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      oldCondition: ConditionStatus.none,
      newCondition: ConditionStatus.targetSell,
      condKind: 2,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '2000',
      buyTarget: '1500',
      saleTarget: '1800',
    );

    final messages = await db.getMessages();
    expect(messages, hasLength(1));
    expect(messages.first.msgType, 2);
    expect(messages.first.condKind, 2);
    expect(messages.first.targetValue, '1800');
  });

  test('条件持续满足（无跳变）时不重复插入', () async {
    for (var i = 0; i < 2; i++) {
      MeetMessageHelper.addMeetMessageIfNeeded(
        db,
        // 第二次调用时老条件已是满足买
        oldCondition: i == 0 ? ConditionStatus.none : ConditionStatus.targetBuy,
        newCondition: ConditionStatus.targetBuy,
        condKind: 1,
        stockCode: 'sz300848',
        stockName: '美瑞新材',
        currentValue: '11.23',
        buyTarget: '12.0',
      );
    }

    expect(await db.getMessages(), hasLength(1));
  });

  test('临近条件不生成消息', () async {
    MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      oldCondition: ConditionStatus.none,
      newCondition: ConditionStatus.nearBuy,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
    );

    expect(await db.getMessages(), isEmpty);
    expect(await db.getUnreadMessageCount(), 0);
  });

  test('全部标记已读与删除消息', () async {
    MeetMessageHelper.addMeetMessageIfNeeded(
      db,
      oldCondition: ConditionStatus.none,
      newCondition: ConditionStatus.targetBoth,
      condKind: 1,
      stockCode: 'sz300848',
      stockName: '美瑞新材',
      currentValue: '11.23',
      buyTarget: '12.0',
      saleTarget: '9.0',
    );
    expect(await db.getUnreadMessageCount(), 2);

    await db.markAllMessagesRead();
    expect(await db.getUnreadMessageCount(), 0);

    final messages = await db.getMessages();
    await db.deleteMessage(messages.first);
    expect(await db.getMessages(), hasLength(1));
  });
}
