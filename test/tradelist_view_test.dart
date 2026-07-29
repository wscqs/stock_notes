import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import 'package:stock_notes/app/modules/tradelist/controllers/tradelist_controller.dart';
import 'package:stock_notes/app/modules/tradelist/views/tradelist_view.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/translation_library.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: child,
    );
  }

  setUp(() async {
    dbPath =
        '${Directory.systemTemp.path}/test_tradelist_view_${DateTime.now().millisecondsSinceEpoch}.db';
    final manager = DatabaseManager();
    await manager.init(path: dbPath);
    db = manager.db;
    Get.put(manager, permanent: true);
  });

  tearDown(() async {
    await Get.find<DatabaseManager>().close();
    Get.reset();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  Future<void> seedTwoStocksAndTrades() async {
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

    await db.addStockTrade(StockTradesCompanion.insert(
      stockId: stockA,
      tradeType: 0,
      openPrice: const Value('100'),
      openShares: const Value('10'),
      closeShares: const Value('5'),
      planSalePrice: const Value('110'),
      tradeDate: Value(DateTime(2026, 7, 25)),
    ));
    await db.addStockTrade(StockTradesCompanion.insert(
      stockId: stockB,
      tradeType: 1,
      openPrice: const Value('200'),
      openShares: const Value('10'),
      closeShares: const Value('5'),
      tradeDate: Value(DateTime(2026, 7, 26)),
    ));

    await db.updateStock(
      StockItemsCompanion(
        code: const Value('600519'),
        currentPrice: const Value('115'),
      ),
      '600519',
    );
  }

  testWidgets('renders all trades after loading', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsOneWidget);
  });

  testWidgets('search bar input filters the trade list', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '茅台');
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsNothing);

    await tester.enterText(find.byType(TextField), '000001');
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsNothing);
    expect(find.text('平安 (000001)'), findsOneWidget);
  });

  testWidgets('tapping meet chip shows segmented control', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoSegmentedControl<String>), findsNothing);

    await tester.tap(find.text('满足买卖'));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoSegmentedControl<String>), findsOneWidget);
    expect(find.descendant(
      of: find.byType(CupertinoSegmentedControl<String>),
      matching: find.text('全部'),
    ), findsOneWidget);
    expect(find.descendant(
      of: find.byType(CupertinoSegmentedControl<String>),
      matching: find.text('买'),
    ), findsOneWidget);
    expect(find.descendant(
      of: find.byType(CupertinoSegmentedControl<String>),
      matching: find.text('卖'),
    ), findsOneWidget);
  });

  testWidgets('segmented control filters the trade list', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('满足买卖'));
    await tester.pumpAndSettle();

    // 全部 shows only trades that meet either buy or sell condition.
    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsNothing);

    final segmentedControl = find.byType(CupertinoSegmentedControl<String>);
    await tester.tap(find.descendant(of: segmentedControl, matching: find.text('卖')));
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsNothing);
    expect(find.text('平安 (000001)'), findsNothing);

    await tester.tap(find.descendant(of: segmentedControl, matching: find.text('买')));
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsNothing);
  });

  testWidgets('stock filter button opens bottom sheet with options', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_list_outlined));
    await tester.pumpAndSettle();

    expect(find.text('全部'), findsOneWidget);
    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsOneWidget);
  });

  testWidgets('selecting a stock from bottom sheet filters the list', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_list_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('茅台 (600519)'));
    await tester.pumpAndSettle();

    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsNothing);
  });

  testWidgets('clear button appears when filter is active and clears filters', (tester) async {
    await seedTwoStocksAndTrades();
    Get.put(TradelistController());

    await tester.pumpWidget(buildTestableWidget(const TradelistView()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.filter_list_off_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.filter_list_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('茅台 (600519)'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.filter_list_off_outlined), findsOneWidget);
    expect(find.text('平安 (000001)'), findsNothing);

    await tester.tap(find.byIcon(Icons.filter_list_off_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.filter_list_off_outlined), findsNothing);
    expect(find.text('茅台 (600519)'), findsOneWidget);
    expect(find.text('平安 (000001)'), findsOneWidget);
  });
}
