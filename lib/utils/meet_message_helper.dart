import 'package:drift/drift.dart';
import 'package:stock_notes/common/database/database.dart';

/// 满足买/卖目标提醒消息生成（首页行情刷新与股票编辑保存共用）
class MeetMessageHelper {
  /// 单个维度（价格/市值/市盈）条件满足买/卖目标时插入消息（每天提醒一次）
  ///
  /// 规则：
  /// - 电平触发：条件满足即提醒，不要求「未满足 -> 满足」跳变（条件位会持久化，
  ///   跳变只发生一次，持续满足的股票也要每天能收到提醒）
  /// - 去重：同股票+同方向+同维度当天最多一条（当天内多次刷新/价格震荡不刷屏）
  /// - 停买/停卖（rHoldStatus 2/3）是用户的显式操作，始终抑制对应方向提醒
  /// - 持仓过滤开关开启时，卖提醒仅持仓股票才发；买提醒不过滤（允许加仓场景）
  static Future<void> addMeetMessageIfNeeded(
    AppDatabase db, {
    required int newCondition,
    required int condKind,
    required String stockCode,
    required String stockName,
    String? currentValue,
    String? buyTarget,
    String? saleTarget,
    required bool holdFilterEnabled,
    required bool isHolding,
    int rHoldStatus = 0,
  }) async {
    // 持有操作状态：1=锁仓,2=停买,3=停卖
    final suppressBuy = rHoldStatus == 2;
    final suppressSell = rHoldStatus == 3 || (holdFilterEnabled && !isHolding);

    if (newCondition.hasTargetBuy && !suppressBuy) {
      final sentToday = await db.hasMessageToday(
          stockCode: stockCode, msgType: 1, condKind: condKind);
      if (!sentToday) {
        await db.addMessage(MessageItemsCompanion.insert(
          stockCode: stockCode,
          stockName: stockName,
          msgType: 1,
          condKind: condKind,
          currentValue: Value(currentValue),
          targetValue: Value(buyTarget),
        ));
      }
    }
    if (newCondition.hasTargetSell && !suppressSell) {
      final sentToday = await db.hasMessageToday(
          stockCode: stockCode, msgType: 2, condKind: condKind);
      if (!sentToday) {
        await db.addMessage(MessageItemsCompanion.insert(
          stockCode: stockCode,
          stockName: stockName,
          msgType: 2,
          condKind: condKind,
          currentValue: Value(currentValue),
          targetValue: Value(saleTarget),
        ));
      }
    }
  }
}
