# 笔记资产模块实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在笔记编辑页新增资产入口，支持为笔记添加资产记录（资产名、买入额、卖出额）并自动计算收益额与收益比，持久化到 SQLite 并在标签下方展示。

**Architecture:** 新增 `NoteAssets` 表存储资产记录，通过 `noteId` 关联 `NoteItems`；在 `database.dart` 中扩展 DAO 与 `NoteItemExt` 运行时字段；在 `noteedit_controller.dart` 中处理资产弹窗逻辑；在 `noteedit_view.dart` 中新增底部入口与资产展示模块。

**Tech Stack:** Flutter, GetX, Drift (SQLite), flutter_smart_dialog, Remix/Material icons.

**Spec:** `docs/superpowers/specs/2026-10-15-note-asset-design.md`

## Global Constraints

- 必须遵循现有模块结构：`lib/app/modules/noteedit/controllers/`、`views/`。
- 所有新增文案必须使用 `TextKey` 并通过 `.tr` 获取，同时补充 `zh` 与 `en` 翻译。
- 数据库 schema 变更必须升级 `schemaVersion`（当前 12 → 13）并补充 migration。
- 修改 schema 后必须运行 `dart run build_runner build` 重新生成 `database.g.dart`。
- 资产金额字段使用 `TextColumn` 存储字符串，与现有 `StockTrades` 的 `price`/`shares` 保持一致。
- 底部栏仅在非编辑态显示，编辑态下点击资产入口需要先保存笔记（复用标签的「保存并操作」逻辑）。

## Review Focus

- 空买入额或买入额为 0 时收益比不应出现除零崩溃。
- 笔记未保存时点击资产入口必须弹出确认并先保存。
- 删除资产记录后视图应立即刷新且不影响其他资产。
- 资产记录应随笔记持久化并在重新进入页面时正确加载。
- schema 升级后旧数据库可正常迁移，不会丢失已有笔记数据。

---

## Task 1: 数据库 schema 与 DAO 层

**Files:**
- Modify: `lib/common/database/tables.dart`
- Modify: `lib/common/database/database.dart`
- Generate: `lib/common/database/database.g.dart`（通过 build_runner）

**Interfaces:**
- Consumes: 现有 `NoteItems` 表、`TableMixin`。
- Produces: `NoteAssets` 表定义、`NoteAsset` 数据类、`getNoteAssetsByNoteId(int noteId)`、`addNoteAsset(NoteAssetsCompanion)`、`deleteNoteAsset(NoteAsset)`、`updateNoteAsset(NoteAssetsCompanion)`、扩展 `NoteItemExt` 的 `assetList`。

- [ ] **Step 1: 新增 `NoteAssets` 表**

在 `lib/common/database/tables.dart` 中，在 `StockTrades` 表附近新增：

```dart
class NoteAssets extends Table with TableMixin {
  IntColumn get noteId => integer().references(NoteItems, #id)();
  TextColumn get name => text()();
  TextColumn get buyAmount => text().nullable()();
  TextColumn get sellAmount => text().nullable()();
}
```

- [ ] **Step 2: 注册表并升级 schema**

在 `lib/common/database/database.dart` 中：
1. `@DriftDatabase(tables: [...])` 数组中加入 `NoteAssets`。
2. `schemaVersion` 从 `12` 改为 `13`。
3. `onUpgrade` 中添加分支：

```dart
if (from <= 12) {
  await migrator.createTable(noteAssets);
}
```

- [ ] **Step 3: 新增 DAO 方法**

在 `database.dart` 的 `//note` 区块附近新增：

```dart
// note_assets
Future<List<NoteAsset>> getNoteAssetsByNoteId(int noteId) {
  return (select(noteAssets)..where((tbl) => tbl.noteId.equals(noteId)))
      .get();
}

Future<int> addNoteAsset(NoteAssetsCompanion item) =>
    noteAssets.insertOne(item);

Future<void> deleteNoteAsset(NoteAsset itemDelete) {
  return (delete(noteAssets)..where((tbl) => tbl.id.equals(itemDelete.id)))
      .go();
}

Future<void> updateNoteAsset(NoteAssetsCompanion itemUpdate) {
  return update(noteAssets).replace(itemUpdate);
}
```

- [ ] **Step 4: 扩展 `NoteItemExt` 运行时字段**

