# 笔记详情页删除态导航栏按钮实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 根据笔记是否处于删除列表，在笔记详情页导航栏动态显示不同的操作按钮：已删除笔记只显示“恢复”和“永久删除”，非删除笔记保持现有按钮。

**Architecture:** 在 `NoteeditController` 中新增恢复方法，在 `NoteeditView` 的 `AppBar.actions` 中根据 `localData.value?.opDelete` 条件渲染两组按钮。不引入新状态变量，复用现有 `opDelete` 字段。

**Tech Stack:** Flutter, GetX, Drift (SQLite)

## Global Constraints

- 永久删除不需要二次确认弹窗。
- 已删除笔记隐藏预览、分享、标签、收藏、保存按钮。
- 删除态笔记内容保持只读。
- 文本使用现有 `TextKey.huifu` / `TextKey.delete`。

---

### Task 1: 在 Controller 中添加恢复方法

**Files:**
- Modify: `lib/app/modules/noteedit/controllers/noteedit_controller.dart:252-265`

**Interfaces:**
- Consumes: `localData.value?.opDelete`, `Get.find<DatabaseManager>().db`, `db.updateNoteWithOp`
- Produces: `void clickRestore()`

- [ ] **Step 1: 在 `clickOpDelete()` 旁边新增 `clickRestore()`**

```dart
//恢复
void clickRestore() {
  if (!isLocalData.value) return;
  final db = Get.find<DatabaseManager>().db;
  localData.value =
      localData.value!.copyWith(opDelete: false);
  db.updateNoteWithOp(localData.value!);
  QsHud.showToast(TextKey.huifu.tr + TextKey.success.tr);
  canPop = true;
  Get.back();
}
```

- [ ] **Step 2: 保持 `clickOpDelete()` 现有逻辑不变**

```dart
//删除（已在删除列表则真正删除）
void clickOpDelete() {
  if (!isLocalData.value) return;
  final db = Get.find<DatabaseManager>().db;
  if (localData.value!.opDelete) {
    db.deleteNote(localData.value!);
    QsHud.showToast(TextKey.delete.tr + TextKey.success.tr);
  } else {
    db.updateNoteWithOp(localData.value!.copyWith(opDelete: true));
    QsHud.showToast(TextKey.yidaoshanchuliebiao.tr);
  }
  canPop = true;
  Get.back();
}
```

- [ ] **Step 3: 运行静态分析**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/noteedit/controllers/noteedit_controller.dart
git commit -m "feat(noteedit): add clickRestore for deleted notes"
```

---

### Task 2: 根据删除状态动态渲染导航栏按钮

**Files:**
- Modify: `lib/app/modules/noteedit/views/noteedit_view.dart:31-85`

**Interfaces:**
- Consumes: `controller.localData.value?.opDelete`
- Produces: Conditional `AppBar.actions`

- [ ] **Step 1: 将 `AppBar.actions` 改造为条件渲染**

替换现有 `actions: [...]` 为以下结构：

```dart
actions: [
  if (controller.localData.value?.opDelete == true) ...[
    // 已删除笔记：恢复 + 永久删除
    IconButton(
      onPressed: controller.isLocalData.value
          ? controller.clickRestore
          : null,
      icon: const Icon(Icons.restore),
      tooltip: TextKey.huifu.tr,
    ),
    IconButton(
      onPressed: controller.isLocalData.value
          ? controller.clickOpDelete
          : null,
      icon: const Icon(Icons.delete_forever),
      tooltip: TextKey.delete.tr,
    ),
  ] else ...[
    // 非删除笔记：保持原有按钮
    if (controller.isEditing.value)
      IconButton(
        onPressed: controller.toggleEditMode,
        icon: const Icon(Icons.visibility),
        tooltip: '预览',
      ),
    if (!controller.isEditing.value)
      IconButton(
        onPressed: controller.isLocalData.value
            ? controller.clickShare
            : null,
        icon: const Icon(Icons.share_outlined),
        tooltip: '分享',
      ),
    IconButton(
      onPressed: controller.isLocalData.value
          ? controller.clickPushTag
          : null,
      icon: Icon(
        (controller.localData.value?.tagList.length ?? 0) > 0
            ? Remix.price_tag_3_fill
            : Remix.price_tag_3_line,
        color: (controller.localData.value?.tagList.length ?? 0) > 0
            ? Colors.blue
            : null,
      ),
      tooltip: TextKey.biaoqian.tr,
    ),
    IconButton(
      onPressed: controller.isLocalData.value
          ? controller.clickOpCollect
          : null,
      icon: Icon(
        (controller.localData.value?.opCollect ?? false)
            ? Icons.star
            : Icons.star_border_outlined,
        color: (controller.localData.value?.opCollect ?? false)
            ? Colors.amber
            : null,
      ),
      tooltip: TextKey.collect.tr,
    ),
    IconButton(
      onPressed: controller.isLocalData.value
          ? controller.clickOpDelete
          : null,
      icon: const Icon(Icons.delete_forever),
      tooltip: TextKey.delete.tr,
    ),
    ElevatedButton(
        onPressed: controller.save, child: Text(TextKey.baocun.tr))
  ]
],
```

- [ ] **Step 2: 运行静态分析**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: 运行测试**

```bash
flutter test
```

Expected: `All tests passed!`

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/noteedit/views/noteedit_view.dart
git commit -m "feat(noteedit): conditional app bar actions for deleted notes"
```

---

## Self-Review

**Spec coverage:**
- 非删除笔记保持现有按钮 → Task 2 `else` 分支完整保留原按钮。
- 已删除笔记只显示恢复和删除 → Task 2 `if (opDelete == true)` 分支。
- 恢复将笔记移回正常列表 → Task 1 `clickRestore()`。
- 删除对已删除笔记执行永久删除 → Task 2 调用现有 `clickOpDelete()`，其内部逻辑已处理 `opDelete == true` 时的真删除。
- 删除态隐藏保存等按钮 → Task 2 条件渲染中已排除。
- 无二次确认弹窗 → 未新增确认弹窗。

**Placeholder scan:**
- 无 TBD / TODO / "implement later" / "handle edge cases"。
- 代码块包含完整实现。
- 命令包含预期输出。

**Type consistency:**
- `opDelete` 为 `bool`，条件判断使用 `== true`。
- `clickRestore` / `clickOpDelete` 均为 `void Function()`，与 `IconButton.onPressed` 类型兼容。

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/2026-07-17-note-detail-deleted-actions-plan.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
