import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/translation_library.dart';
import 'package:stock_notes/common/widget/stock_trade_item.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(body: child),
    );
  }

  final now = DateTime(2026, 7, 27);
  final trade = StockTrade(
    id: 1,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    openPrice: '10.00',
    openShares: '100',
    closePrice: null,
    closeShares: null,
    tradeDate: now,
  );

  testWidgets('renders trade type and date', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      StockTradeItem(trade: trade),
    ));
    await tester.pumpAndSettle();
    expect(find.text('买'), findsOneWidget);
    expect(find.text('2026-07-27'), findsOneWidget);
  });

  testWidgets('renders stock name and code when stock is provided', (tester) async {
    final stock = StockItem(
      id: 1,
      createdAt: now,
      updateAt: now,
      marketType: 'sh',
      name: '茅台',
      code: '600519',
      opTop: false,
      opCollect: false,
      opDelete: false,
      opBuy: false,
      cMeetUpdateAt: now,
      cNearUpdateAt: now,
      cPriceCondition: 0,
      cMarketCapCondition: 0,
      cPeTtmCondition: 0,
    );
    await tester.pumpWidget(buildTestableWidget(
      StockTradeItem(trade: trade, stock: stock),
    ));
    await tester.pumpAndSettle();
    expect(find.text('茅台 (600519)'), findsOneWidget);
  });

  testWidgets('invokes onTap when card is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildTestableWidget(
      StockTradeItem(trade: trade, onTap: () => tapped = true),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Card));
    expect(tapped, isTrue);
  });
}
