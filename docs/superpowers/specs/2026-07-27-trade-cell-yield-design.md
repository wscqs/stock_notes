# 交易 cell 预估收益率/收益额设计

**日期:** 2026-07-27  
**范围:** 股票详情页（stockedit）交易记录卡片  
**状态:** 已批准

## 背景

交易记录卡片目前只展示交易类型、日期、价格、股数和备注。用户希望在日期下方补充预估收益率与收益额，方便快速判断每笔交易相对当前股价的盈亏情况。

## 目标

- 在交易卡片日期下方显示预估收益率。
- 有股数时追加显示预估收益额。
- 买入、卖出交易都按当前股价统一估算。
- 视觉样式与持有成本价下方的 `_buildHoldYieldInfo` 保持一致（红涨绿跌灰平）。

## 非目标

- 不改变交易数据模型。
- 不修改新增/编辑交易流程。
- 不替换已有的收益率计算逻辑（仅新增卡片展示）。

## 设计方案

### 布局

修改 `StockeditView._buildTradeItem` 中第一行（日期 + 删除按钮）右侧区域：

- 将日期从单独的 `Text` 改为右对齐的 `Column`。
- `Column` 中包含：
  1. 交易日期 `Text`（原有样式）。
  2. 间距 `SizedBox(height: 4)`。
  3. 预估收益信息小部件。

左侧保留交易类型标签；右侧日期下方新增收益信息，删除图标保持在最右。

### 收益计算

在 `StockeditController` 中新增方法：

```dart
({double? yieldRate, double? profit}) calculateTradeEstimate(StockTrade trade)
```

计算逻辑：

1. 解析当前股价 `currentPrice`：`double.tryParse(serStockData.value.currentPrice ?? "")`。
2. 解析成交价 `tradePrice`：`double.tryParse(trade.price ?? "")`。
3. 解析股数 `shares`：`double.tryParse(trade.shares ?? "")`（仅当字符串非空）。
4. 若 `currentPrice` 或 `tradePrice` 为空或为零，返回 `(null, null)`。
5. `yieldRate = (currentPrice - tradePrice) / tradePrice`。
6. `profit = shares != null ? (currentPrice - tradePrice) * shares : null`。

买入与卖出统一使用上述公式。

### UI 展示

在 `StockeditView` 中新增私有方法：

```dart
Widget _buildTradeEstimate(StockTrade trade)
```

行为：

1. 调用 `controller.calculateTradeEstimate(trade)` 获取 `yieldRate` 与 `profit`。
2. 根据 `yieldRate`（或 `profit`，当 `yieldRate` 为空时）决定颜色：
   - > 0：红色（`Colors.red`）
   - < 0：绿色（`Colors.green`）
   - == 0 或为空：灰色（`Colors.grey`）
3. 使用 `Text.rich` 渲染：
   - 第一行：`收益率: X.X%` 或 `收益率: -`
   - 第二行（仅当 `profit` 不为 null）：`收益额: X.XX`
4. 标签文字使用灰色，数值使用上述盈亏色。

### 边界情况

- 当前股价或成交价无法解析：显示 `收益率: -`，不显示收益额。
- 股数为空/无效：只显示收益率。
- 收益为零：显示灰色。
- 删除交易后收益信息随卡片一起消失。

## 涉及文件

1. `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
2. `lib/app/modules/stockedit/views/stockedit_view.dart`

## 测试

- 手动验证：在股票详情页查看交易卡片，确认日期下方出现预估收益信息。
- 验证颜色随盈亏变化。
- 验证无当前价/无股数时的降级展示。
