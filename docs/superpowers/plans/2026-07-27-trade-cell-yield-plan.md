# 交易 cell 预估收益率/收益额实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在股票详情页交易卡片日期下方显示预估收益率与收益额，买入/卖出统一按当前股价估算，视觉风格与持有成本收益信息一致。

**Architecture:** 计算逻辑集中在 `StockeditController.calculateTradeEstimate(StockTrade)`；UI 展示在 `StockeditView._buildTradeItem` 中，通过私有 `_buildTradeEstimate` 小部件渲染。

**Tech Stack:** Flutter, GetX

## Global Constraints

- 买入、卖出交易统一按当前股价估算。
- 视觉样式与 `_buildHoldYieldInfo` 一致：红涨绿跌灰平。
- 标签灰色，数值使用盈亏色。
- 当前价或成交价无法解析时显示 `收益率: -`。
- 无有效股数时只显示收益率，不显示收益额。
- 日期下方新增预估收益信息，右对齐。

---

## File Structure

- **Modify:** `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
  - 新增 `calculateTradeEstimate(StockTrade trade)` 方法。
- **Modify:** `lib/app/modules/stockedit/views/stockedit_view.dart`
  - 修改 `_buildTradeItem` 中日期区域为 Column，并新增 `_buildTradeEstimate` 小部件。

---

### Task 1: 在 Controller 中添加收益估算方法

**Files:**
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart`

**Interfaces:**
- Produces: `({double? yieldRate, double? profit}) calculateTradeEstimate(StockTrade trade)` usable from the view.

- [ ] **Step 1: Locate trade-related methods**

Find the trade-related section in `StockeditController` (near `loadTrades`, `addTrade`, `deleteTrade`).

- [ ] **Step 2: Add calculateTradeEstimate**

Insert the following method:

```dart
({double? yieldRate, double? profit}) calculateTradeEstimate(StockTrade trade) {
  final currentPriceStr = serStockData.value.currentPrice;
  final tradePriceStr = trade.price;
  if (currentPriceStr == null ||
      currentPriceStr.isEmpty ||
      tradePriceStr == null ||
      tradePriceStr.isEmpty) {
    return (yieldRate: null, profit: null);
  }

  final currentPrice = double.tryParse(currentPriceStr);
  final tradePrice = double.tryParse(tradePriceStr);
  if (currentPrice == null || tradePrice == null || tradePrice == 0) {
    return (yieldRate: null, profit: null);
  }

  final yieldRate = (currentPrice - tradePrice) / tradePrice;

  double? profit;
  final sharesStr = trade.shares;
  if (sharesStr != null && sharesStr.isNotEmpty) {
    final shares = double.tryParse(sharesStr);
    if (shares != null) {
      profit = (currentPrice - tradePrice) * shares;
    }
  }

  return (yieldRate: yieldRate, profit: profit);
}
```

- [ ] **Step 3: Verify with flutter analyze**

Run:

```bash
flutter analyze lib/app/modules/stockedit/controllers/stockedit_controller.dart
```

Expected: No new errors in this file. Pre-existing warnings are acceptable.

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/stockedit/controllers/stockedit_controller.dart
git commit -m "feat(stockedit): add calculateTradeEstimate for trade cards"
```

---

### Task 2: 在交易卡片中展示预估收益

**Files:**
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart`

**Interfaces:**
- Consumes: `controller.calculateTradeEstimate(trade)` from Task 1.
- Produces: Updated `_buildTradeItem` with date + estimate Column; new `_buildTradeEstimate` helper.

- [ ] **Step 1: Locate _buildTradeItem**

Find `_buildTradeItem(StockTrade trade)` in `stockedit_view.dart`. It currently starts with a `Row` containing the trade-type badge, `Spacer`, date `Text`, delete icon.

- [ ] **Step 2: Wrap date in a Column with estimate below**

Replace the date `Text` and surrounding `SizedBox(width: 8)` with a Column. The top `Row` should become:

```dart
Row(
  children: [
    // ... trade-type badge remains ...
    const Spacer(),
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          (trade.tradeDate ?? trade.createdAt).toDateString(),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        _buildTradeEstimate(trade),
      ],
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () => controller.deleteTrade(trade),
      child: Icon(
        Icons.delete_outline,
        size: 18,
        color: Colors.grey,
      ),
    ),
  ],
),
```

- [ ] **Step 3: Add _buildTradeEstimate helper**

Add the following private method near `_buildTradeItem`:

```dart
Widget _buildTradeEstimate(StockTrade trade) {
  final estimate = controller.calculateTradeEstimate(trade);
  final yieldRate = estimate.yieldRate;

  final valueColor = yieldRate == null
      ? Colors.grey
      : (yieldRate > 0
          ? Colors.red
          : (yieldRate < 0 ? Colors.green : Colors.grey));
  final labelStyle = TextStyle(color: Colors.grey, fontSize: 12);
  final valueStyle = TextStyle(color: valueColor, fontSize: 12);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text.rich(
        TextSpan(children: [
          TextSpan(
              text: "${TextKey.shouyilv.tr}: ", style: labelStyle),
          TextSpan(
            text: yieldRate == null
                ? "-"
                : "${(yieldRate * 100).toStringAsFixed(1)}%",
            style: valueStyle,
          ),
        ]),
      ),
      if (estimate.profit != null)
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "${TextKey.shouyie.tr}: ", style: labelStyle),
            TextSpan(
              text: estimate.profit!.toStringAsFixed(2),
              style: valueStyle,
            ),
          ]),
        ),
    ],
  );
}
```

- [ ] **Step 4: Verify with flutter analyze**

Run:

```bash
flutter analyze lib/app/modules/stockedit/views/stockedit_view.dart
```

Expected: No new errors in this file. Pre-existing warnings are acceptable.

- [ ] **Step 5: Manual verification**

Run:

```bash
flutter run
```

Navigate to a stock detail page with trades. Verify:
- Each trade card shows the date and, directly below it, the estimated yield rate.
- If the trade has valid shares, the estimated profit amount is also shown.
- Colors are red for positive, green for negative, grey for zero or unavailable.

- [ ] **Step 6: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart
git commit -m "feat(stockedit): show estimated yield and profit in trade cards"
```

---

### Task 3: 回归测试与静态分析

**Files:**
- All files modified above.

- [ ] **Step 1: Run static analysis**

```bash
flutter analyze
```

Expected: No new errors. Pre-existing warnings in other files are acceptable.

- [ ] **Step 2: Run tests**

```bash
flutter test
```

Expected: Existing tests pass; the 2 pre-existing `stock_ext_links_test.dart` failures may still fail. No new failures should appear.

- [ ] **Step 3: Commit if clean**

If analyze passes and tests are no worse than before:

```bash
git add -A
git commit -m "chore: verify trade cell yield feature"
```

---

## Self-Review

### Spec coverage

- ✅ 日期下方显示预估收益：Task 2。
- ✅ 收益率与收益额：Task 2。
- ✅ 买入/卖出统一按当前价估算：Task 1。
- ✅ 红涨绿跌灰平：Task 2。
- ✅ 当前价/成交价无法解析时显示 `-`：Task 2。
- ✅ 无股数时只显示收益率：Task 2。

### Placeholder scan

- No TBD/TODO.
- Code snippets include exact method signatures and file paths.

### Type consistency

- `calculateTradeEstimate` returns a record `({double? yieldRate, double? profit})`.
- `_buildTradeEstimate` consumes `StockTrade` and returns `Widget`.
- `_buildTradeItem` already receives `StockTrade` and will pass it through.
