import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  test('schema 14 adds nullable close date without changing old trades',
      () async {
    final dir = await Directory.systemTemp.createTemp('close_date_migration');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/trade.db';
    var db = AppDatabase(path);
    final now = DateTime(2026, 1, 1);
    await db.into(db.stockItems).insert(StockItemsCompanion.insert(
        marketType: 'sh', name: 'Test', code: '600900'));
    await db.addStockTrade(StockTradesCompanion.insert(
        stockId: 1,
        tradeType: 0,
        openPrice: const Value('10'),
        openShares: const Value('100'),
        closePrice: const Value('12'),
        closeShares: const Value('100'),
        tradeDate: Value(now)));
    await db.customStatement('ALTER TABLE stock_trades DROP COLUMN close_date');
    await db.customStatement('PRAGMA user_version = 13');
    await db.close();

    db = AppDatabase(path);
    final trade = (await db.getStockTradesByStockId(1)).single;
    expect(db.schemaVersion, 14);
    expect(trade.closeDate, isNull);
    expect(trade.openPrice, '10');
    await db.close();
  });
}
