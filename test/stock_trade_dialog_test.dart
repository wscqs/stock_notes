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

  testWidgets('close date appears only after close price is entered',
      (tester) async {
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

    final closePriceField = find.ancestor(
        of: find.text('价格').last, matching: find.byType(TextField));
    await tester.enterText(closePriceField, '12');
    await tester.pump();
    expect(find.byKey(const Key('tradeCloseDateField')), findsOneWidget);

    await tester.enterText(closePriceField, '');
    await tester.pump();
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

  testWidgets('partial close date can be picked and saved', (tester) async {
    final tradeDate = DateTime(2026, 10, 20);
    final trade = StockTrade(
        id: 1,
        createdAt: tradeDate,
        updateAt: tradeDate,
        stockId: 1,
        tradeType: 0,
        openPrice: '10',
        openShares: '100',
        closePrice: '12',
        closeShares: '50',
        tradeDate: tradeDate);
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
    final closeDateField = tester.widget<TextField>(find.descendant(
        of: find.byKey(const Key('tradeCloseDateField')),
        matching: find.byType(TextField)));
    closeDateField.onTap!();
    await tester.pumpAndSettle();
    final datePicker =
        tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));
    expect(datePicker.firstDate, DateTime(1));
    expect(datePicker.lastDate, DateUtils.dateOnly(DateTime.now()));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
  });

  testWidgets('close date can be cleared from the dialog', (tester) async {
    final tradeDate = DateTime(2026, 10, 20);
    final trade = StockTrade(
        id: 1,
        createdAt: tradeDate,
        updateAt: tradeDate,
        stockId: 1,
        tradeType: 0,
        openPrice: '10',
        openShares: '100',
        closePrice: '12',
        closeShares: '100',
        tradeDate: tradeDate,
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
    await tester.tap(find.byKey(const Key('clearTradeCloseDate')));
    await tester.pump();
    expect(find.text('2026-10-21'), findsNothing);
    expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    await tester.tap(find.text('确定'));
    expect(saved?.closeDate.present, isTrue);
    expect(saved?.closeDate.value, isNull);
  });
}
