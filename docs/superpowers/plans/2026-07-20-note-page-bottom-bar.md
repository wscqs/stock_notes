# 笔记页底部操作栏改造实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将笔记详情/编辑页的操作按钮（分享、标签、收藏、删除）从顶部 App Bar 移到底部操作栏，非编辑状态显示，编辑状态隐藏。

**Architecture：** 直接在 `noteedit_view.dart` 内仿照股票详情页实现底部栏，保持 Controller 逻辑不变；通过 `Scaffold.bottomNavigationBar` 挂载，按 `isEditing` 和 `opDelete` 状态渲染不同按钮组合。

**Tech Stack：** Flutter / GetX / flutter_quill / remixicon

## Global Constraints

- 仅修改 `lib/app/modules/noteedit/views/noteedit_view.dart`，不改动 Controller、Binding、路由。
- 底部栏样式与股票详情页保持一致。
- 按钮启用规则沿用现有逻辑：`isLocalData` 为 `true` 时操作按钮可用。
- 编辑状态下不显示底部栏，保留 Quill 工具栏。
- 运行 `flutter analyze` 验证无新增错误。

---

### Task 1: 清理 App Bar 操作按钮

**Files:**
- Modify: `lib/app/modules/noteedit/views/noteedit_view.dart:32-123`

**Interfaces:**
- Consumes: `controller.isEditing`, `controller.isLocalData`, `controller.localData`, `controller.saveOnly`, `controller.complete`
- Produces: 简化的 `AppBar(actions: [...])`，仅保留保存和完成按钮

- [ ] **Step 1: 删除预览切换、分享、标签、收藏、删除及删除状态相关按钮**

将 `AppBar(actions: [...])` 替换为：

```dart
appBar: AppBar(
  actions: [
    IconButton(
      icon: const Icon(Icons.save_outlined),
      tooltip: TextKey.baocun.tr,
      onPressed: controller.saveOnly,
    ),
    IconButton(
      icon: const Icon(Icons.check),
      tooltip: TextKey.wancheng.tr,
      onPressed: controller.complete,
    ),
  ],
),
```

- [ ] **Step 2: 验证 App Bar 不再引用 `clickShare`、`clickPushTag`、`clickOpCollect`、`clickOpDelete`、`clickRestore`、`toggleEditMode` 等方法**

- [ ] **Step 3: Commit**

```bash
git add lib/app/modules/noteedit/views/noteedit_view.dart
git commit -m "refactor(note): simplify app bar to save/complete only"
```

---

### Task 2: 添加底部操作栏构建方法

**Files:**
- Modify: `lib/app/modules/noteedit/views/noteedit_view.dart`（在 `buildQuillSimpleToolbar` 之后新增方法）

**Interfaces:**
- Consumes: `controller.isEditing`, `controller.isLocalData`, `controller.localData`, `controller.clickShare`, `controller.clickPushTag`, `controller.clickOpCollect`, `controller.clickOpDelete`, `controller.clickRestore`
- Produces: `buildBottomBar()`, `_buildNormalBottomActions()`, `_buildDeletedBottomActions()`, `_buildBottomActionItem(...)`

- [ ] **Step 1: 在 `NoteeditView` 类末尾新增底部栏相关方法**

