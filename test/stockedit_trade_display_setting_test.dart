import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/globle_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> initPreferences(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    await Get.putAsync(() => GlobalService().init());
  }

  tearDown(Get.reset);

  test('trade display setting defaults to trading', () async {
    await initPreferences({});
    expect(GlobalService.to.rxStockeditTradeFilter.value, 'trade');
  });

  test('trade display setting is restored and persisted', () async {
    await initPreferences({'stockeditTradeFilter': 'history'});
    expect(GlobalService.to.rxStockeditTradeFilter.value, 'history');
    await GlobalService.to.changeStockeditTradeFilter('all');
    expect(GlobalService.to.sharedPreferences.getString('stockeditTradeFilter'),
        'all');
    expect(GlobalService.to.rxStockeditTradeFilter.value, 'all');
  });

  test('trade display setting falls back to trading for invalid values',
      () async {
    await initPreferences({'stockeditTradeFilter': 'unknown'});
    expect(GlobalService.to.rxStockeditTradeFilter.value, 'trade');
  });

  group('stock edit trades follow the setting', () {
    late StockeditController controller;

    setUp(() async {
      final manager = DatabaseManager();
      await manager.init(
          path:
              '${Directory.systemTemp.path}/test_trade_setting_${DateTime.now().microsecondsSinceEpoch}.db');
      Get.put(manager);
      controller = StockeditController();
      controller.stockTrades.value = [
        trade(id: 1, openShares: '100'),
        trade(id: 2, openShares: '100', closeShares: '100'),
      ];
    });

    test('shows only completed trades when history is selected', () async {
      await initPreferences({'stockeditTradeFilter': 'history'});
      expect(controller.displayedTrades.map((t) => t.id), [2]);
    });

    test('shows all trades when all is selected', () async {
      await initPreferences({'stockeditTradeFilter': 'all'});
      expect(controller.displayedTrades.map((t) => t.id), [1, 2]);
    });

    test('shows only active trades by default', () async {
      await initPreferences({});
      expect(controller.displayedTrades.map((t) => t.id), [1]);
    });
  });
}

StockTrade trade({
  required int id,
  required String openShares,
  String? closeShares,
}) {
  final now = DateTime(2026, 11, 10);
  return StockTrade(
    id: id,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    openPrice: '10',
    openShares: openShares,
    closeShares: closeShares,
    tradeDate: now,
  );
}
