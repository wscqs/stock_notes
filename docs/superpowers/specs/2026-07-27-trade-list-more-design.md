# 交易记录“更多”抽屉设计

**日期:** 2026-07-27  
**范围:** 股票详情页（stockedit）交易记录模块  
**状态:** 已批准

## 背景

股票详情页的交易记录区域目前会无限制地列出所有交易。当交易较多时，卡片堆叠导致页面冗长。需要在主界面只展示最近 3 条，并提供入口查看完整列表。

## 目标

- 主界面交易区最多显示 3 条交易记录。
- 超过 3 条时，显示“更多 (N)”行，N 为剩余条数。
- 点击“更多”从底部弹出抽屉，展示全部交易记录（样式参考标签选择页）。
- 抽屉内支持删除交易，删除后主界面与抽屉同步刷新。

## 非目标

- 本次不新增交易编辑功能。
- 不改动交易数据模型或数据库查询。
- 不替换现有的 `showAddTradeDialog` 新增交易流程。

## 设计方案

### 主界面交易区

位置：`lib/app/modules/stockedit/views/stockedit_view.dart` 的 `_buildTradeSection`。

- 仍使用 `Obx(() => ...)` 监听 `controller.stockTrades`。
- 若列表为空，显示 `TextKey.noData`。
- 若列表长度 ≤ 3，按现有逻辑展示全部交易卡片。
- 若列表长度 > 3：
  - 展示前 3 条交易卡片。
  - 底部追加一行可点击的“更多 (N)”项：
    - 文字：`${TextKey.gengduo.tr} (${controller.stockTrades.length - 3})`
    - 样式：居左或居中的 `ListTile`/`InkWell`，文字使用主题次要色，带右箭头图标。
    - 点击：调用 `controller.showAllTradesSheet()`。

### 全部交易抽屉

位置：`lib/app/modules/stockedit/controllers/stockedit_controller.dart` 新增 `showAllTradesSheet()`。

- 使用 `Get.bottomSheet(...)`，风格与 `TagseditView.show` 保持一致：
  - 圆角顶部（`Radius.circular(16)`）。
  - 背景色 `Get.theme.colorScheme.surface`。
  - 高度约屏幕 70%。
  - `SafeArea` + `Padding(16)`。
- 顶部标题栏：
  - 左侧关闭按钮（`Icons.close`），点击 `Get.back()`。
  - 中间标题：`TextKey.jiaoyijilu.tr`（交易记录）。
  - 右侧留空。
- 主体：
  - `Expanded` + `SingleChildScrollView`。
  - 使用复用的交易项组件 `_buildTradeItem(trade)` 渲染全部交易。
  - 交易卡片右侧保留删除图标，点击调用 `controller.deleteTrade(trade)`。
- 无底部确认按钮（仅查看/删除，不同于标签页的“确认”）。

### 交易卡片复用

- 将 `stockedit_view.dart` 中现有的 `_buildTradeItem(StockTrade trade)` 保持为私有方法。
- 主界面和抽屉都通过同一方法构建卡片，确保视觉一致。

### 数据流

- 主界面和抽屉共用同一个 `StockeditController` 实例。
- 两者都通过 `Obx` 监听 `stockTrades`。
- 删除交易时调用 `controller.deleteTrade(trade)`：
  1. 弹出确认对话框。
  2. 确认后 `await db.deleteStockTrade(trade)`。
  3. 调用 `loadTrades()` 重新加载列表。
  4. `stockTrades` 刷新，主界面和抽屉自动更新。

### 多语言

新增 key：

```dart
static const gengduo = 'gengduo'; // 更多
```

翻译：

```dart
TextKey.gengduo: '更多',
```

```dart
TextKey.gengduo: 'More',
```

> 标题复用已有 `TextKey.jiaoyijilu`（交易记录），无需新增。

## 涉及文件

1. `lib/app/modules/stockedit/views/stockedit_view.dart`
2. `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
3. `lib/common/langs/text_key.dart`

## 边界情况

- 删除抽屉中最后一条交易后，抽屉内列表为空，显示 `TextKey.noData`。
- 删除后若总数 ≤ 3，主界面不再显示“更多”行，抽屉关闭后主界面即展示全部交易。
- 在抽屉打开期间新增交易（理论上抽屉会遮挡新增按钮，不会发生），但若 `stockTrades` 变化，抽屉会同步刷新。

## 后续可扩展

- 在抽屉顶部增加“新增交易”按钮，方便快速补录。
- 支持点击交易项进入编辑。