在 `database.dart` 中：
1. `NoteItemExtraState` 增加 `List<NoteAsset> assetList` 字段。
2. `NoteItemExt` 增加 `assetList` getter/setter。

```dart
class NoteItemExtraState {
  List<NoteItemTag> tagList;
  List<NoteAsset> assetList;

  NoteItemExtraState({
    List<NoteItemTag>? tagList,
    List<NoteAsset>? assetList,
  })  : tagList = tagList ?? [],
        assetList = assetList ?? [];
}

extension NoteItemExt on NoteItem {
  // ...
  List<NoteAsset> get assetList => extra.assetList;
  set assetList(List<NoteAsset> value) => extra.assetList = value;
}
```

- [ ] **Step 5: 重新生成 drift 代码**

运行：

```bash
dart run build_runner build
```

Expected: `database.g.dart` 被更新且无错误。

- [ ] **Step 6: 提交**

```bash
git add lib/common/database/tables.dart lib/common/database/database.dart lib/common/database/database.g.dart
git commit -m "feat(note-asset): add NoteAssets table and DAO methods"
```

---

## Task 2: 资产计算扩展与文案

**Files:**
- Modify: `lib/common/database/database.dart`
- Modify: `lib/common/langs/text_key.dart`

**Interfaces:**
- Consumes: `NoteAsset` 数据类。
- Produces: `NoteAssetExt` 的 `profit`、`profitRate`、`profitRateText`、`buyAmountText`、`sellAmountText`。

- [ ] **Step 1: 新增 `NoteAssetExt` 计算扩展**

在 `database.dart` 中新增扩展：

```dart
extension NoteAssetExt on NoteAsset {
  double? get profit {
    final buy = double.tryParse(buyAmount ?? '');
    final sell = double.tryParse(sellAmount ?? '');
    if (buy == null) return null;
    return (sell ?? 0) - buy;
  }

  double? get profitRate {
    final buy = double.tryParse(buyAmount ?? '');
    if (buy == null || buy == 0) return null;
    final p = profit;
    if (p == null) return null;
    return p / buy;
  }

  String? get profitRateText {
    final rate = profitRate;
    if (rate == null) return null;
    final sign = rate > 0 ? '+' : '';
    return '$sign${(rate * 100).toStringAsFixed(1)}%';
  }

  String get buyAmountText => buyAmount ?? '';
  String get sellAmountText => sellAmount ?? '';
}
```

- [ ] **Step 2: 新增国际化文案**

在 `lib/common/langs/text_key.dart` 中新增：

```dart
static const zichan = 'zichan';
static const zichanming = 'zichanming';
static const mairue = 'mairue';
static const maichue = 'maichue';
static const shouyie = 'shouyie';
static const shouyilv = 'shouyilv';
```

其中 `shouyie`、`shouyilv` 已存在，无需重复添加；确认其存在后仅添加新 key。

在 `zh` Map 中新增：

```dart
TextKey.zichan: '资产',
TextKey.zichanming: '资产名',
TextKey.mairue: '买入额',
TextKey.maichue: '卖出额',
```

在 `en` Map 中新增：

```dart
TextKey.zichan: 'Asset',
TextKey.zichanming: 'Asset Name',
TextKey.mairue: 'Buy Amount',
TextKey.maichue: 'Sell Amount',
```

- [ ] **Step 3: 提交**

```bash
git add lib/common/database/database.dart lib/common/langs/text_key.dart
git commit -m "feat(note-asset): add NoteAsset profit helpers and i18n keys"
```

---

## Task 3: Controller 资产弹窗逻辑

**Files:**
- Modify: `lib/app/modules/noteedit/controllers/noteedit_controller.dart`

**Interfaces:**
- Consumes: `NoteAssetExt`、`TextKey`、`QsHud`、`SmartDialog`。
- Produces: `clickPushAsset()`、`refreshAssets()`、`showAssetEditDialog({NoteAsset? asset})`。

- [ ] **Step 1: 新增 `refreshAssets` 方法**

在 `refreshTags()` 方法之后新增：

```dart
Future<void> refreshAssets() async {
  if (isLocalData.value) {
    final db = Get.find<DatabaseManager>().db;
    final assets = await db.getNoteAssetsByNoteId(localData.value!.id);
    localData.value!.assetList = assets;
    localData.refresh();
  }
}
```

- [ ] **Step 2: 新增 `clickPushAsset` 入口方法**

在 `clickPushTag()` 方法之后新增：