```dart
Widget? buildBottomBar() {
  if (controller.isEditing.value) return null;

  return Obx(() {
    final isDeleted = controller.localData.value?.opDelete == true;
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Get.theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: isDeleted
              ? _buildDeletedBottomActions()
              : _buildNormalBottomActions(),
        ),
      ),
    );
  });
}

Widget _buildNormalBottomActions() {
  final canOperate = controller.isLocalData.value;
  final local = controller.localData.value;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildBottomActionItem(
        icon: Icons.share_outlined,
        label: TextKey.share.tr,
        onTap: canOperate ? controller.clickShare : null,
      ),
      _buildBottomActionItem(
        icon: (local?.tagList.length ?? 0) > 0
            ? Remix.price_tag_3_fill
            : Remix.price_tag_3_line,
        label: TextKey.biaoqian.tr,
        color: (local?.tagList.length ?? 0) > 0 ? Colors.blue : null,
        onTap: canOperate ? controller.clickPushTag : null,
      ),
      _buildBottomActionItem(
        icon: (local?.opCollect ?? false)
            ? Icons.star
            : Icons.star_border_outlined,
        label: TextKey.collect.tr,
        color: (local?.opCollect ?? false) ? Colors.amber : null,
        onTap: canOperate ? controller.clickOpCollect : null,
      ),
      _buildBottomActionItem(
        icon: Icons.delete_forever,
        label: TextKey.delete.tr,
        onTap: canOperate ? controller.clickOpDelete : null,
      ),
    ],
  );
}

Widget _buildDeletedBottomActions() {
  final theme = Get.theme;
  final canOperate = controller.isLocalData.value;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildBottomActionItem(
        icon: Icons.restore,
        label: TextKey.huifu.tr,
        color: Colors.green,
        onTap: canOperate ? controller.clickRestore : null,
      ),
      _buildBottomActionItem(
        icon: Icons.delete_forever,
        label: TextKey.delete.tr,
        color: theme.colorScheme.error,
        onTap: canOperate ? controller.clickOpDelete : null,
      ),
    ],
  );
}

Widget _buildBottomActionItem({
  required IconData icon,
  required String label,
  Color? color,
  VoidCallback? onTap,
}) {
  final theme = Get.theme;
  final enabled = onTap != null;
  final effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;
  return MergeSemantics(
    child: Semantics(
      button: true,
      enabled: enabled,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: effectiveColor),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: effectiveColor),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/app/modules/noteedit/views/noteedit_view.dart
git commit -m "feat(note): add bottom action bar helpers"
```

---

### Task 3: 将底部栏挂载到 Scaffold

**Files:**
- Modify: `lib/app/modules/noteedit/views/noteedit_view.dart:125-230`

**Interfaces:**
- Consumes: `buildBottomBar()`
- Produces: `Scaffold(bottomNavigationBar: buildBottomBar())`

- [ ] **Step 1: 为 `Scaffold` 添加 `bottomNavigationBar`**

在 `Scaffold` 构造函数中添加：

```dart
Scaffold(
  appBar: ...,
  bottomNavigationBar: buildBottomBar(),
  body: ...,
)
```

- [ ] **Step 2: 移除编辑状态下为 Quill 工具栏预留的额外 `SizedBox(height: 52)`（可选，保留不影响功能）**

当前 body 中 `if (controller.isEditing.value) const SizedBox(height: 52)` 是为了给底部工具栏留空间。保留它不会与新的 `bottomNavigationBar` 冲突，因为编辑时 `buildBottomBar()` 返回 `null`。可以保留原样。

- [ ] **Step 3: Commit**

```bash
git add lib/app/modules/noteedit/views/noteedit_view.dart
git commit -m "feat(note): wire bottom action bar to scaffold"
```

---

### Task 4: 静态分析与手动验证

**Files:**
- N/A

**Interfaces:**
- N/A

- [ ] **Step 1: 运行静态分析**

```bash
flutter analyze
```

Expected: 无新增错误。

- [ ] **Step 2: 手动检查清单**

- [ ] 非编辑状态底部显示「分享 / 标签 / 收藏 / 删除」。
- [ ] 编辑状态底部栏消失，Quill 工具栏正常显示。
- [ ] 已删除笔记底部显示「恢复 / 永久删除」。
- [ ] App Bar 仅保留「保存」「完成」。
- [ ] 新建笔记时（`isLocalData == false`），操作按钮置灰不可用。

- [ ] **Step 3: Commit（如需要）**

若未产生代码变更，无需单独 commit。

---

## Self-Review

- **Spec coverage:**
  - App Bar 仅保留保存/完成 → Task 1
  - 底部栏分享/标签/收藏/删除 → Task 2
  - 删除状态恢复/永久删除 → Task 2 `_buildDeletedBottomActions`
  - 编辑状态隐藏底部栏 → Task 2 `buildBottomBar` 开头判断
  - 样式参考股票详情页 → Task 2 代码
  - `flutter analyze` 验证 → Task 4
- **Placeholder scan:** 无 TBD/TODO/"implement later"。
- **Type consistency:** 使用的 `controller` 属性、方法名与 `NoteeditController` 现有 API 一致。
