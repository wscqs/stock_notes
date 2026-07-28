# 全局未平仓交易列表页 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在股票详情页新增"交易"入口，跳转独立的跨股票未平仓交易列表页，支持查看、编辑、删除及跳转股票详情。

**Architecture:** 新建 `tradelist` GetX 模块承载独立页面；抽取公共 `StockTradeItem` 组件统一交易 cell 展示；抽取公共 `StockTradeDialog` 统一交易编辑弹窗；数据库新增跨股票交易查询。

**Tech Stack:** Flutter, GetX, Drift (SQLite), flutter_test

## Global Constraints

- 跨所有股票的未完成交易（平仓股数 ≠ 开仓股数）。
- 按交易日期降序排列，最新在前；交易日期相同时按创建时间降序。
- cell 复用现有 `_buildTradeItem` 样式，并在首行下方新增"股票名（代码）"一栏。
- 保留编辑和删除功能；点击条目跳转对应股票 `STOCKEDIT`。
- 全局列表不展示基于实时行情的未实现收益估算。
- 遵循现有 GetX 模块结构：`bindings/`、`controllers/`、`views/`。
- 所有代码变更需通过 `flutter test`。

---

## File Structure

| 文件 | 职责 |
|------|------|
| `lib/common/database/database.dart` | 新增 `getAllStockTrades()` 跨股票查询。 |
| `lib/common/extension/StockTrade++.dart` | 新增 `StockTrade` 扩展，提供 `isCompleted` 判断。 |
| `lib/common/widget/stock_trade_item.dart` | 公共交易条目组件，支持可选展示股票名/代码。 |
| `lib/common/widget/stock_trade_dialog.dart` | 公共交易编辑/新增弹窗组件。 |
| `lib/app/modules/tradelist/bindings/tradelist_binding.dart` | `TradelistController` 依赖注入。 |
| `lib/app/modules/tradelist/controllers/tradelist_controller.dart` | 加载、过滤、编辑、删除、跳转逻辑。 |
| `lib/app/modules/tradelist/views/tradelist_view.dart` | 独立交易列表页面。 |
| `lib/app/routes/app_routes.dart` | 新增 `TRADELIST` 路由常量。 |
| `lib/app/routes/app_pages.dart` | 注册 `TRADELIST` 路由。 |
| `lib/app/modules/stockedit/views/stockedit_view.dart` | AppBar 新增入口按钮；复用 `StockTradeItem`。 |
| `lib/app/modules/stockedit/controllers/stockedit_controller.dart` | 交易弹窗改为调用 `StockTradeDialog`。 |
| `test/database_all_trades_query_test.dart` | 验证 `getAllStockTrades()` 顺序与过滤。 |
| `test/stock_trade_item_test.dart` | 验证 `StockTradeItem` 展示与点击回调。 |
| `test/stock_trade_dialog_test.dart` | 验证弹窗字段与保存回调。 |
| `test/tradelist_controller_test.dart` | 验证 controller 加载、过滤、跳转逻辑。 |

---

### Task 1: Add `getAllStockTrades()` database query

**Files:**
- Modify: `lib/common/database/database.dart:524-525`
- Test: `test/database_all_trades_query_test.dart`

**Interfaces:**
- Produces: `Future<List<StockTrade>> getAllStockTrades()` on `AppDatabase`.

