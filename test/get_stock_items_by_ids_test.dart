import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  setUp(() async {
    dbPath =
        '${Directory.systemTemp.path}/test_stock_items_by_ids_${DateTime.now().millisecondsSinceEpoch}.db';
    db = AppDatabase(dbPath);
  });

  tearDown(() async {
    await db.close();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  group('getStockItemsByIds', () {
    test('returns only the requested stock items', () async {
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
      await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sz',
        code: '000858',
        name: '五粮液',
      ));

      final result = await db.getStockItemsByIds([stockA, stockB]);

      expect(result.length, 2);
      final ids = result.map((s) => s.id).toSet();
      expect(ids, {stockA, stockB});
    });

    test('returns empty list when ids list is empty', () async {
      final result = await db.getStockItemsByIds([]);
      expect(result, isEmpty);
    });

    test('returns empty list when no ids match', () async {
      await db.stockItems.insertOne(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));

      final result = await db.getStockItemsByIds([999999]);
      expect(result, isEmpty);
    });
  });
}
