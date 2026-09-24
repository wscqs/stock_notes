import 'package:drift/drift.dart';
import 'package:stock_notes/common/database/database.dart';

/// 满足买/卖目标提醒消息生成（首页行情刷新与股票编辑保存共用）
class MeetMessageHelper {
  /// 单个维度（价格/市值/市盈）条件从「未满足」跳变为「满足买/卖目标」时插入消息
  static void addMeetMessageIfNeeded(
    AppDatabase db, {
    required int oldCondition,
    required int newCondition,
    required int condKind,
    required String stockCode,
    required String stockName,
    String? currentValue,
    String? buyTarget,
    String? saleTarget,
  }) {
    if (newCondition.hasTargetBuy && !oldCondition.hasTargetBuy) {
      db.addMessage(MessageItemsCompanion.insert(
        stockCode: stockCode,
        stockName: stockName,
        msgType: 1,
        condKind: condKind,
        currentValue: Value(currentValue),
        targetValue: Value(buyTarget),
      ));
    }
    if (newCondition.hasTargetSell && !oldCondition.hasTargetSell) {
      db.addMessage(MessageItemsCompanion.insert(
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
