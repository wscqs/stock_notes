import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/https/stock_kline_service.dart';
import 'package:stock_notes/common/langs/translation_library.dart';
import 'package:stock_notes/common/widget/trade_profit_chart_sheet.dart';

void main() {
  setUp(() => StockKlineService.clearMemoryCacheForTest());
  final now = DateTime(2026, 10, 20);
  final stock = StockItem(
      id: 1,
      createdAt: now,
      updateAt: now,
      marketType: 'sh',
      name: '长江电力',
      code: '600900',
      opTop: false,
      opCollect: false,
      opDelete: false,
      opBuy: false,
      cMeetUpdateAt: now,
      cNearUpdateAt: now,
      cPriceCondition: 0,
      cMarketCapCondition: 0,
      cPeTtmCondition: 0,
      rHoldStatus: 0);
  final trade = StockTrade(
      id: 1,
      createdAt: now,
      updateAt: now,
      stockId: 1,
      tradeType: 0,
      openPrice: '25',
      openShares: '100',
      tradeDate: now);

  Widget app(StockKlineService service) => GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(
          body: TradeProfitChartContent(
              stock: stock,
              trade: trade,
              service: service,
              onCloseDateSaved: (_) async {})));

  testWidgets('shows profit, drawdown and switches units', (tester) async {
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-20","25","25","25","25","1"],["2026-10-21","30","30","30","30","1"],["2026-10-22","27","27","27","27","1"]]}}}');
    await tester.pumpWidget(app(service));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.textContaining('200.00'), findsWidgets);
    expect(find.textContaining('300.00'), findsOneWidget);
    await tester.tap(find.text('收益率'));
    await tester.pumpAndSettle();
    expect(find.textContaining('8.00%'), findsWidgets);
    expect(find.textContaining('12.00%'), findsOneWidget);
  });

  testWidgets('shows retry after network failure', (tester) async {
    var calls = 0;
    final retryTrade = trade.copyWith(tradeDate: Value(DateTime(2026, 10, 19)));
    final service = StockKlineService(rawFetcher: (_, __) async {
      calls++;
      if (calls == 1) throw Exception('offline');
      return '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-19","25","25","25","25","1"]]}}}';
    });
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: retryTrade,
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    expect(find.text('重试'), findsOneWidget);
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('touching chart updates selected date and profit',
      (tester) async {
    final touchTrade = trade.copyWith(tradeDate: Value(DateTime(2026, 10, 18)));
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-18","25","25","25","25","1"],["2026-10-19","30","30","30","30","1"],["2026-10-20","27","27","27","27","1"]]}}}');
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: touchTrade,
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    // The chart width includes its 50px left-axis reservation.
    final rect = tester.getRect(find.byType(LineChart));
    final center = Offset(rect.left + rect.width / 2 + 25, rect.center.dy);
    final gesture = await tester.startGesture(Offset(center.dx, center.dy));
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pump();
    expect(find.text('2026-10-19'), findsWidgets);
  });

  testWidgets(
      'shows no-data instead of shifting baseline when open day is missing',
      (tester) async {
    final missingStartTrade =
        trade.copyWith(tradeDate: Value(DateTime(2026, 10, 10)));
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-22","30","30","30","30","1"]]}}}');
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: missingStartTrade,
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    expect(find.text('暂无历史行情'), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);
  });

  testWidgets('uses the trade cell current price for the latest point',
      (tester) async {
    final currentPriceTrade =
        trade.copyWith(tradeDate: Value(DateTime(2026, 10, 22)));
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-22","25","25","25","25","1"],["2026-10-23","27","27","27","27","1"]]}}}');
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: currentPriceTrade,
                currentPrice: '28',
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    expect(find.textContaining('300.00'), findsWidgets);
    expect(find.text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
        findsWidgets);
  });

  testWidgets('open trade shows today as date for current-price latest point',
      (tester) async {
    final currentPriceTrade =
        trade.copyWith(tradeDate: Value(DateTime(2026, 10, 22)));
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-22","25","25","25","25","1"],["2026-10-23","27","27","27","27","1"]]}}}');
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: currentPriceTrade,
                currentPrice: '28',
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    expect(find.text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
        findsWidgets);
  });

  testWidgets('drawdown percentage uses actual open price', (tester) async {
    final drawdownTrade =
        trade.copyWith(tradeDate: Value(DateTime(2026, 10, 22)));
    final service = StockKlineService(
        rawFetcher: (_, __) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-10-22","20","20","20","20","1"],["2026-10-23","30","30","30","30","1"],["2026-10-24","24","24","24","24","1"]]}}}');
    await tester.pumpWidget(GetMaterialApp(
        translations: TranslationLibrary(),
        locale: TranslationLibrary.fallbackLocale,
        fallbackLocale: TranslationLibrary.fallbackLocale,
        home: Scaffold(
            body: TradeProfitChartContent(
                stock: stock,
                trade: drawdownTrade,
                currentPrice: '27',
                service: service,
                onCloseDateSaved: (_) async {}))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('收益率'));
    await tester.pumpAndSettle();
    final texts = tester
        .widgetList<Text>(find.byType(Text))
        .map((w) => w.data ?? '')
        .toList();
    expect(texts.any((t) => t.contains('12.00%')), isTrue,
        reason: texts.join('|'));
  });
}