```dart
void clickPushAsset() {
  if (!isLocalData.value) {
    QsHud.showConfirmDialog(
      title: TextKey.zichan.tr,
      content: TextKey.cicaozuoxubaocun.tr,
      confirmText: TextKey.baocunbingcaozu.tr,
      onConfirm: () async {
        await save(isBack: false);
        if (isLocalData.value) {
          clickPushAsset();
        }
      },
    );
    return;
  }
  showAssetEditDialog();
}
```

- [ ] **Step 3: 新增资产输入弹窗**

在 controller 末尾新增弹窗方法及 StatefulWidget：

```dart
void showAssetEditDialog({NoteAsset? asset}) {
  final nameController = TextEditingController(text: asset?.name ?? '');
  final buyController = TextEditingController(text: asset?.buyAmount ?? '');
  final sellController = TextEditingController(text: asset?.sellAmount ?? '');
  final profitText = ''.obs;
  final profitRateText = ''.obs;

  void updateProfit() {
    final buy = double.tryParse(buyController.text);
    final sell = double.tryParse(sellController.text);
    if (buy == null) {
      profitText.value = '-';
      profitRateText.value = '-';
      return;
    }
    final profit = (sell ?? 0) - buy;
    profitText.value = profit.toStringAsFixed(2);
    if (buy == 0) {
      profitRateText.value = '-';
    } else {
      final rate = profit / buy;
      final sign = rate > 0 ? '+' : '';
      profitRateText.value = '$sign${(rate * 100).toStringAsFixed(1)}%';
    }
  }

  updateProfit();
  buyController.addListener(updateProfit);
  sellController.addListener(updateProfit);

  SmartDialog.show(
    alignment: Alignment.bottomCenter,
    animationTime: 0.milliseconds,
    builder: (_) {
      final keyboardHeight = MediaQuery.of(_).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: TextKey.zichanming.tr),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: buyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: TextKey.mairue.tr),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: sellController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: TextKey.maichue.tr),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                  children: [
                    Expanded(child: Text('${TextKey.shouyie.tr}: ${profitText.value}')),
                    Expanded(child: Text('${TextKey.shouyilv.tr}: ${profitRateText.value}')),
                  ],
                )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => SmartDialog.dismiss(),
                        child: Text(TextKey.quxiao.tr),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            QsHud.showToast(TextKey.qingshuru.tr + TextKey.zichanming.tr);
                            return;
                          }
                          final db = Get.find<DatabaseManager>().db;
                          final companion = NoteAssetsCompanion(
                            noteId: Value(localData.value!.id),
                            name: Value(name),
                            buyAmount: Value(buyController.text.trim().isEmpty
                                ? null
                                : buyController.text.trim()),
                            sellAmount: Value(sellController.text.trim().isEmpty
                                ? null
                                : sellController.text.trim()),
                          );
                          if (asset != null) {
                            await db.updateNoteAsset(companion.copyWith(id: Value(asset.id)));
                          } else {
                            await db.addNoteAsset(companion);
                          }
                          await refreshAssets();
                          SmartDialog.dismiss();
                        },
                        child: Text(TextKey.baocun.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
```

- [ ] **Step 4: 在加载已有笔记时刷新资产**

在 `onInit` 中，在 `refreshTags()` 调用后增加 `refreshAssets()`：

```dart
if (localData.value != null) {
  isLocalData.value = true;
  _dealHasLocalDataRefreshUI();
  refreshTags();
  refreshAssets();
}
```

- [ ] **Step 5: 提交**

```bash
git add lib/app/modules/noteedit/controllers/noteedit_controller.dart
git commit -m "feat(note-asset): add asset dialog and controller logic"
```

---

## Task 4: View 底部入口与资产展示

**Files:**
- Modify: `lib/app/modules/noteedit/views/noteedit_view.dart`

**Interfaces:**
- Consumes: `controller.localData.value?.assetList`、`NoteAssetExt`。
- Produces: 底部「资产」按钮、标签下方资产模块 UI。

- [ ] **Step 1: 底部栏新增「资产」入口**

在 `_buildNormalBottomActions` 中，将「标签」与「收藏」之间的代码改为包含「资产」按钮：

