import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/translation_library.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(body: child),
    );
  }

  testWidgets('shows dialog with open price field', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
            context: context,
            existingTrade: null,
            currentPrice: '10',
            onSaved: (companion) {},
          ),
          child: const Text('open'),
        );
      }),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.widgetWithText(TextField, '价格'), findsWidgets);
  });

  testWidgets('completed trade exposes and saves close date', (tester) async {
    final now = DateTime(2026, 10, 20);
    final trade = StockTrade(
        id: 1,
        createdAt: now,
        updateAt: now,
        stockId: 1,
        tradeType: 0,
        openPrice: '10',
        openShares: '100',
        closePrice: '12',
        closeShares: '100',
        tradeDate: now,
        closeDate: now);
    StockTradesCompanion? saved;
    await tester.pumpWidget(buildTestableWidget(Builder(builder: (context) {
      return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
              context: context,
              existingTrade: trade,
              currentPrice: '12',
              onSaved: (value) => saved = value),
          child: const Text('open'));
    })));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tradeCloseDateField')), findsOneWidget);
    await tester.tap(find.text('确定'));
    expect(saved?.closeDate.value, now);
  });

  testWidgets('open trade does not show close date', (tester) async {
    await tester.pumpWidget(buildTestableWidget(Builder(builder: (context) {
      return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
              context: context,
              existingTrade: null,
              currentPrice: '12',
              onSaved: (_) {}),
          child: const Text('open'));
    })));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tradeCloseDateField')), findsNothing);
  });

  testWidgets('legacy completed trade does not invent a close date',
      (tester) async {
    final now = DateTime(2026, 10, 20);
    final trade = StockTrade(
        id: 1,
        createdAt: now,
        updateAt: now,
        stockId: 1,
        tradeType: 0,
        openPrice: '10',
        openShares: '100',
        closePrice: '12',
        closeShares: '100',
        tradeDate: now);
    StockTradesCompanion? saved;
    await tester.pumpWidget(buildTestableWidget(Builder(builder: (context) {
      return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
              context: context,
              existingTrade: trade,
              currentPrice: '12',
              onSaved: (value) => saved = value),
          child: const Text('open'));
    })));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确定'));
    expect(saved?.closeDate.value, isNull);
  });

  testWidgets(
      'editing legacy completed trade preserves repaired close date when close price is empty',
      (tester) async {
    final now = DateTime(2026, 10, 20);
    final trade = StockTrade(
        id: 1,
        createdAt: now,
        updateAt: now,
        stockId: 1,
        tradeType: 0,
        openPrice: '10',
        openShares: '100',
        closePrice: '',
        closeShares: '100',
        tradeDate: now,
        closeDate: DateTime(2026, 10, 21));
    StockTradesCompanion? saved;
    await tester.pumpWidget(buildTestableWidget(Builder(builder: (context) {
      return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
              context: context,
              existingTrade: trade,
              currentPrice: '12',
              onSaved: (value) => saved = value),
          child: const Text('open'));
    })));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确定'));
    expect(saved?.closeDate.value, DateTime(2026, 10, 21));
  });
}

// Close date behavior is isolated below to keep the original dialog smoke test unchanged.
