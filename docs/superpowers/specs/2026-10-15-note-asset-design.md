# 笔记资产模块设计文档

## 目标

在笔记编辑页底部操作栏新增「资产」入口，允许为单条笔记关联多条资产记录。每条资产包含资产名、买入额、卖出额，并自动计算收益额与收益比。保存后在笔记正文前、标签下方展示资产概要。

## 功能范围

1. **入口位置**：笔记编辑页底部 tab，位于「标签」与「收藏」之间，图标按钮显示「资产」。
2. **资产输入弹窗**：点击「资产」按钮弹出底部弹窗，包含：
   - 资产名输入框
   - 买入额输入框（数字）
   - 卖出额输入框（数字）
   - 保存/取消按钮
   - 自动根据买入额、卖出额计算收益额与收益比并展示
3. **资产列表展示**：保存后在笔记标签下方展示资产模块，形如：
   - `资产名 买入额 收入额 收益比`
   - 每条资产一行，支持长按删除或点击编辑（后续可扩展，首期先支持新增与删除）。
4. **数据持久化**：新建资产表 `NoteAssets`，通过 `noteId` 关联 `NoteItems`。
5. **编辑态/预览态**：仅在非编辑态（预览态）底部栏显示「资产」入口；编辑态先保存笔记再操作（参考标签按钮逻辑）。
6. **空态**：没有资产时不展示资产模块。

## 数据模型

```dart
class NoteAssets extends Table with TableMixin {
  IntColumn get noteId => integer().references(NoteItems, #id)();
  TextColumn get name => text()();
  TextColumn get buyAmount => text().nullable()(); // 买入额
  TextColumn get sellAmount => text().nullable()(); // 卖出额
}
```

`TableMixin` 提供 `id`、`createdAt`、`updateAt`。

## 计算规则

- 收益额 = 卖出额 - 买入额
- 收益比 = 收益额 / 买入额
- 买入额为空或 0 时，收益额与收益比显示为 `-`
- 卖出额为空时视为 0

## UI 设计

### 底部操作栏

在 `_buildNormalBottomActions` 的「标签」与「收藏」之间插入：

```dart
_buildBottomActionItem(
  icon: (local?.assetList.length ?? 0) > 0
      ? Icons.account_balance_wallet
      : Icons.account_balance_wallet_outlined,
  label: TextKey.zichan.tr,
  color: (local?.assetList.length ?? 0) > 0 ? Colors.green : null,
  onTap: canOperate ? controller.clickPushAsset : null,
),
```

### 资产输入弹窗

使用 `SmartDialog.show` 底部弹出，白色背景，圆角，包含三个输入框和实时计算展示：

```
资产名      [________]
买入额      [________]
卖出额      [________]

收益额: 1234.00   收益比: +12.34%

[取消] [保存]
```

### 资产模块展示

在标签展示区域下方新增条件判断：

```dart
if ((controller.localData.value?.assetList.length ?? 0) > 0)
  Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(Icons.account_balance_wallet, size: 12), ...]),
        ...assets.map((e) => Text('${e.name} ${e.buyAmount} ${e.sellAmount} ${e.profitRateText}')),
      ],
    ),
  ),
```

## 文件变更

- `lib/common/database/tables.dart`：新增 `NoteAssets` 表。
- `lib/common/database/database.dart`：
  - 注册新表
  - schemaVersion 升级到 13
  - 新增 migration `from <= 12` 创建 `NoteAssets` 表
  - 新增 DAO 方法：`getNoteAssetsByNoteId`、`addNoteAsset`、`deleteNoteAsset`、`updateNoteAsset`
  - 扩展 `NoteItemExt` 增加 `assetList`
- `lib/common/langs/text_key.dart` 及 `zh`/`en`：新增资产相关文案。
- `lib/app/modules/noteedit/controllers/noteedit_controller.dart`：
  - 新增资产弹窗逻辑
  - 新增 `clickPushAsset`、`refreshAssets`、资产输入弹窗方法
- `lib/app/modules/noteedit/views/noteedit_view.dart`：
  - 底部栏新增「资产」按钮
  - 正文前新增资产展示模块

## 测试

- 单元测试：验证收益额、收益比计算（买入额 1000，卖出额 1200 ⇒ 收益额 200，收益比 +20.0%）。
- 数据库迁移测试：验证升级到 schemaVersion 13 后 `NoteAssets` 表存在。

## 风险与边界

- 笔记未保存时点击「资产」需要先保存，参考标签逻辑弹出「保存并操作」确认。
- 资产记录删除后不可恢复，与标签不同，删除为立即生效。
- 数字字段使用 `TextColumn` 存储字符串，与现有交易记录 `price`/`shares` 保持一致。