```dart
_buildBottomActionItem(
  icon: (local?.tagList.length ?? 0) > 0
      ? Remix.price_tag_3_fill
      : Remix.price_tag_3_line,
  label: TextKey.biaoqian.tr,
  color: (local?.tagList.length ?? 0) > 0 ? Colors.blue : null,
  onTap: canOperate ? controller.clickPushTag : null,
),
_buildBottomActionItem(
  icon: (local?.assetList.length ?? 0) > 0
      ? Icons.account_balance_wallet
      : Icons.account_balance_wallet_outlined,
  label: TextKey.zichan.tr,
  color: (local?.assetList.length ?? 0) > 0 ? Colors.green : null,
  onTap: canOperate ? controller.clickPushAsset : null,
),
_buildBottomActionItem(
  icon: (local?.opCollect ?? false)
      ? Icons.star
      : Icons.star_border_outlined,
  label: TextKey.collect.tr,
  color: (local?.opCollect ?? false) ? Colors.amber : null,
  onTap: canOperate ? controller.clickOpCollect : null,
),
```

- [ ] **Step 2: 在标签展示模块下方新增资产展示模块**

在 `buildQuillEditor()` 上方的 `Divider` 之前（标签展示之后），插入：

```dart
if ((controller.localData.value?.assetList.length ?? 0) > 0)
  Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 4, top: 2),
              child: Icon(
                Icons.account_balance_wallet,
                size: 12,
              ),
            ),
            ...controller.localData.value!.assetList.map((asset) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${asset.name} ${asset.buyAmountText} ${asset.sellAmountText} ${asset.profitRateText ?? '-'}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    ),
  ),
```

- [ ] **Step 3: 提交**

```bash
git add lib/app/modules/noteedit/views/noteedit_view.dart
git commit -m "feat(note-asset): add asset entry in bottom bar and asset display module"
```

---

## Task 5: 测试与验证

**Files:**
- Create: `test/note_asset_ext_test.dart`
- Modify: `test/database_migration_test.dart`（如存在）

**Interfaces:**
- Consumes: `NoteAssetExt`。
- Produces: 通过测试验证收益计算与迁移。

- [ ] **Step 1: 编写收益计算单元测试**

创建 `test/note_asset_ext_test.dart`：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  group('NoteAssetExt', () {
    NoteAsset makeAsset({String? buyAmount, String? sellAmount}) {
      return NoteAsset(
        id: 1,
        noteId: 1,
        name: 'Test',
        buyAmount: buyAmount,
        sellAmount: sellAmount,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
      );
    }

    test('profit and rate calculated correctly', () {
      final asset = makeAsset(buyAmount: '1000', sellAmount: '1200');
      expect(asset.profit, 200.0);
      expect(asset.profitRate, 0.2);
      expect(asset.profitRateText, '+20.0%');
    });

    test('empty buy amount returns null profit and rate', () {
      final asset = makeAsset(sellAmount: '1200');
      expect(asset.profit, isNull);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('zero buy amount returns null rate', () {
      final asset = makeAsset(buyAmount: '0', sellAmount: '1200');
      expect(asset.profit, 1200.0);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('negative profit renders minus sign', () {
      final asset = makeAsset(buyAmount: '1000', sellAmount: '800');
      expect(asset.profit, -200.0);
      expect(asset.profitRateText, '-20.0%');
    });
  });
}
```

- [ ] **Step 2: 运行测试**

```bash
flutter test test/note_asset_ext_test.dart
```

Expected: 全部通过。

- [ ] **Step 3: 静态分析**

```bash
flutter analyze
```

Expected: 无新增错误。

- [ ] **Step 4: 提交**

```bash
git add test/note_asset_ext_test.dart
git commit -m "test(note-asset): add profit calculation unit tests"
```

---

## Task 6: 整体运行验证

**Files:**
- N/A

- [ ] **Step 1: 运行应用**

```bash
flutter run
```

Expected: 应用正常启动，进入笔记编辑页可见「资产」入口，点击可弹出输入框，输入资产名、买入额、卖出额后保存，标签下方展示资产概要。

- [ ] **Step 2: 最终提交或结束工作**

如无需进一步调整，告知用户完成功能。

```bash
git status
```

---

## Self-Review Checklist

- [x] Spec coverage：schema、DAO、文案、Controller 弹窗、View 入口与展示、测试均已覆盖。
- [x] Placeholder scan：无 TBD/TODO。
- [x] Type consistency：`NoteAssetExt`、`NoteAssetsCompanion`、`Value<T>` 用法一致。
- [x] Review Focus：已在 Task 2、Task 3、Task 5 中通过扩展与测试覆盖。
