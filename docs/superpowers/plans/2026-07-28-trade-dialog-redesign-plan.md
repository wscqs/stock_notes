# 交易弹窗重构实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将股票详情页的交易弹窗从单一价格/股数升级为同时记录开仓、平仓、计划买价/卖价，并同步更新数据模型、收益计算与交易卡片展示。

**Architecture:** 数据库层通过 Drift migration 扩展 `StockTrades` 表；计算层把收益逻辑从单一成交价改为基于开仓价/平仓价/当前价；UI 层在弹窗中分组展示字段，在交易卡片中展示实际收益或浮盈。

**Tech Stack:** Flutter, GetX, Drift, flutter_screenutil

## Global Constraints

- 交易方向：买 = 先买后卖（做多），卖 = 先卖后买（做空）。
- 旧 `price/shares` 迁移为 `openPrice/openShares`。
- 开仓价必填，其余字段可选。
- 已平仓判断条件：`openShares` 有效且等于 `closeShares`。
- 计划价格仅记录，不触发提醒。
- 视觉样式与现有盈亏色一致：红涨绿跌灰平。
- 所有字符串文案必须通过 `TextKey` + `.tr` 国际化。

---

## File Structure

- **Modify:** `lib/common/database/tables.dart`
  - 为 `StockTrades` 新增 6 个字段。
- **Modify:** `lib/common/database/database.dart`
  - `schemaVersion` 升 7，添加 migration 复制旧数据。
- **Modify:** `lib/common/database/database.g.dart`
  - 运行 `dart run build_runner build` 重新生成。
- **Modify:** `lib/common/langs/text_key.dart`
  - 新增开仓、平仓、计划买价、计划卖价等文案键。