- [ ] **Step 1: Write the failing test**

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  setUp(() async {
    dbPath = '${Directory.systemTemp.path}/test_all_trades_${DateTime.now().millisecondsSinceEpoch}.db';
    db = AppDatabase(dbPath);
  });

  tearDown(() async {
    await db.close();
    final file = File(dbPath);
    if (await file.exists()) await file.delete();
  });

  group('getAllStockTrades', () {
    test('returns all trades ordered by tradeDate desc then createdAt desc', () async {
      final stock = await db.addStock(StockItemsCompanion.insert(
        marketType: 'sh',
        code: '600519',
        name: '茅台',
      ));
      final earlier = DateTime(2026, 7, 20);
      final later = DateTime(2026, 7, 25);

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stock,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        tradeDate: Value(earlier),
      ));
      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stock,
        tradeType: 1,
        openPrice: const Value('110'),
        openShares: const Value('10'),
        tradeDate: Value(later),
      ));

      final trades = await db.getAllStockTrades();
      expect(trades.length, 2);
      expect(trades.first.tradeDate, later);
      expect(trades.last.tradeDate, earlier);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/database_all_trades_query_test.dart -v`
Expected: FAIL with "The method 'getAllStockTrades' isn't defined".

- [ ] **Step 3: Add query implementation**

In `lib/common/database/database.dart`, after `getStockTradesByStockId`:

```dart
Future<List<StockTrade>> getAllStockTrades() {
  return (select(stockTrades)
        ..orderBy([
          (tbl) => OrderingTerm(
                expression: tbl.tradeDate,
                mode: OrderingMode.desc,
                nulls: NullsOrder.last,
              ),
          (tbl) => OrderingTerm(
                expression: tbl.createdAt,
                mode: OrderingMode.desc,
              ),
        ]))
      .get();
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/database_all_trades_query_test.dart -v`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/common/database/database.dart test/database_all_trades_query_test.dart
git commit -m "feat(db): add getAllStockTrades query ordered by tradeDate desc"
```

---

### Task 2: Extract trade completion helper

**Files:**
- Create: `lib/common/extension/StockTrade++.dart`
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart:1044-1048`
- Test: `test/stock_trade_completion_test.dart`

**Interfaces:**
- Produces: `bool isTradeCompleted(StockTrade trade)` in `lib/common/extension/StockTrade++.dart`.
- Consumes: Used by `StockeditController.incompleteTrades` and `TradelistController`.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';

void main() {
  group('isTradeCompleted', () {
    test('returns false when openShares or closeShares is null/empty', () {
      expect(_trade(openShares: null, closeShares: null).isCompleted, isFalse);
      expect(_trade(openShares: '100', closeShares: null).isCompleted, isFalse);
      expect(_trade(openShares: '100', closeShares: '').isCompleted, isFalse);
    });

    test('returns false when openShares != closeShares', () {
      expect(_trade(openShares: '100', closeShares: '50').isCompleted, isFalse);
    });

    test('returns true when openShares == closeShares and both > 0', () {
      expect(_trade(openShares: '100', closeShares: '100').isCompleted, isTrue);
    });

    test('returns false when shares are zero', () {
      expect(_trade(openShares: '0', closeShares: '0').isCompleted, isFalse);
    });
  });
}

StockTrade _trade({String? openShares, String? closeShares}) {
  final now = DateTime.now();
  return StockTrade(
    id: 1,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    openPrice: '10',
    openShares: openShares,
    closePrice: null,
    closeShares: closeShares,
    tradeDate: now,
  );
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/stock_trade_completion_test.dart -v`
Expected: FAIL with "Target of URI doesn't exist".

- [ ] **Step 3: Implement the extension**

Create `lib/common/extension/StockTrade++.dart`:

```dart
import 'package:stock_notes/common/database/database.dart';

extension StockTradeExt on StockTrade {
  bool get isCompleted {
    final open = double.tryParse(openShares ?? '');
    final close = double.tryParse(closeShares ?? '');
    return open != null && close != null && open > 0 && open == close;
  }
}
```

Note: Move the top-level `calculateTradeEstimateFromValues` function from `lib/app/modules/stockedit/controllers/stockedit_controller.dart` into this file as well, so `StockTradeItem` does not depend on the controller. Update the import in `stockedit_trade_estimate_test.dart` to `package:stock_notes/common/extension/StockTrade++.dart`.

- [ ] **Step 4: Update StockeditController to use the extension**

Replace `StockeditController._isTradeCompleted` with import and usage:

```dart
import 'package:stock_notes/common/extension/StockTrade++.dart';
```

Remove:

```dart
bool _isTradeCompleted(StockTrade trade) {
  final open = double.tryParse(trade.openShares ?? '');
  final close = double.tryParse(trade.closeShares ?? '');
  return open != null && close != null && open > 0 && open == close;
}
```

Update getters:

```dart
List<StockTrade> get incompleteTrades =>
    stockTrades.where((t) => !t.isCompleted).toList();

List<StockTrade> get completedTrades =>
    stockTrades.where((t) => t.isCompleted).toList();
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/stock_trade_completion_test.dart -v`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/common/extension/StockTrade++.dart lib/app/modules/stockedit/controllers/stockedit_controller.dart test/stock_trade_completion_test.dart
git commit -m "refactor(trade): extract isCompleted extension on StockTrade"
```

---

### Task 3: Create reusable `StockTradeItem` widget

**Files:**
- Create: `lib/common/widget/stock_trade_item.dart`
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart:416-542`
- Test: `test/stock_trade_item_test.dart`

**Interfaces:**
- Produces: `class StockTradeItem extends StatelessWidget` with constructor fields `trade`, `stock`, `onTap`, `onEdit`, `onDelete`, `currentPrice`.
- Consumes: Used by `StockeditView` and `TradelistView`.

- [ ] **Step 1: Write the failing test**

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/stock_trade_item_test.dart -v`
Expected: FAIL with "Target of URI doesn't exist".

- [ ] **Step 3: Implement `StockTradeItem`**

Create `lib/common/widget/stock_trade_item.dart`. Copy the existing `_buildTradeItem` and `_buildTradeEstimate` logic from `stockedit_view.dart`, then:

- Make it a `StatelessWidget`.
- Add fields: `trade`, `stock`, `onTap`, `onEdit`, `onDelete`, `currentPrice`.
- Replace the hard-coded `controller.calculateTradeEstimate(trade)` with a local helper that uses `currentPrice`.
- Add stock name/code row when `stock != null`.
- Wrap the card in `InkWell` or `GestureDetector` when `onTap != null`.

Implementation outline:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockTradeItem extends StatelessWidget {
  final StockTrade trade;
  final StockItem? stock;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? currentPrice;

  const StockTradeItem({
    super.key,
    required this.trade,
    this.stock,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.currentPrice,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.tradeType == 0;
    final estimate = calculateTradeEstimateFromValues(
      currentPrice: currentPrice,
      openPrice: trade.openPrice,
      closePrice: trade.closePrice,
      openShares: trade.openShares,
      closeShares: trade.closeShares,
      tradeType: trade.tradeType,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isBuy
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isBuy ? TextKey.buy.tr : TextKey.sale.tr,
                            style: TextStyle(
                              color: isBuy ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          (trade.tradeDate ?? trade.createdAt).toDateString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    if (stock != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${stock!.name} (${stock!.code})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Get.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${TextKey.kaicang.tr}: ${trade.openPrice ?? '-'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        if (trade.openShares != null && trade.openShares!.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Text(
                            "${TextKey.gushu.tr}: ${trade.openShares}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                    if (trade.closePrice != null && trade.closePrice!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${TextKey.pingcang.tr}: ${trade.closePrice}",
                            style: TextStyle(fontSize: 14),
                          ),
                          if (trade.closeShares != null && trade.closeShares!.isNotEmpty) ...[
                            const SizedBox(width: 16),
                            Text(
                              "${TextKey.gushu.tr}: ${trade.closeShares}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (trade.remark != null && trade.remark!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "${TextKey.beizui.tr}: ${trade.remark}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Icon(Icons.edit, size: 18, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildTradeEstimate(estimate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeEstimate(({double? yieldRate, double? profit}) estimate) {
    final yieldRate = estimate.yieldRate;
    final valueColor = yieldRate == null
        ? Colors.grey
        : (yieldRate > 0 ? Colors.red : (yieldRate < 0 ? Colors.green : Colors.grey));
    final labelStyle = TextStyle(color: Colors.grey, fontSize: 12);
    final valueStyle = TextStyle(color: valueColor, fontSize: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: "${TextKey.shouyilv.tr}: ", style: labelStyle),
          TextSpan(
            text: yieldRate == null ? "-" : "${(yieldRate * 100).toStringAsFixed(1)}%",
            style: valueStyle,
          ),
        ])),
        if (estimate.profit != null)
          Text.rich(TextSpan(children: [
            TextSpan(text: "${TextKey.shouyie.tr}: ", style: labelStyle),
            TextSpan(text: estimate.profit!.toStringAsFixed(2), style: valueStyle),
          ])),
      ],
    );
  }
}
```

- [ ] **Step 4: Update `StockeditView` to use `StockTradeItem`**

In `lib/app/modules/stockedit/views/stockedit_view.dart`:

1. Add import:

```dart
import 'package:stock_notes/common/widget/stock_trade_item.dart';
```

2. Remove `_buildTradeItem` and `_buildTradeEstimate` methods.
3. Update references:
   - `controller.showAllTradesSheet(_buildTradeItem)` → pass a local closure using `StockTradeItem`.
   - `StockTradeListWithMore(buildTradeItem: _buildTradeItem, ...)` → use a closure.

Example replacement in `_jiaoyijilu`:

```dart
Widget _buildTradeItemForStock(StockTrade trade) {
  return StockTradeItem(
    trade: trade,
    currentPrice: controller.serStockData.value.currentPrice,
    onEdit: () => controller.editTrade(trade),
    onDelete: () => controller.deleteTrade(trade),
  );
}
```

Then update calls:

```dart
controller.showAllTradesSheet(_buildTradeItemForStock),
```

```dart
StockTradeListWithMore(
  trades: trades,
  buildTradeItem: _buildTradeItemForStock,
  onShowAll: () => controller.showAllTradesSheet(_buildTradeItemForStock),
),
```

- [ ] **Step 5: Run tests**

Run: `flutter test test/stock_trade_item_test.dart test/stockedit_trade_list_test.dart -v`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/common/widget/stock_trade_item.dart lib/app/modules/stockedit/views/stockedit_view.dart test/stock_trade_item_test.dart
git commit -m "feat(ui): add reusable StockTradeItem widget"
```

---

### Task 4: Extract reusable `StockTradeDialog`

**Files:**
- Create: `lib/common/widget/stock_trade_dialog.dart`
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart:1093-1310`
- Test: `test/stock_trade_dialog_test.dart`

**Interfaces:**
- Produces: `class StockTradeDialog` with static `show(...)` method.
- Consumes: Called by `StockeditController.editTrade` / `showAddTradeDialog` and `TradelistController.editTrade`.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
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
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/stock_trade_dialog_test.dart -v`
Expected: FAIL with "Target of URI doesn't exist".

- [ ] **Step 3: Extract the dialog**

Create `lib/common/widget/stock_trade_dialog.dart` by copying `_showTradeDialog` logic from `StockeditController`. Convert it into a stateless/static helper:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockTradeDialog {
  static void show({
    required BuildContext context,
    required StockTrade? existingTrade,
    required String currentPrice,
    required VoidCallback onSaved,
  }) {
    final tradeType = (existingTrade?.tradeType ?? 0).obs;
    final tradeDate = (existingTrade?.tradeDate ?? DateTime.now()).obs;
    final openPriceController = TextEditingController(
      text: existingTrade?.openPrice ?? existingTrade?.price ?? '',
    );
    final openSharesController = TextEditingController(
      text: existingTrade?.openShares ?? existingTrade?.shares ?? '',
    );
    final closePriceController = TextEditingController(
      text: existingTrade?.closePrice ?? '',
    );
    final closeSharesController = TextEditingController(
      text: existingTrade?.closeShares ?? '',
    );
    final planBuyPriceController = TextEditingController(
      text: existingTrade?.planBuyPrice ?? '',
    );
    final planSalePriceController = TextEditingController(
      text: existingTrade?.planSalePrice ?? '',
    );
    final tradeRemarkController = TextEditingController(
      text: existingTrade?.remark ?? '',
    );

    final planBuyPoints = 0.0.obs;
    final planSalePoints = 0.0.obs;

    void updatePlanPricePoints() {
      final current = double.tryParse(currentPrice);
      final buyPrice = double.tryParse(planBuyPriceController.text);
      final salePrice = double.tryParse(planSalePriceController.text);
      planBuyPoints.value = (current != null && current != 0 && buyPrice != null)
          ? (buyPrice - current) / current
          : 0.0;
      planSalePoints.value = (current != null && current != 0 && salePrice != null)
          ? (salePrice - current) / current
          : 0.0;
    }

    updatePlanPricePoints();

    Get.dialog(AlertDialog(
      title: Text(existingTrade != null ? TextKey.xiugai.tr : TextKey.xinzengjiaoyi.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
              children: [
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(TextKey.buy.tr),
                  selected: tradeType.value == 0,
                  onSelected: (selected) { if (selected) tradeType.value = 0; },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(TextKey.sale.tr),
                  selected: tradeType.value == 1,
                  onSelected: (selected) { if (selected) tradeType.value = 1; },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey(tradeDate.value),
                    readOnly: true,
                    textAlign: TextAlign.center,
                    initialValue: DateFormat('yyyy-MM-dd').format(tradeDate.value),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tradeDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) tradeDate.value = picked;
                    },
                  ),
                ),
              ],
            )),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.kaicang.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: openPriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: openSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.pingcang.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: closePriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: closeSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.jihua.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final label = planBuyPoints.value == 0.0
                        ? TextKey.maijia.tr
                        : "${TextKey.maijia.tr}: ${(planBuyPoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planBuyPriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: label),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final label = planSalePoints.value == 0.0
                        ? TextKey.maijia_s.tr
                        : "${TextKey.maijia_s.tr}: ${(planSalePoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planSalePriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: label),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: tradeRemarkController,
              maxLines: 2,
              decoration: InputDecoration(labelText: TextKey.beizui.tr),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: Text(TextKey.quxiao.tr)),
        TextButton(
          onPressed: () {
            // Caller is responsible for validation and persistence.
            onSaved();
          },
          child: Text(TextKey.queding.tr),
        ),
      ],
    ));
  }
}
```

Note: This dialog only collects values; the caller must validate, build the `StockTradesCompanion`, and persist it.

- [ ] **Step 4: Update `StockeditController` to use the dialog**

In `lib/app/modules/stockedit/controllers/stockedit_controller.dart`:

1. Add imports:

```dart
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';
```

2. Replace `_showTradeDialog` method with:

```dart
void _showTradeDialog({StockTrade? existingTrade}) {
  StockTradeDialog.show(
    context: Get.context!,
    existingTrade: existingTrade,
    currentPrice: serStockData.value.currentPrice ?? '',
    onSaved: () {
      if (existingTrade != null) {
        updateTrade(existingTrade);
      } else {
        addTrade();
      }
    },
  );
}
```

Wait — `addTrade` and `updateTrade` currently read from the controller's `TextEditingController`s (`openPriceController`, etc.). After extracting the dialog, those controllers are no longer populated. Therefore we must change the dialog to return values, OR change `addTrade`/`updateTrade` to accept values.

**Decision:** Change dialog to return a `StockTradesCompanion` via callback, and update `addTrade`/`updateTrade` to accept the companion.

Revised dialog `onSaved` signature:

```dart
required void Function(StockTradesCompanion companion) onSaved
```

Inside dialog confirm button:

```dart
onPressed: () {
  var companion = StockTradesCompanion.insert(
    stockId: existingTrade?.stockId ?? 0,
    tradeType: tradeType.value,
    openPrice: Value(openPriceController.text),
    openShares: Value(openSharesController.text),
    closePrice: Value(closePriceController.text),
    closeShares: Value(closeSharesController.text),
    planBuyPrice: Value(planBuyPriceController.text),
    planSalePrice: Value(planSalePriceController.text),
    remark: Value(tradeRemarkController.text),
    tradeDate: Value(tradeDate.value),
  );
  if (existingTrade != null) {
    companion = companion.copyWith(id: Value(existingTrade.id));
  }
  onSaved(companion);
}
```

Note: The dialog does **not** call `Get.back()` after `onSaved`; the caller decides whether to close (e.g. after validation/persistence).

Then `StockeditController`:

```dart
void _showTradeDialog({StockTrade? existingTrade}) {
  StockTradeDialog.show(
    context: Get.context!,
    existingTrade: existingTrade,
    currentPrice: serStockData.value.currentPrice ?? '',
    onSaved: (companion) {
      if (existingTrade != null) {
        _doUpdateTrade(companion);
      } else {
        _doAddTrade(companion);
      }
    },
  );
}

Future<void> _doAddTrade(StockTradesCompanion companion) async {
  if ((companion.openPrice.value ?? '').isEmpty) {
    QsHud.showToast("${TextKey.qingshuru.tr}${TextKey.kaicang.tr}${TextKey.jiage.tr}");
    return;
  }
  final item = companion.copyWith(stockId: Value(localStockData.value!.id));
  await db.addStockTrade(item);
  Get.back();
  QsHud.showToast(TextKey.success.tr);
  loadTrades();
}

Future<void> _doUpdateTrade(StockTradesCompanion companion) async {
  if ((companion.openPrice.value ?? '').isEmpty) {
    QsHud.showToast("${TextKey.qingshuru.tr}${TextKey.kaicang.tr}${TextKey.jiage.tr}");
    return;
  }
  await db.updateStockTrade(companion);
  Get.back();
  QsHud.showToast(TextKey.success.tr);
  loadTrades();
}
```

Remove the now-unused controller fields: `openPriceController`, `openSharesController`, `closePriceController`, `closeSharesController`, `planBuyPriceController`, `planSalePriceController`, `tradeRemarkController`, `tradeType`, `tradeDate`.

Update `onClose` to remove disposal of those controllers.

Update `calculateTrade` method (if still present) to import `calculateTradeEstimateFromValues` from `StockTrade++.dart`.

- [ ] **Step 5: Run tests**

Run: `flutter test test/stock_trade_dialog_test.dart test/stockedit_trade_estimate_test.dart -v`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/common/widget/stock_trade_dialog.dart lib/app/modules/stockedit/controllers/stockedit_controller.dart test/stock_trade_dialog_test.dart
git commit -m "refactor(dialog): extract reusable StockTradeDialog"
```

---

### Task 5: Create `tradelist` module

**Files:**
- Create: `lib/app/modules/tradelist/bindings/tradelist_binding.dart`
- Create: `lib/app/modules/tradelist/controllers/tradelist_controller.dart`
- Create: `lib/app/modules/tradelist/views/tradelist_view.dart`
- Test: `test/tradelist_controller_test.dart`

**Interfaces:**
- Produces: `TradelistBinding`, `TradelistController`, `TradelistView`.
- Consumes: `Routes.TRADELIST` (Task 6), `StockTradeItem` (Task 3), `StockTradeDialog` (Task 4).

- [ ] **Step 1: Write the failing controller test**

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/tradelist/controllers/tradelist_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  late AppDatabase db;
  late String dbPath;

  setUp(() async {
    dbPath = '${Directory.systemTemp.path}/test_tradelist_${DateTime.now().millisecondsSinceEpoch}.db';
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

  group('TradelistController', () {
    test('loadTrades filters only incomplete trades across all stocks', () async {
      final stockA = await db.addStock(StockItemsCompanion.insert(
        marketType: 'sh', code: '600519', name: '茅台',
      ));
      final stockB = await db.addStock(StockItemsCompanion.insert(
        marketType: 'sh', code: '000001', name: '平安',
      ));

      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockA,
        tradeType: 0,
        openPrice: const Value('100'),
        openShares: const Value('10'),
        closeShares: const Value('5'),
        tradeDate: Value(DateTime(2026, 7, 25)),
      ));
      await db.addStockTrade(StockTradesCompanion.insert(
        stockId: stockB,
        tradeType: 1,
        openPrice: const Value('200'),
        openShares: const Value('10'),
        closeShares: const Value('10'),
        tradeDate: Value(DateTime(2026, 7, 26)),
      ));

      final controller = TradelistController();
      controller.onInit();
      await controller.loadTrades();

      expect(controller.trades.length, 1);
      expect(controller.trades.first.stockId, stockA);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/tradelist_controller_test.dart -v`
Expected: FAIL with "Target of URI doesn't exist".

- [ ] **Step 3: Implement the module**

Create `lib/app/modules/tradelist/bindings/tradelist_binding.dart`:

```dart
import 'package:get/get.dart';
import '../controllers/tradelist_controller.dart';

class TradelistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradelistController>(() => TradelistController());
  }
}
```

Create `lib/app/modules/tradelist/controllers/tradelist_controller.dart`:

```dart
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/base/base_controller.dart';
import 'package:stock_notes/app/routes/app_pages.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';
import 'package:stock_notes/utils/qs_hud.dart';

class TradelistController extends BaseController {
  final db = Get.find<DatabaseManager>().db;
  final trades = <StockTrade>[].obs;
  final stockMap = <int, StockItem>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrades();
  }

  Future<void> loadTrades() async {
    final allTrades = await db.getAllStockTrades();
    final incomplete = allTrades.where((t) => !t.isCompleted).toList();
    await _loadStockMap(incomplete);
    trades.value = incomplete;
  }

  Future<void> _loadStockMap(List<StockTrade> trades) async {
    final stockIds = trades.map((t) => t.stockId).toSet().toList();
    if (stockIds.isEmpty) {
      stockMap.clear();
      return;
    }
    final stocks = await db.getStockItemsByIds(stockIds);
    stockMap.value = {for (final s in stocks) s.id: s};
  }

  void editTrade(StockTrade trade) {
    final stock = stockMap[trade.stockId];
    StockTradeDialog.show(
      context: Get.context!,
      existingTrade: trade,
      currentPrice: stock?.currentPrice ?? '',
      onSaved: (companion) async {
        if ((companion.openPrice.value ?? '').isEmpty) {
          QsHud.showToast('请输入开仓价格');
          return;
        }
        await db.updateStockTrade(companion);
        Get.back();
        QsHud.showToast('成功');
        await loadTrades();
      },
    );
  }

  void deleteTrade(StockTrade trade) {
    QsHud.showConfirmDialog(
      title: '确认删除',
      content: '',
      onConfirm: () async {
        await db.deleteStockTrade(trade);
        await loadTrades();
      },
    );
  }

  void openStockDetail(StockTrade trade) {
    final stock = stockMap[trade.stockId];
    if (stock == null) {
      QsHud.showToast('股票不存在');
      return;
    }
    Get.toNamed(Routes.STOCKEDIT, arguments: stock);
  }
}
```

Note: `getStockItemsByIds` will be added in this task (see below).

Add `getStockItemsByIds` to `lib/common/database/database.dart`:

```dart
Future<List<StockItem>> getStockItemsByIds(List<int> ids) {
  return (select(stockItems)..where((tbl) => tbl.id.isIn(ids))).get();
}
```

Create `lib/app/modules/tradelist/views/tradelist_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/tradelist/controllers/tradelist_controller.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/qs_empty_view.dart';
import 'package:stock_notes/common/widget/stock_trade_item.dart';

class TradelistView extends GetView<TradelistController> {
  const TradelistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.jiaoyi.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.trades.isEmpty) {
          return QsEmptyView(message: TextKey.noData.tr);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.trades.length,
          itemBuilder: (context, index) {
            final trade = controller.trades[index];
            final stock = controller.stockMap[trade.stockId];
            return StockTradeItem(
              trade: trade,
              stock: stock,
              onTap: () => controller.openStockDetail(trade),
              onEdit: () => controller.editTrade(trade),
              onDelete: () => controller.deleteTrade(trade),
            );
          },
        );
      }),
    );
  }
}
```

- [ ] **Step 4: Run tests**

Run: `flutter test test/tradelist_controller_test.dart -v`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/tradelist/ lib/common/database/database.dart test/tradelist_controller_test.dart
git commit -m "feat(tradelist): add tradelist module with controller and view"
```

---

### Task 6: Register `TRADELIST` route

**Files:**
- Modify: `lib/app/routes/app_routes.dart`
- Modify: `lib/app/routes/app_pages.dart`

**Interfaces:**
- Produces: `Routes.TRADELIST` and corresponding `GetPage`.

- [ ] **Step 1: Add route constant**

In `lib/app/routes/app_routes.dart`:

```dart
static const TRADELIST = _Paths.TRADELIST;
```

In `_Paths`:

```dart
static const TRADELIST = '/tradelist';
```

- [ ] **Step 2: Register page**

In `lib/app/routes/app_pages.dart`:

Add import:

```dart
import '../modules/tradelist/bindings/tradelist_binding.dart';
import '../modules/tradelist/views/tradelist_view.dart';
```

Add route in `routes` list:

```dart
GetPage(
  name: _Paths.TRADELIST,
  page: () => const TradelistView(),
  binding: TradelistBinding(),
),
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/app/routes/app_pages.dart lib/app/routes/app_routes.dart`
Expected: No issues.

- [ ] **Step 4: Commit**

```bash
git add lib/app/routes/app_routes.dart lib/app/routes/app_pages.dart
git commit -m "feat(routes): register TRADELIST route"
```

---

### Task 7: Add entry button in `StockeditView`

**Files:**
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart:28-46`

**Interfaces:**
- Consumes: `Routes.TRADELIST`.

- [ ] **Step 1: Add the button**

In `StockeditView` AppBar `actions`, add after the save/complete buttons:

```dart
IconButton(
  icon: const Icon(Icons.trending_up),
  tooltip: TextKey.jiaoyi.tr,
  onPressed: () => Get.toNamed(Routes.TRADELIST),
),
```

Make sure `app_routes.dart` is imported (it already is via `app_pages.dart` if needed; add explicit import if not).

- [ ] **Step 2: Verify UI**

Run: `flutter test test/widget_test.dart` or just `flutter analyze`.
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart
git commit -m "feat(stockedit): add trades entry button to app bar"
```

---

### Task 8: Full test run and final review

**Files:**
- All modified files.

- [ ] **Step 1: Run full test suite**

Run: `flutter test`
Expected: All tests pass.

- [ ] **Step 2: Run static analysis**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 3: Format code**

Run: `dart format lib test --fix`
Expected: Files formatted.

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "chore: format and finalize global trades list feature"
```

---

## Self-Review Checklist

- [ ] Spec coverage: every requirement in `2026-07-28-global-unclosed-trades-list-design.md` maps to a task.
- [ ] No placeholders: no "TBD", "TODO", or vague steps.
- [ ] Type consistency: `StockTradeItem`, `StockTradeDialog`, `TradelistController` use matching names and signatures.
- [ ] Test coverage: database query, completion logic, widget rendering, dialog behavior, controller filtering.
- [ ] Route wiring: `Routes.TRADELIST` and `GetPage` registered.
- [ ] Cleanup: unused controllers removed from `StockeditController` after dialog extraction.

## Execution Options

**Plan complete and saved to `docs/superpowers/plans/2026-07-28-global-unclosed-trades-list.md`.**

Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration.
2. **Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints.

Which approach would you like?
