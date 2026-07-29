import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/app/modules/tradelist/controllers/tradelist_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/model/stock_tx_model.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  setUp(() async {
    dbPath =
        '${Directory.systemTemp.path}/test_tradelist_${DateTime.now().millisecondsSinceEpoch}.db';
    final manager = DatabaseManager();
    await manager.init(path: dbPath);
    db = manager.db;
    Get.put(manager, permanent: true);
  });

  tearDown(() async {
    await Get.find<DatabaseManager>().close();
    Get.reset();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  group('TradelistController', () {
    test('loadTrades filters only incomplete trades across all stocks',
        () async {
      final stockA = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));
      final stockB = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '000001',
        name: '平安',
      ));

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockA,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        closeShares: const Value('5'),
        tradeDate: Value(DateTime(2026, 7, 25)),
      ));
      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockB,
        tradeType: 1,
        openPrice: const Value('200'),
        openShares: const Value('10'),
        closeShares: const Value('10'),
        tradeDate: Value(DateTime(2026, 7, 26)),
      ));

      final controller = TradelistController();
      controller.onInit();
      await controller.loadTrades();

      expect(controller.trades.length, 1);
      expect(controller.trades.first.stockId, stockA);
    });

    test('loadTrades populates stockMap with related stocks', () async {
      final stockA = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));
      final stockB = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '000001',
        name: '平安',
      ));

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockA,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        closeShares: const Value('5'),
        tradeDate: Value(DateTime(2026, 7, 25)),
      ));
      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockB,
        tradeType: 1,
        openPrice: const Value('200'),
        openShares: const Value('10'),
        closeShares: const Value('10'),
        tradeDate: Value(DateTime(2026, 7, 26)),
      ));

      final controller = TradelistController();
      controller.onInit();
      await controller.loadTrades();

      expect(controller.stockMap.length, 1);
      expect(controller.stockMap.containsKey(stockA), true);
      expect(controller.stockMap[stockA]?.name, '茅台');
    });

    test('refreshCurrentPrices updates currentPrice for related stocks',
        () async {
      final stockA = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockA,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        tradeDate: Value(DateTime(2026, 7, 25)),
      ));

      final controller = TradelistController(
        stockDataFetcher: ({required List<String> stockCodes}) async {
          return [
            StockTxModel(
              code: 'sh600519',
              name: '茅台',
              currentPrice: '150.00',
            ),
          ];
        },
      );
      controller.onInit();
      await controller.loadTrades();
      expect(controller.stockMap[stockA]?.currentPrice, equals(null));

      await controller.refreshCurrentPrices(showLoading: false);

      expect(controller.stockMap[stockA]?.currentPrice, '150.00');
    });
  });
}
