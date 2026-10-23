import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/app/modules/homestock/controllers/homestock_controller.dart';
import 'package:stock_notes/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  late String dbPath;

  setUp(() async {
    dbPath =
        '${Directory.systemTemp.path}/test_homestock_metrics_${DateTime.now().millisecondsSinceEpoch}.db';
    final manager = DatabaseManager();
    await manager.init(path: dbPath);
    Get.put(manager, permanent: true);
    Get.put(TabsController(), permanent: true);
  });

  tearDown(() async {
    await Get.find<DatabaseManager>().close();
    Get.reset();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  group('HomestockController stockCellMetrics', () {
    final item = _buildStock();

    test('holding amount sort returns yield rate and holding amount', () {
      final controller = HomestockController();
      controller.selectedSortIndex.value = 2;
      final metrics = controller.stockCellMetrics(item);
      expect(metrics.map((e) => e.text).toList(), ['+10.0%', '11000']);
    });

    test('yield rate sort returns yield rate and profit', () {
      final controller = HomestockController();
      controller.selectedSortIndex.value = 3;
      final metrics = controller.stockCellMetrics(item);
      expect(metrics.map((e) => e.text).toList(), ['+10.0%', '+1000']);
    });

    test('profit sort returns profit only', () {
      final controller = HomestockController();
      controller.selectedSortIndex.value = 4;
      final metrics = controller.stockCellMetrics(item);
      expect(metrics.map((e) => e.text).toList(), ['+1000']);
    });

    test('other sort returns empty metrics', () {
      final controller = HomestockController();
      controller.selectedSortIndex.value = 0;
      final metrics = controller.stockCellMetrics(item);
      expect(metrics, isEmpty);
    });
  });
}

StockItem _buildStock() {
  final now = DateTime.now();
  return StockItem(
    id: 1,
    createdAt: now,
    updateAt: now,
    marketType: 'sh',
    name: 'Test',
    code: '600001',
    opTop: false,
    opCollect: false,
    opDelete: false,
    opBuy: true,
    rHoldStatus: 0,
    cMeetUpdateAt: now,
    cNearUpdateAt: now,
    cPriceCondition: 0,
    cMarketCapCondition: 0,
    cPeTtmCondition: 0,
    currentPrice: '110',
    rBuyPrice: '100',
    rHoldShares: '100',
  );
}
