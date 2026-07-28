# 全局未平仓交易列表页设计

## 背景

当前股票详情/编辑页（`STOCKEDIT`）以底部弹窗形式展示单只股票的交易记录，cell 实现为 `stockedit_view.dart` 中的 `_buildTradeItem`。用户需要在首页进入股票详情后，通过一个入口查看**跨所有股票的未完成交易**（平仓股数 ≠ 开仓股数），并且列表 cell 需要显示股票名称与代码。

## 目标

1. 在 `STOCKEDIT` 页面 AppBar 右侧增加一个"交易"入口按钮。
2. 点击后进入独立的交易列表页。
3. 页面集中展示所有股票的**未平仓交易**，按交易日期降序排列（最新在前）。
4. 列表 cell 复用现有 `_buildTradeItem` 样式，并在首行下方新增"股票名（代码）"一栏。
5. 保留交易的编辑和删除功能。
6. 点击交易条目跳转至对应股票的 `STOCKEDIT` 详情页。

## 非目标

- 不在交易列表页新增交易（新增仍回到对应股票详情页操作）。
- 不处理已完成交易的历史列表（当前页面只展示未完成交易）。
- 全局列表不展示基于实时行情的未实现收益估算（缺少对应股票实时价）。

## 方案概述

新建 `tradelist` GetX 模块，抽取公共 `StockTradeItem` 组件与交易编辑 dialog，数据库新增跨股票查询。

## 详细设计

### 1. 路由与入口

在 `app_routes.dart` 中新增常量：

```dart
// Routes 类中
static const TRADELIST = _Paths.TRADELIST;

// _Paths 类中
static const TRADELIST = '/tradelist';
```

在 `app_pages.dart` 注册：

```dart
GetPage(
  name: _Paths.TRADELIST,
  page: () => const TradelistView(),
  binding: TradelistBinding(),
),
```

入口按钮位于 `StockeditView` 的 AppBar `actions`，在现有"保存"与"完成"按钮旁新增 IconButton，图标使用 `Icons.trending_up` 或 `Icons.swap_horiz`，tooltip 为 `TextKey.jiaoyi.tr`，点击后调用 `Get.toNamed(Routes.TRADELIST)`。

### 2. 数据层

在 `database.dart` 新增查询：

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

`TradelistController` 中：

1. 调用 `getAllStockTrades()` 获取全部交易。
2. 过滤出未完成交易：`_isTradeCompleted(trade)` 返回 `false`。
   - 判断逻辑：`openShares` 与 `closeShares` 解析为 double 后不相等，或其中一方为空/0。
3. 按交易日期降序、创建时间降序排列（查询已保证）。
4. 根据所有 `stockId` 批量查询 `StockItem`，构建 `Map<int, StockItem>` 用于 UI 展示股票名和代码。

### 3. UI 组件

#### 3.1 公共交易条目 `StockTradeItem`

新建文件 `lib/common/widget/stock_trade_item.dart`，从 `stockedit_view.dart` 抽取 `_buildTradeItem` 与 `_buildTradeEstimate` 的逻辑。

组件签名：

```dart
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
}
```

展示内容：

- 首行：买卖标签（红买绿卖）+ 交易日期。
- **新增行**（仅当 `stock != null`）：股票名 + 代码，例如 `贵州茅台 (600519)`，字号 13，颜色使用 `onSurfaceVariant`。
- 开仓价格与股数。
- 平仓价格与股数（如有）。
- 备注（如有）。
- 右侧：编辑、删除按钮；收益估算（仅在 `currentPrice` 有效时显示）。

#### 3.2 交易编辑 Dialog

新建 `lib/common/widget/stock_trade_dialog.dart`，将 `StockeditController._showTradeDialog` 的 UI 与状态管理抽取为可复用组件。

对外接口：

```dart
static Future<void> show({
  required BuildContext context,
  required StockTrade? existingTrade,
  required String currentPrice,
  required VoidCallback onSaved,
})
```

`StockeditController` 与 `TradelistController` 都通过此 dialog 编辑交易。

### 4. Controller 设计

#### `TradelistController`

- `RxList<StockTrade> trades`：未完成交易列表。
- `RxMap<int, StockItem> stockMap`：`stockId` 到股票的映射。
- `loadTrades()`：加载并过滤交易，关联股票。
- `editTrade(StockTrade trade)`：打开交易编辑 dialog，保存后刷新列表。
- `deleteTrade(StockTrade trade)`：弹出确认 dialog，确认后删除并刷新。
- `openStockDetail(StockTrade trade)`：根据 `stockId` 从 `stockMap` 取 `StockItem`，跳转 `Routes.STOCKEDIT`。

### 5. 页面布局

`TradelistView` 使用标准 `Scaffold`：

- AppBar 标题：`TextKey.jiaoyi.tr`（交易）。
- Body：
  - 空数据时显示 `QsEmptyView(message: TextKey.noData.tr)`。
  - 非空时使用 `ListView.builder`，每个 item 为 `StockTradeItem`。

### 6. 交互流程

1. 用户在首页点击股票 → 进入 `STOCKEDIT`。
2. 用户点击 AppBar 右上角"交易"按钮 → 进入 `TRADELIST`。
3. `TRADELIST` 自动加载所有未平仓交易，按日期倒序展示。
4. 用户点击某条交易 → 跳转到对应股票的 `STOCKEDIT`。
5. 用户点击编辑/删除 → 编辑或删除该交易，列表刷新。

### 7. 文件变更清单

新增文件：

- `lib/app/modules/tradelist/bindings/tradelist_binding.dart`
- `lib/app/modules/tradelist/controllers/tradelist_controller.dart`
- `lib/app/modules/tradelist/views/tradelist_view.dart`
- `lib/common/widget/stock_trade_item.dart`
- `lib/common/widget/stock_trade_dialog.dart`

修改文件：

- `lib/app/routes/app_routes.dart`：新增 `TRADELIST` 常量。
- `lib/app/routes/app_pages.dart`：注册新路由。
- `lib/app/modules/stockedit/views/stockedit_view.dart`：AppBar 加按钮；原 `_buildTradeItem` 替换为 `StockTradeItem`。
- `lib/app/modules/stockedit/controllers/stockedit_controller.dart`：交易 dialog 逻辑迁移至公共组件。
- `lib/common/database/database.dart`：新增 `getAllStockTrades()`。

## 风险与注意事项

1. `stockedit_view.dart` 当前文件较大（超过 1000 行），抽取组件后需要验证原有单股票交易列表、底部弹窗的显示不受影响。
2. 全局列表中无法获取每只股票实时行情，因此收益估算区域应降级显示为 `-` 或直接隐藏。
3. 交易编辑 dialog 抽离后，`StockeditController` 中的 `tradeType`、`tradeDate` 等 observable 需要确认是否仍被其他逻辑依赖。
4. 若某条交易的 `stockId` 在本地已删除，跳转时需要做兼容处理（提示"股票不存在"或过滤掉该条交易）。

## 测试建议

1. 单元测试：验证 `_isTradeCompleted` 对空字符串、0、相等/不相等股数的判断。
2. 数据库迁移/查询测试：验证 `getAllStockTrades()` 返回顺序。
3. Widget 测试：验证 `StockTradeItem` 在传入/不传入 `stock` 时的显示差异。
4. 集成测试：从 `STOCKEDIT` 点击入口进入 `TRADELIST`，点击条目跳转 `STOCKEDIT`。
