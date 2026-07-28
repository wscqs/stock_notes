# 交易弹窗重构：支持开仓/平仓与计划价格

**日期:** 2026-07-28  
**范围:** 股票详情页（stockedit）新增/编辑交易弹窗  
**状态:** 已批准

## 背景

当前交易弹窗只记录单一组“价格/股数”，用户希望把一次交易视为完整闭环：同时记录开仓（建仓）、平仓（了结）以及本次交易的计划买价/计划卖价，便于后续复盘与收益核算。

## 目标

- 交易弹窗改为同时录入：买/卖方向、交易日期、开仓价/股数、平仓价/股数、计划买价/计划卖价、备注。
- 交易方向“买”表示先买后卖（做多），“卖”表示先卖后买（做空）。
- 旧交易记录的 `price/shares` 自动迁移为“开仓价/开仓股数”。
- 交易卡片收益计算按新模型更新：已平仓按实际价差，未平仓按当前价浮盈。
- 计划价格仅作为记录，不触发条件提醒。

## 非目标

- 不做跨表或交易对模型（仍是一条记录表示一次交易）。
- 不替换股票详情页顶部的“计划买入价/计划卖出价”（`pPriceBuy/pPriceSale`），交易弹窗内的计划价格是每条交易独立的。
- 不在交易卡片中展示计划买价/计划卖价。

## 设计方案

### 数据模型

`lib/common/database/tables.dart` 中 `StockTrades` 表新增字段：

```dart
TextColumn get openPrice => text().nullable()();
TextColumn get openShares => text().nullable()();
TextColumn get closePrice => text().nullable()();
TextColumn get closeShares => text().nullable()();
TextColumn get planBuyPrice => text().nullable()();
TextColumn get planSalePrice => text().nullable()();
```

旧的 `price` / `shares` 列保留在表中但不再读写，用于历史数据兼容。

`lib/common/database/database.dart` 中：

- `schemaVersion` 从 `6` 升到 `7`。
- `onUpgrade` 增加 `from <= 6` 分支：
  1. 依次添加 `openPrice`、`openShares`、`closePrice`、`closeShares`、`planBuyPrice`、`planSalePrice` 六列。
  2. 执行 `UPDATE stock_trades SET open_price = price, open_shares = shares` 完成旧数据迁移。

### 弹窗 UI

改造 `StockeditController._showTradeDialog`：

- 顶部：保留“买 / 卖” `ChoiceChip` + 交易日期选择器。
- 新增输入框控制器：
  - `openPriceController`、`openSharesController`
  - `closePriceController`、`closeSharesController`
  - `planBuyPriceController`、`planSalePriceController`
- 内容区按分组纵向排列：
  1. **开仓**：标签 + 价格输入框 + 股数输入框（同一行）。
  2. **平仓**：标签 + 价格输入框 + 股数输入框（同一行）。
  3. **计划价格**：标签 + 买价输入框 + 卖价输入框（同一行）。
  4. **备注**：多行文本框。
- 保存时校验：开仓价必填，其余字段可选。

### 收益计算

改造 `calculateTradeEstimateFromValues`（或新增对应函数）：

- **做多（tradeType = 0，买）**
  - 收益率 = (当前价 - 开仓价) / 开仓价
  - 收益：
    - 若 `openShares` 有效且等于 `closeShares`，按 `(平仓价 - 开仓价) × 开仓股数`。
    - 否则按 `(当前价 - 开仓价) × 开仓股数`。

- **做空（tradeType = 1，卖）**
  - 收益率 = (开仓价 - 当前价) / 开仓价
  - 收益：
    - 若 `openShares` 有效且等于 `closeShares`，按 `(开仓价 - 平仓价) × 开仓股数`。
    - 否则按 `(开仓价 - 当前价) × 开仓股数`。

当 `openPrice` 无效或 `currentPrice` 无效时返回 `(null, null)`。

### 交易列表展示

- 交易卡片显示开仓价/股数、平仓价/股数。
- 当平仓数据完整时显示实际收益；未平仓或平仓不完整时显示浮盈。
- 计划价格不在卡片中展示。

## 边界情况

- 旧数据迁移：所有历史交易的 `price/shares` 写入 `openPrice/openShares`，平仓与计划价格留空。
- 用户只填开仓价、不填平仓价：按当前价计算浮盈。
- 用户填写了平仓价但未填平仓股数：视为未完全平仓，仍按当前价浮盈。
- 开仓股数与平仓股数不一致：按当前价浮盈。
- `openShares` / `closeShares` 为空字符串或无法解析：忽略股数，只计算收益率；收益额为 null。

## 涉及文件

1. `lib/common/database/tables.dart` — 新增 `StockTrades` 字段。
2. `lib/common/database/database.dart` — 升级 schemaVersion 并添加迁移逻辑。
3. `lib/common/database/database.g.dart` — 重新生成 Drift 代码。
4. `lib/app/modules/stockedit/controllers/stockedit_controller.dart` — 改造弹窗、保存/更新逻辑、收益计算。
5. `lib/app/modules/stockedit/views/stockedit_view.dart` — 改造交易卡片展示。
6. `lib/common/langs/text_key.dart` — 新增/复用文案键（开仓、平仓、计划买价、计划卖价等）。
7. `test/...` — 补充收益计算单元测试。

## 测试

- 手动验证：新增交易时弹窗字段分组正确，保存后列表展示无误。
- 手动验证：编辑旧交易时，原价格/股数正确显示在开仓区。
- 单元测试：覆盖做多/做空、已平仓/未平仓、空字段、无效数字等收益计算场景。
- 数据库迁移测试：安装旧版本数据后升级，确认 `open_price/open_shares` 已正确填充。
