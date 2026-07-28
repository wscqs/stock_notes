import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  setUp(() async {
    dbPath = '${Directory.systemTemp.path}/test_all_trades_${DateTime.now().millisecondsSinceEpoch}.db';
    db = AppDatabase(dbPath);
  });

  tearDown(() async {
    await db.close();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  group('getAllStockTrades', () {
    test('returns all trades ordered by tradeDate desc then createdAt desc', () async {
      final stockId = await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));
      final earlier = DateTime(2026, 7, 20);
      final later = DateTime(2026, 7, 25);

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockId,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        tradeDate: Value(earlier),
      ));
      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockId,
        tradeType: 1,
        openPrice: const Value('110'),
        openShares: const Value('10'),
        tradeDate: Value(later),
      ));

      final trades = await db.getAllStockTrades();
      expect(trades.length, 2);
      expect(trades.first.tradeDate, later);
      expect(trades.last.tradeDate, earlier);
    });
  });
}
