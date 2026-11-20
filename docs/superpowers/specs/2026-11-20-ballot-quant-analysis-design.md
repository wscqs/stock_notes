# 选股页量化分析入口设计

## 意图与范围
在选股清单末尾提供“量化分析”入口，让用户在应用内打开量化分析网页。仅新增入口，不改变现有清单结构、股票跳转或数据库；不新增依赖。

## 方案比较
- 已选：在 `BallotController` 增加远程 `BallotItem`，沿用 `BallotView` 的统一应用内 WebView。实现最小，行为与现有远程入口一致。
- 不选：单独制作量化分析页面或改用外部浏览器。当前没有定制需求，且不符合统一应用内打开的确认方案。

## 实现约束
- 标题为“量化分析”，使用 Remix 图表图标，位于清单末尾。
- URL 完整保留 `https://stock-quant-dashboard-45464.app.workbuddy.host/?sharecode=4BXKJH355B`。
- `isLocalAsset` 保持默认 `false`；复用现有 WebView 和网页跳股票详情能力。
- 用控制器测试固定标题、末尾位置、完整 URL 和远程资源类型；不改数据库 schema、翻译系统或发布版本。
