import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/stockedit/views/stockedit_view.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/langs/translation_library.dart';

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

StockTrade _fakeTrade({required int id}) {
  final now = DateTime(2026, 7, 27);
  return StockTrade(
    id: id,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    price: '10.00',
    shares: '100',
    tradeDate: now,
  );
}