- **Modify:** `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
  - 新增控制器、改造弹窗 UI、保存/更新逻辑、收益计算。
- **Modify:** `lib/app/modules/stockedit/views/stockedit_view.dart`
  - 改造交易卡片展示。
- **Create/Modify:** `test/trade_estimate_test.dart`
  - 新增收益计算单元测试。

---

### Task 1: 扩展数据库表与迁移

**Files:**
- Modify: `lib/common/database/tables.dart`
- Modify: `lib/common/database/database.dart`
- Modify: `lib/common/database/database.g.dart`（通过 build_runner 生成）

**Interfaces:**
- Produces: `StockTrades` 表新增 `openPrice`、`openShares`、`closePrice`、`closeShares`、`planBuyPrice`、`planSalePrice` 六个可空文本列。

- [ ] **Step 1: 新增字段到 tables.dart**

在 `lib/common/database/tables.dart` 的 `StockTrades` 表末尾追加：

```dart
class StockTrades extends Table with TableMixin {
  IntColumn get stockId => integer().references(StockItems, #id)();
  IntColumn get tradeType => integer()(); // 0=买, 1=卖
  TextColumn get price => text().nullable()();
  TextColumn get shares => text().nullable()();
  TextColumn get remark => text().nullable()();
  DateTimeColumn get tradeDate => dateTime().nullable()();

  TextColumn get openPrice => text().nullable()();
  TextColumn get openShares => text().nullable()();
  TextColumn get closePrice => text().nullable()();
  TextColumn get closeShares => text().nullable()();
  TextColumn get planBuyPrice => text().nullable()();
  TextColumn get planSalePrice => text().nullable()();
}
```

- [ ] **Step 2: 升级 schemaVersion 并添加迁移逻辑**

在 `lib/common/database/database.dart`：

1. 把 `schemaVersion` 从 `6` 改为 `7`：

```dart
@override
int get schemaVersion => 7;
```

2. 在 `onUpgrade` 中追加 `from <= 6` 分支：

```dart
if (from <= 6) {
  await migrator.addColumn(stockTrades, stockTrades.openPrice);
  await migrator.addColumn(stockTrades, stockTrades.openShares);
  await migrator.addColumn(stockTrades, stockTrades.closePrice);
  await migrator.addColumn(stockTrades, stockTrades.closeShares);
  await migrator.addColumn(stockTrades, stockTrades.planBuyPrice);
  await migrator.addColumn(stockTrades, stockTrades.planSalePrice);
  await customStatement(
    'UPDATE stock_trades SET open_price = price, open_shares = shares',
  );
}
```

- [ ] **Step 3: 重新生成 Drift 代码**

运行：

```bash
dart run build_runner build
```

Expected: 生成或更新 `lib/common/database/database.g.dart`，无报错。

- [ ] **Step 4: 验证静态分析**

运行：

```bash
flutter analyze lib/common/database/tables.dart lib/common/database/database.dart
```

Expected: 无新增错误。

- [ ] **Step 5: Commit**

```bash
git add lib/common/database/tables.dart lib/common/database/database.dart lib/common/database/database.g.dart
git commit -m "feat(db): add open/close/plan columns to stock_trades and migrate v6 to v7"
```

---

### Task 2: 添加国际化文案键

**Files:**
- Modify: `lib/common/langs/text_key.dart`

**Interfaces:**
- Produces: 新增 `TextKey` 常量及中英文翻译，供弹窗与卡片使用。

- [ ] **Step 1: 新增常量**

在 `TextKey` 类末尾追加：

```dart
static const kaicang = 'kaicang';
static const pingcang = 'pingcang';
static const jihuamaijia = 'jihuamaijia';
static const jihuamaijia_s = 'jihuamaijia_s';
```

- [ ] **Step 2: 添加中文翻译**

在 `const Map<String, String> zh` 中追加：

```dart
TextKey.kaicang: '开仓',
TextKey.pingcang: '平仓',
TextKey.jihuamaijia: '计划买价',
TextKey.jihuamaijia_s: '计划卖价',
```

- [ ] **Step 3: 添加英文翻译**

在 `const Map<String, String> en` 中追加：

```dart
TextKey.kaicang: 'Open',
TextKey.pingcang: 'Close',
TextKey.jihuamaijia: 'Plan Buy',
TextKey.jihuamaijia_s: 'Plan Sale',
```

- [ ] **Step 4: Commit**

```bash
git add lib/common/langs/text_key.dart
git commit -m "feat(i18n): add trade dialog open/close/plan price text keys"
```

---

### Task 3: 改造收益计算函数并添加单元测试

**Files:**
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
- Create: `test/trade_estimate_test.dart`

**Interfaces:**
- Consumes: 新计算函数接收 `currentPrice`、`openPrice`、`closePrice`、`openShares`、`closeShares`、`tradeType`。
- Produces: `({double? yieldRate, double? profit}) calculateTradeEstimateFromValues(...)` 新签名。

- [ ] **Step 1: 替换收益计算函数**

把 `lib/app/modules/stockedit/controllers/stockedit_controller.dart` 顶部的：

```dart
({double? yieldRate, double? profit}) calculateTradeEstimateFromValues({
  required String? currentPrice,
  required String? tradePrice,
  required String? shares,
  required int tradeType,
})
```

替换为：

```dart
({double? yieldRate, double? profit}) calculateTradeEstimateFromValues({
  required String? currentPrice,
  required String? openPrice,
  required String? closePrice,
  required String? openShares,
  required String? closeShares,
  required int tradeType,
})
```

实现改为：

```dart
({double? yieldRate, double? profit}) calculateTradeEstimateFromValues({
  required String? currentPrice,
  required String? openPrice,
  required String? closePrice,
  required String? openShares,
  required String? closeShares,
  required int tradeType,
}) {
  if (currentPrice == null ||
      currentPrice.isEmpty ||
      openPrice == null ||
      openPrice.isEmpty) {
    return (yieldRate: null, profit: null);
  }

  final current = double.tryParse(currentPrice);
  final open = double.tryParse(openPrice);
  if (current == null || open == null || open == 0) {
    return (yieldRate: null, profit: null);
  }

  final isShort = tradeType == 1; // 卖 = 先卖后买
  final yieldRate =
      isShort ? (open - current) / open : (current - open) / open;

  double? profit;
  final openCount = double.tryParse(openShares ?? '');
  final closeCount = double.tryParse(closeShares ?? '');
  final hasClose = closePrice != null && closePrice.isNotEmpty;
  final close = hasClose ? double.tryParse(closePrice) : null;

  if (openCount != null && openCount > 0) {
    if (closeCount != null &&
        closeCount > 0 &&
        openCount == closeCount &&
        close != null) {
      profit = isShort ? (open - close) * openCount : (close - open) * openCount;
    } else if (current != null) {
      profit = isShort ? (open - current) * openCount : (current - open) * openCount;
    }
  }

  return (yieldRate: yieldRate, profit: profit);
}
```

- [ ] **Step 2: 创建单元测试文件**

创建 `test/trade_estimate_test.dart`：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';

void main() {
  group('calculateTradeEstimateFromValues', () {
    test('做多未平仓按当前价计算浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('做多已平仓按实际价差计算', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '10',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(150.0, 0.0001));
    });

    test('做空未平仓按当前价计算浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '90',
        openPrice: '100',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('做空已平仓按实际价差计算', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '95',
        openPrice: '100',
        closePrice: '90',
        openShares: '10',
        closeShares: '10',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('开仓价无效返回 null', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '100',
        openPrice: '',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, isNull);
      expect(result.profit, isNull);
    });

    test('股数不一致按当前价浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '5',
        tradeType: 0,
      );
      expect(result.profit, closeTo(100.0, 0.0001));
    });
  });
}
```

- [ ] **Step 3: 运行测试验证失败/通过**

运行：

```bash
flutter test test/trade_estimate_test.dart
```

Expected: 先失败（函数签名未改完时），改完后全部 PASS。

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/stockedit/controllers/stockedit_controller.dart test/trade_estimate_test.dart
git commit -m "feat(stockedit): rework trade estimate for open/close model and add tests"
```

---

### Task 4: 改造弹窗 UI 与保存逻辑

**Files:**
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart`

**Interfaces:**
- Consumes: 新数据库字段、新 `TextKey`、新收益计算函数。
- Produces: 弹窗中新增 6 个输入框，保存/更新写入新字段。

- [ ] **Step 1: 新增控制器与状态初始化**

在 `StockeditController` 的 `//交易记录` 区域，把：

```dart
final tradePriceController = TextEditingController();
final tradeSharesController = TextEditingController();
final tradeRemarkController = TextEditingController();
```

替换为：

```dart
final openPriceController = TextEditingController();
final openSharesController = TextEditingController();
final closePriceController = TextEditingController();
final closeSharesController = TextEditingController();
final planBuyPriceController = TextEditingController();
final planSalePriceController = TextEditingController();
final tradeRemarkController = TextEditingController();
```

- [ ] **Step 2: 更新 onClose 中控制器释放**

把：

```dart
tradePriceController.dispose();
tradeSharesController.dispose();
tradeRemarkController.dispose();
```

替换为：

```dart
openPriceController.dispose();
openSharesController.dispose();
closePriceController.dispose();
closeSharesController.dispose();
planBuyPriceController.dispose();
planSalePriceController.dispose();
tradeRemarkController.dispose();
```

- [ ] **Step 3: 改造 _showTradeDialog**

把 `_showTradeDialog` 中的字段初始化：

```dart
tradePriceController.text = existingTrade?.price ?? "";
tradeSharesController.text = existingTrade?.shares ?? "";
tradeRemarkController.text = existingTrade?.remark ?? "";
```

替换为：

```dart
openPriceController.text = existingTrade?.openPrice ?? existingTrade?.price ?? "";
openSharesController.text = existingTrade?.openShares ?? existingTrade?.shares ?? "";
closePriceController.text = existingTrade?.closePrice ?? "";
closeSharesController.text = existingTrade?.closeShares ?? "";
planBuyPriceController.text = existingTrade?.planBuyPrice ?? "";
planSalePriceController.text = existingTrade?.planSalePrice ?? "";
tradeRemarkController.text = existingTrade?.remark ?? "";
```

- [ ] **Step 4: 替换弹窗内容字段区**

把原来的“价格/股数” Row：

```dart
Row(
  children: [
    Expanded(
      child: TextField(
        controller: tradePriceController,
        decoration: InputDecoration(labelText: TextKey.jiage.tr),
        keyboardType: TextInputType.number,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: TextField(
        controller: tradeSharesController,
        decoration: InputDecoration(labelText: TextKey.gushu.tr),
        keyboardType: TextInputType.number,
      ),
    ),
  ],
),
```

替换为按分组展示的三个 Row：

```dart
// 开仓
Row(
  children: [
    Expanded(
      child: TextField(
        controller: openPriceController,
        decoration: InputDecoration(labelText: "${TextKey.kaicang.tr}${TextKey.jiage.tr}"),
        keyboardType: TextInputType.number,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: TextField(
        controller: openSharesController,
        decoration: InputDecoration(labelText: "${TextKey.kaicang.tr}${TextKey.gushu.tr}"),
        keyboardType: TextInputType.number,
      ),
    ),
  ],
),
const SizedBox(height: 8),
// 平仓
Row(
  children: [
    Expanded(
      child: TextField(
        controller: closePriceController,
        decoration: InputDecoration(labelText: "${TextKey.pingcang.tr}${TextKey.jiage.tr}"),
        keyboardType: TextInputType.number,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: TextField(
        controller: closeSharesController,
        decoration: InputDecoration(labelText: "${TextKey.pingcang.tr}${TextKey.gushu.tr}"),
        keyboardType: TextInputType.number,
      ),
    ),
  ],
),
const SizedBox(height: 8),
// 计划价格
Row(
  children: [
    Expanded(
      child: TextField(
        controller: planBuyPriceController,
        decoration: InputDecoration(labelText: TextKey.jihuamaijia.tr),
        keyboardType: TextInputType.number,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: TextField(
        controller: planSalePriceController,
        decoration: InputDecoration(labelText: TextKey.jihuamaijia_s.tr),
        keyboardType: TextInputType.number,
      ),
    ),
  ],
),
```

- [ ] **Step 5: 修改保存校验逻辑**

把 `addTrade` 和 `updateTrade` 中的：

```dart
if (tradePriceController.text.isEmpty) {
  QsHud.showToast("${TextKey.qingshuru.tr}${TextKey.jiage.tr}");
  return;
}
```

替换为：

```dart
if (openPriceController.text.isEmpty) {
  QsHud.showToast("${TextKey.qingshuru.tr}${TextKey.kaicang.tr}${TextKey.jiage.tr}");
  return;
}
```

- [ ] **Step 6: 修改保存/更新写入字段**

把 `addTrade` 中的：

```dart
final item = StockTradesCompanion.insert(
  stockId: localStockData.value!.id,
  tradeType: tradeType.value,
  price: Value(tradePriceController.text),
  shares: Value(tradeSharesController.text),
  remark: Value(tradeRemarkController.text),
  tradeDate: Value(tradeDate.value),
);
```

替换为：

```dart
final item = StockTradesCompanion.insert(
  stockId: localStockData.value!.id,
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
```

`updateTrade` 中的 companion 同样替换，并保留 `id: Value(trade.id)` 和 `stockId: trade.stockId`。

- [ ] **Step 7: 验证静态分析**

运行：

```bash
flutter analyze lib/app/modules/stockedit/controllers/stockedit_controller.dart
```

Expected: 无新增错误。

- [ ] **Step 8: Commit**

```bash
git add lib/app/modules/stockedit/controllers/stockedit_controller.dart
git commit -m "feat(stockedit): redesign trade dialog with open/close/plan prices"
```

---

### Task 5: 改造交易卡片展示

**Files:**
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart`

**Interfaces:**
- Consumes: `StockTrade` 的 `openPrice`、`openShares`、`closePrice`、`closeShares`，以及 `controller.calculateTradeEstimate(trade)`。
- Produces: 交易卡片显示开仓/平仓信息与实际收益/浮盈。

- [ ] **Step 1: 修改 _buildTradeItem 的字段展示**

找到 `_buildTradeItem` 中显示“价格/股数”的 `Row`（第 443–457 行）：

```dart
Row(
  children: [
    Text(
      "${TextKey.jiage.tr}: ${trade.price ?? '-'}",
      style: TextStyle(fontSize: 14),
    ),
    if (trade.shares != null && trade.shares!.isNotEmpty) ...[
      const SizedBox(width: 16),
      Text(
        "${TextKey.gushu.tr}: ${trade.shares}",
        style: TextStyle(fontSize: 14),
      ),
    ],
  ],
),
```

替换为展示开仓/平仓：

```dart
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

- [ ] **Step 2: 更新收益计算调用**

把 `controller.calculateTradeEstimate(trade)` 的内部实现改为调用新的 `calculateTradeEstimateFromValues`：

```dart
({double? yieldRate, double? profit}) calculateTradeEstimate(
    StockTrade trade) {
  return calculateTradeEstimateFromValues(
    currentPrice: serStockData.value.currentPrice,
    openPrice: trade.openPrice,
    closePrice: trade.closePrice,
    openShares: trade.openShares,
    closeShares: trade.closeShares,
    tradeType: trade.tradeType,
  );
}
```

- [ ] **Step 3: 验证静态分析**

运行：

```bash
flutter analyze lib/app/modules/stockedit/views/stockedit_view.dart
```

Expected: 无新增错误。

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart
git commit -m "feat(stockedit): display open/close info and yield in trade cards"
```

---

### Task 6: 回归测试与静态分析

**Files:**
- All files modified above.

- [ ] **Step 1: 运行静态分析**

```bash
flutter analyze
```

Expected: 无新增错误。其他文件已有警告可忽略。

- [ ] **Step 2: 运行测试**

```bash
flutter test
```

Expected: 新增 `test/trade_estimate_test.dart` 全部通过；其他已有测试状态不劣化。

- [ ] **Step 3: Commit（若分析/测试干净）**

```bash
git add -A
git commit -m "chore: verify trade dialog redesign"
```

---

## Self-Review

### Spec coverage

- ✅ 新增开仓/平仓/计划价格字段：Task 1。
- ✅ 旧数据迁移到 openPrice/openShares：Task 1。
- ✅ 弹窗 UI 分组展示：Task 4。
- ✅ 收益计算按新模型：Task 3。
- ✅ 交易卡片展示更新：Task 5。
- ✅ 国际化文案：Task 2。
- ✅ 测试：Task 3 + Task 6。

### Placeholder scan

- 无 TBD/TODO。
- 所有代码片段包含具体文件路径、方法签名与实现。

### Type consistency

- `StockTrades` 新字段均为 `String?`（Drift 可空文本列）。
- `calculateTradeEstimateFromValues` 参数与 `StockTrade` 字段一致。
- `StockTradesCompanion.insert` 使用 `Value<String?>` 包裹新字段。
