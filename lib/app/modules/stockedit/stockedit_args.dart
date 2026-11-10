import '../../../common/database/database.dart';

/// 股票编辑页路由参数：单只股票 + 可选的左右滑动列表
class StockeditArgs {
  /// 当前展示的股票
  final StockItem item;

  /// 可滑动切换的股票列表（顺序同来源列表，如首页当前筛选/排序结果）
  /// 为空或长度为 1 时卡片不可滑动。
  final List<StockItem> items;

  const StockeditArgs(this.item, {this.items = const []});
}
