# 笔记页底部操作栏改造设计

## 背景

当前笔记详情/编辑页（`lib/app/modules/noteedit/views/noteedit_view.dart`）把「分享、标签、收藏、删除」等操作按钮放在顶部 App Bar，与股票详情页不一致。为了让两页交互统一，参考股票详情页，把这些按钮移到底部操作栏。

## 目标

- 笔记页 App Bar 简化为：左侧返回、右侧「保存」「完成」。
- 非编辑状态下，底部显示操作栏：「分享 / 标签 / 收藏 / 删除」。
- 已删除笔记在底部显示：「恢复 / 永久删除」。
- 编辑状态下不显示底部操作栏，仅保留 Quill 工具栏。
- 保持现有 Controller 逻辑、路由、绑定不变。

## 改动范围

仅修改视图层：

- `lib/app/modules/noteedit/views/noteedit_view.dart`

## 详细设计

### App Bar 调整

- 移除 `AppBar.actions` 中的：
  - 编辑/预览切换按钮
  - 分享按钮
  - 标签按钮
  - 收藏按钮
  - 删除按钮
  - 删除状态下的「已删除」文本、恢复按钮、永久删除按钮
- 仅保留：
  - 「保存」`IconButton` → `controller.saveOnly`
  - 「完成」`IconButton` → `controller.complete`

返回按钮由 `Scaffold` 默认提供，无需额外处理。

### 新增底部操作栏

在 `NoteeditView` 中新增 `buildBottomBar()`，返回 `Scaffold.bottomNavigationBar` 使用的 Widget。

状态分支：

1. **编辑状态** (`controller.isEditing.value == true`)
   - 返回 `SizedBox.shrink()` 或 `null`，不占用空间。
2. **非编辑状态 & 已删除** (`controller.localData.value?.opDelete == true`)
   - 显示「恢复」和「永久删除」两个按钮。
3. **非编辑状态 & 未删除**
   - 显示「分享」「标签」「收藏」「删除」四个按钮。

### 按钮启用规则

沿用现有逻辑：

- 「分享」「标签」「收藏」「删除」「恢复」仅在 `controller.isLocalData.value == true` 时启用，否则置灰。
- 「永久删除」在已删除状态下启用（已删除条目必然是本地数据）。

### 样式

参考股票详情页底部栏：

- 容器高度 `kBottomNavigationBarHeight`
- 背景色 `Get.theme.colorScheme.surface`
- 顶部 8px 模糊阴影，偏移 `(0, -2)`
- 使用 `SafeArea` 适配刘海/手势条
- 按钮横向 `spaceEvenly` 分布
- 每个按钮为图标 + 文字纵向排列，字号 10，图标大小 22
- 禁用状态透明度 0.3

### 不改动项

- `NoteeditController` 的所有方法、状态字段不变。
- `noteedit_binding.dart`、`app_pages.dart`、`app_routes.dart` 不变。
- 股票详情页相关文件不变。

## 验收标准

- [ ] 非编辑状态下，笔记页底部显示「分享 / 标签 / 收藏 / 删除」。
- [ ] 编辑状态下，底部操作栏不出现，Quill 工具栏正常显示。
- [ ] 已删除笔记在非编辑状态下，底部显示「恢复 / 永久删除」。
- [ ] App Bar 仅保留「保存」「完成」。
- [ ] 各按钮的启用/禁用、颜色状态与改造前一致。
- [ ] 点击事件行为与改造前一致。
- [ ] `flutter analyze` 无新增错误。

## 日期

2026-07-20
