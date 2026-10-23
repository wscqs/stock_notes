import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/app/modules/homestock/controllers/homestock_controller.dart';
import 'package:stock_notes/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

void main() {
  late String dbPath;

  setUp(() async {
    dbPath =
        '${Directory.systemTemp.path}/test_homestock_sort_${DateTime.now().millisecondsSinceEpoch}.db';
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

  group('HomestockController sort by holding amount', () {
    test('sortOptions includes holding amount before yield rate', () {
      final controller = HomestockController();
      expect(controller.sortOptions[2], TextKey.paixuChiyouE.tr);
      expect(controller.sortOptions[3], TextKey.paixuShouyilv.tr);
    });

    test('sorts by holding amount descending by default', () async {
      final items = [
        _buildStock(id: 1, opBuy: true, currentPrice: '100', rHoldShares: '10'),
        _buildStock(id: 2, opBuy: true, currentPrice: '200', rHoldShares: '10'),
        _buildStock(id: 3, opBuy: true, currentPrice: '150', rHoldShares: '10'),
      ];

      final controller = HomestockController();
      controller.selectedSortIndex.value = 2; // 持有额
      controller.sortAscending.value = false; // 降序
      final sorted = controller.applySortToList(List.from(items));

      expect(sorted.map((e) => e.id).toList(), [2, 3, 1]);
    });

    test('sorts by holding amount ascending', () async {
      final items = [
        _buildStock(id: 1, opBuy: true, currentPrice: '100', rHoldShares: '10'),
        _buildStock(id: 2, opBuy: true, currentPrice: '200', rHoldShares: '10'),
        _buildStock(id: 3, opBuy: true, currentPrice: '150', rHoldShares: '10'),
      ];

      final controller = HomestockController();
      controller.selectedSortIndex.value = 2; // 持有额
      controller.sortAscending.value = true; // 升序
      final sorted = controller.applySortToList(List.from(items));

      expect(sorted.map((e) => e.id).toList(), [1, 3, 2]);
    });
  });
}

StockItem _buildStock({
  required int id,
  bool opBuy = false,
  String? currentPrice,
  String? rHoldShares,
}) {
  final now = DateTime.now();
  return StockItem(
    id: id,
    createdAt: now,
    updateAt: now,
    marketType: 'sh',
    name: 'Test',
    code: '600$id',
    opTop: false,
    opCollect: false,
    opDelete: false,
    opBuy: opBuy,
    rHoldStatus: 0,
    cMeetUpdateAt: now,
    cNearUpdateAt: now,
    cPriceCondition: 0,
    cMarketCapCondition: 0,
    cPeTtmCondition: 0,
    currentPrice: currentPrice,
    rHoldShares: rHoldShares,
  );
}
