import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';
import 'package:stock_notes/app/modules/stockedit/views/stockedit_view.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/langs/translation_library.dart';
import 'package:stock_notes/common/globle_service.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(body: child),
    );
  }

  Widget buildTradeItem(StockTrade trade) {
    return Card(
      child: ListTile(
        title: Text('Trade #${trade.id}'),
      ),
    );
  }

  group('showAllTradesSheet filter labels', () {
    setUp(() async {
      Get.testMode = true;
      Get.reset();
      SharedPreferences.setMockInitialValues({});
      await Get.putAsync(() => GlobalService().init());
      final manager = DatabaseManager();
      await manager.init(
          path:
              '${Directory.systemTemp.path}/test_stockedit_${DateTime.now().millisecondsSinceEpoch}.db');
      Get.put(manager, permanent: true);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('uses trading label for the active trades filter',
        (tester) async {
      final controller = StockeditController();
      controller.stockTrades.value = [
        _fakeTrade(id: 1),
      ];
      await tester.pumpWidget(buildTestableWidget(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => controller.showAllTradesSheet(buildTradeItem),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('交易中'), findsOneWidget);
    });

    testWidgets('popup filter only changes the popup and does not persist',
        (tester) async {
      final controller = StockeditController();
      controller.stockTrades.value = [
        _fakeTrade(id: 1, closeShares: '100'),
        _fakeTrade(id: 2),
      ];
      await tester.pumpWidget(buildTestableWidget(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => controller.showAllTradesSheet(buildTradeItem),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('历史'));
      await tester.pumpAndSettle();

      expect(controller.filteredTrades.map((trade) => trade.id), [1]);
      expect(GlobalService.to.rxStockeditTradeFilter.value, 'trade');
      expect(
        GlobalService.to.sharedPreferences
            .getString(GlobalService.stockeditTradeFilterKey),
        isNull,
      );
      expect(controller.displayedTrades.map((trade) => trade.id), [2]);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(controller.tradeListFilter.value, 'trade');
      expect(GlobalService.to.rxStockeditTradeFilter.value, 'trade');
    });
  });

  group('StockTradeListWithMore', () {
    testWidgets('renders all trades when count <= maxVisibleTrades',
        (tester) async {
      final trades = [
        _fakeTrade(id: 1),
        _fakeTrade(id: 2),
        _fakeTrade(id: 3),
      ];

      await tester.pumpWidget(buildTestableWidget(
        StockTradeListWithMore(
          trades: trades,
          buildTradeItem: buildTradeItem,
          onShowAll: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNWidgets(3));
      expect(find.textContaining(TextKey.gengduo.tr), findsNothing);
    });

    testWidgets(
        'renders maxVisibleTrades cards and a more row when count exceeds it',
        (tester) async {
      final trades = [
        _fakeTrade(id: 1),
        _fakeTrade(id: 2),
        _fakeTrade(id: 3),
        _fakeTrade(id: 4),
        _fakeTrade(id: 5),
      ];
      var showAllCalled = false;

      await tester.pumpWidget(buildTestableWidget(
        StockTradeListWithMore(
          trades: trades,
          buildTradeItem: buildTradeItem,
          onShowAll: () => showAllCalled = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNWidgets(3));
      expect(find.textContaining('${TextKey.gengduo.tr} (2)'), findsOneWidget);

      await tester.tap(find.textContaining('${TextKey.gengduo.tr} (2)'));
      await tester.pumpAndSettle();
      expect(showAllCalled, isTrue);
    });
  });
}

StockTrade _fakeTrade({required int id, String? closeShares}) {
  final now = DateTime(2026, 7, 27);
  return StockTrade(
    id: id,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    price: '10.00',
    openShares: '100',
    closeShares: closeShares,
    shares: '100',
    tradeDate: now,
  );
}
