import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/app/modules/base/base_controller.dart';
import 'package:stock_notes/app/routes/app_pages.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';

class TradelistController extends BaseController {
  final db = Get.find<DatabaseManager>().db;
  final trades = <StockTrade>[].obs;
  final stockMap = <int, StockItem>{}.obs;
  final Future<List<StockTxModel>?> Function({required List<String> stockCodes})?
      stockDataFetcher;

  // Filter state
  final TextEditingController searchController = TextEditingController();
  final query = ''.obs;
  final isMeetConditionEnabled = false.obs;
  final selectedSegment = 'all'.obs;
  final selectedStock = Rxn<StockItem>();
  final filteredTrades = <StockTrade>[].obs;

  // Sort state
  List<String> sortOptions = [
    TextKey.jiaoyiriqi.tr,
    TextKey.shouyilv.tr,
    TextKey.shouyie.tr,
    TextKey.gupiaodaima.tr,
  ];
  final selectedSortIndex = 0.obs;

  TradelistController({this.stockDataFetcher});

  @override
  void onInit() {
    super.onInit();
    loadTrades();
  }

  @override
  void onResume() {
    super.onResume();
    _refreshSortOptions();
    loadTrades();
  }

  void _refreshSortOptions() {
    sortOptions = [
      TextKey.jiaoyiriqi.tr,
      TextKey.shouyilv.tr,
      TextKey.shouyie.tr,
      TextKey.gupiaodaima.tr,
    ];
    selectedSortIndex.refresh();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadTrades() async {
    final allTrades = await db.getAllStockTrades();
    final incomplete = allTrades.where((t) => !t.isCompleted).toList();
    await _loadStockMap(incomplete);
    trades.value = incomplete;
    applyFilters();
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

  void applyFilters() {
    query.value = searchController.text;
    var result = List<StockTrade>.from(trades);

    final queryText = searchController.text.trim();
    if (queryText.isNotEmpty) {
      result = result.where((trade) {
        final stock = stockMap[trade.stockId];
        if (stock == null) return false;
        return stock.name.contains(queryText) ||
            stock.code.contains(queryText);
      }).toList();
    }

    if (isMeetConditionEnabled.value) {
      result = result.where((trade) {
        final stock = stockMap[trade.stockId];
        final status = trade.meetStatus(stock?.currentPrice);
        if (selectedSegment.value == 'bug') {
          return status == TradeMeetStatus.b || status == TradeMeetStatus.bs;
        } else if (selectedSegment.value == 'sale') {
          return status == TradeMeetStatus.s || status == TradeMeetStatus.bs;
        }
        return status != TradeMeetStatus.none;
      }).toList();
    }

    if (selectedStock.value != null) {
      result = result
          .where((trade) => trade.stockId == selectedStock.value!.id)
          .toList();
    }

    result = _sortTrades(result);

    filteredTrades.assignAll(result);
  }

  List<StockTrade> _sortTrades(List<StockTrade> list) {
    switch (selectedSortIndex.value) {
      case 0: // Date
        list.sort((a, b) {
          final da = a.tradeDate ?? a.createdAt;
          final db = b.tradeDate ?? b.createdAt;
          return db.compareTo(da);
        });
      case 1: // Yield rate
        list.sort((a, b) {
          final ea = _tradeEstimate(a);
          final eb = _tradeEstimate(b);
          if (ea.yieldRate == null && eb.yieldRate == null) return 0;
          if (ea.yieldRate == null) return 1;
          if (eb.yieldRate == null) return -1;
          return eb.yieldRate!.compareTo(ea.yieldRate!);
        });
      case 2: // Profit amount
        list.sort((a, b) {
          final ea = _tradeEstimate(a);
          final eb = _tradeEstimate(b);
          if (ea.profit == null && eb.profit == null) return 0;
          if (ea.profit == null) return 1;
          if (eb.profit == null) return -1;
          return eb.profit!.compareTo(ea.profit!);
        });
      case 3: // Stock code
        list.sort((a, b) {
          final ca = stockMap[a.stockId]?.code ?? '';
          final cb = stockMap[b.stockId]?.code ?? '';
          return ca.compareTo(cb);
        });
    }
    return list;
  }

  ({double? yieldRate, double? profit}) _tradeEstimate(StockTrade trade) {
    final stock = stockMap[trade.stockId];
    return calculateTradeEstimateFromValues(
      currentPrice: stock?.currentPrice,
      openPrice: trade.openPrice,
      closePrice: trade.closePrice,
      openShares: trade.openShares,
      closeShares: trade.closeShares,
      tradeType: trade.tradeType,
    );
  }

  void onSortChanged(int index) {
    selectedSortIndex.value = index;
    applyFilters();
  }

  void clearFilters() {
    searchController.clear();
    isMeetConditionEnabled.value = false;
    selectedSegment.value = 'all';
    selectedStock.value = null;
    applyFilters();
  }

  void toggleMeetCondition() {
    isMeetConditionEnabled.toggle();
    if (isMeetConditionEnabled.value) {
      selectedSegment.value = 'all';
    }
    applyFilters();
  }

  void onSegmentChanged(String value) {
    selectedSegment.value = value;
    applyFilters();
  }

  void selectStock(StockItem? stock) {
    selectedStock.value = stock;
    applyFilters();
  }

  void onSearchChanged(String value) {
    applyFilters();
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

  Future<void> refreshCurrentPrices({bool showLoading = true}) async {
    final stocks = stockMap.values.toList();
    final codes = stocks.map((s) => s.code).toList();
    if (codes.isEmpty) {
      QsHud.showToast(TextKey.noData.tr);
      return;
    }
    if (showLoading) {
      QsHud.showLoading();
    }
    try {
      final fetcher = stockDataFetcher ?? QsApi.instance().requestStockData;
      final results = await fetcher(stockCodes: codes);
      if (results != null && results.isNotEmpty) {
        for (final stock in stocks) {
          final result = results.firstWhereOrNull(
            (r) => _pureCode(r.code ?? '') == _pureCode(stock.code),
          );
          if (result != null) {
            await db.updateStock(
              StockItemsCompanion(
                code: Value(stock.code),
                name: Value(result.name ?? stock.name),
                currentPrice: Value(result.currentPrice),
              ),
              stock.code,
            );
          }
        }
      }
      await loadTrades();
    } finally {
      if (showLoading) {
        QsHud.dismiss();
      }
    }
  }

  String _pureCode(String code) {
    return code.replaceFirst(RegExp(r'^(sh|sz|hk|us)'), '');
  }
}
