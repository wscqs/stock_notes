# Stock Edit Title with Current Price

## Goal
在股票编辑页（`StockeditView`）的 AppBar 标题中，参考股票笔记页（`StocknoteView`）的样式，同时显示股票名称与当前价格。

## Design
- 文件：`lib/app/modules/stockedit/views/stockedit_view.dart`
- 将 AppBar 的 `title` 从单行 `Text` 改为 `Column`：
  - 第一行：股票名称（保持现有逻辑：`isLocalData.value ? localStockData.value!.name : TextKey.gupiao.tr`）
  - 第二行：当 `controller.serStockData.value.currentPrice` 非空时显示该价格
- 价格文字样式与 `StocknoteView` 保持一致：
  - `fontSize: 12`
  - `fontWeight: FontWeight.w500`
  - `color: Get.theme.colorScheme.onSurface`
- 保留 `centerTitle: true` 与右侧保存/完成操作按钮。

## Behavior
- 新建股票且尚未搜索到价格时，标题仅显示股票名/默认文案，不显示价格。
- 已有本地股票或搜索到实时行情后，自动在标题下方显示当前价格。

## Scope
仅修改 `stockedit_view.dart` 的 AppBar title 实现，不引入计划价格、不改动 Controller 或数据模型。
