# 持有操作状态（锁仓/停买/停卖）设计

日期：2026-08-05

## 需求

1. 股票详情页（stockedit）"记录"区块：持有成本价有值时，标题"记录"后面显示 锁仓 / 停买 / 停卖 三个操作按钮。
2. 首页股票列表：代码行持有收益率后面显示对应的小标签（选了锁仓就显示"锁仓"标签，以此类推）。

## 已确认的决策

- **单选，可取消**：三个状态互斥，再点选中的按钮取消（回到无状态）。
- **点击立即保存**：走 `db.updateStockWithOp` 同款路径立即入库，不随页面"保存"按钮。
- **仅标记展示**：不影响买卖计划、条件提醒等其他逻辑。

## 数据存储

`StockItems` 新增列：

```dart
IntColumn get rHoldStatus => integer().withDefault(const Constant(0))();
// 0=无, 1=锁仓, 2=停买, 3=停卖
```

- `schemaVersion` 7 → 8；迁移 `from <= 7` 时 `addColumn(stockItems, stockItems.rHoldStatus)`。
- 改完执行 `dart run build_runner build` 重新生成 `database.g.dart`。

## 详情页（stockedit）

- **显示条件**：与持有股数输入框一致，用 `rBuyPriceValid`（成本价为有效正数）控制。
- **位置**：`_gupiaojilu()` 标题行"记录"后追加三个小按钮，选中态高亮。
- **行为**：
  - 点击立即写库并刷新本地状态（参照 `clickOpBuy`）。
  - 未保存的新股票点击时走 `_popSaveAlert` 先保存再操作。
- `save()` 的 `StockItemsCompanion` 不含此字段（即时入库，不属于表单保存范畴）。
- 成本价清空后按钮隐藏，数据库中的状态保留但各处不展示。

## 首页列表（homestock）

- `HomeStockCell` 代码行、持有收益率文本后追加小标签（样式参照现有 tagList 圆角小标签）。
- 仅当 `rHoldStatus != 0` 且持有收益率存在时显示。
- 颜色：锁仓=蓝、停买=绿、停卖=红。

## 国际化

`text_key.dart` 新增三个 key（中英双语）：

| key | zh_CN | en_US |
|---|---|---|
| suocang | 锁仓 | Lock |
| tingmai | 停买 | No Buy |
| tingmaichu / tingsell | 停卖 | No Sell |

## 测试

- `flutter analyze` 通过。
- `flutter test` 通过（当前为占位冒烟测试）。
