import 'package:get/get.dart';
import 'package:stock_notes/app/modules/base/base_controller.dart';
import 'package:stock_notes/app/routes/app_pages.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';
import 'package:stock_notes/utils/qs_hud.dart';

class TradelistController extends BaseController {
  final db = Get.find<DatabaseManager>().db;
  final trades = <StockTrade>[].obs;
  final stockMap = <int, StockItem>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrades();
  }

  Future<void> loadTrades() async {
    final allTrades = await db.getAllStockTrades();
    final incomplete = allTrades.where((t) => !t.isCompleted).toList();
    await _loadStockMap(incomplete);
    trades.value = incomplete;
  }

  Future<void> _loadStockMap(List<StockTrade> trades) async {
    final stockIds = trades.map((t) => t.stockId).toSet().toList();
    if (stockIds.isEmpty) {
      stockMap.clear();
      return;
    }
    final stocks = await db.getStockItemsByIds(stockIds);
    stockMap.value = {for (final s in stocks) s.id: s};
  }

  void editTrade(StockTrade trade) {
    final ctx = Get.context;
    if (ctx == null) return;
    final stock = stockMap[trade.stockId];
    StockTradeDialog.show(
      context: ctx,
      existingTrade: trade,
      currentPrice: stock?.currentPrice ?? '',
      onSaved: (companion) async {
        if ((companion.openPrice.value ?? '').isEmpty) {
          QsHud.showToast(TextKey.qingshuru.tr + TextKey.kaicang.tr + TextKey.jiage.tr);
          return;
        }
        await db.updateStockTrade(companion);
        Get.back();
        QsHud.showToast(TextKey.success.tr);
        await loadTrades();
      },
    );
  }

  void deleteTrade(StockTrade trade) {
    QsHud.showConfirmDialog(
      title: TextKey.querengdelete.tr,
      content: '',
      onConfirm: () async {
        await db.deleteStockTrade(trade);
        await loadTrades();
      },
    );
  }

  void openStockDetail(StockTrade trade) {
    final stock = stockMap[trade.stockId];
    if (stock == null) {
      QsHud.showToast(TextKey.gupiaobucunzai.tr);
      return;
    }
    Get.toNamed(Routes.STOCKEDIT, arguments: stock);
  }
}
