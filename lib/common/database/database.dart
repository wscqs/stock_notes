import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/database/tables.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../globle_service.dart';

part 'database.g.dart';

//  await Get.putAsync(() async => AppDatabase());
//  final db = Get.find<AppDatabase>();

@DriftDatabase(tables: [StockItems, NoteItems, StockItemTags, StockTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String path) : super(_openConnection(path));
  //网页需后端Web:TypeError: Failed to execute 'compile' on 'WebAssembly': Incorrect response MIME type. Expected 'application/wasm'.
  // static QueryExecutor _openConnection(String path) {
  //   return driftDatabase(
  //     name: 'stock_database',
  //     web: DriftWebOptions(
  //       sqlite3Wasm: Uri.parse('sqlite3.wasm'),
  //       driftWorker: Uri.parse('drift_worker.js'),
  //     ),
  //   );
  // }

  static LazyDatabase _openConnection(String path) {
    // print(path);
    return LazyDatabase(() async {
      final file = File(path);
      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 2;

  //改表要处理合并migration
  @override
  MigrationStrategy get migration => MigrationStrategy(
        // onUpgrade: (migrator, from, to) async {
        //   if (from == 1) {
        //     await migrator.createTable(noteItems);
        //   }
        //   if (from == 2) {
        //     await migrator.createTable(stockItemTags);
        //     await migrator.createTable(stockTags);
        //   }
        //   if (from == 3) {
        //     await migrator.addColumn(stockItems, stockItems.opBuy);
        //   }
        // },
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.addColumn(
                stockItems, stockItems.cMarketCapCondition);
            await migrator.addColumn(stockItems, stockItems.cPriceCondition);
            await migrator.addColumn(stockItems, stockItems.cPeTtmCondition);
          }
        },
        onCreate: (migrator) async {
          await migrator.createAll();
          //标签默认加五个。 短期，中期，长期，买，卖
          await batch((batch) {
            batch.insertAll(stockItemTags, [
              StockItemTagsCompanion.insert(name: '短期'),
              StockItemTagsCompanion.insert(name: '中期'),
              StockItemTagsCompanion.insert(name: '长期'),
              StockItemTagsCompanion.insert(name: '买'),
              StockItemTagsCompanion.insert(name: '卖'),
            ]);
          });
        },
      );

  //stock
  Future<void> addStock(StockItemsCompanion item) => stockItems.insertOne(item);
  //有改动更新时间
  Future<void> addStockOnConflictUpdate(StockItemsCompanion item) {
    //item updateAt 设置为当前时间
    item = item.copyWith(updateAt: Value(DateTime.now()));
    return stockItems.insertOnConflictUpdate(item);
  }

  //没改动更新时间
  Future<void> addStockOnConflictUpdateWithNoUpdateTime(
      StockItemsCompanion item) {
    return stockItems.insertOnConflictUpdate(item);
  }

  //真正删除（如果是删除到删除列表，用更新）
  Future<void> deleteStock(StockItem itemDelete) {
    return (delete(stockItems)..where((tbl) => tbl.id.equals(itemDelete.id)))
        .go();
  }

  Future<void> deleteStockList(List<StockItem> items) {
    final ids = items.map((e) => e.id).toList();
    return (delete(stockItems)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  // 单条更新，不改动 updatedAt
  Future<void> updateStockWithOp(StockItem itemUpdate) {
    return update(stockItems).replace(itemUpdate);
  }

  Future<void> updateStock(
    StockItemsCompanion updatedItem,
    String code,
  ) {
    return (update(stockItems)..where((tbl) => tbl.code.equals(code)))
        .write(updatedItem);
  }

  Future<void> updateBatchStockWithOp(List<StockItem> items) {
    return batch((batch) {
      batch.replaceAll(stockItems, items);
    });
  }

  Future<StockItem?> getStockItem(String code) {
    return (select(stockItems)..where((tbl) => tbl.code.equals(code)))
        .getSingleOrNull();
  }

  Future<List<StockItem>> getStockItemsWithTagsByStockItems(
      List<StockItem> items) async {
    if (items.isEmpty) return [];
    final stockIds = items.map((e) => e.id).toList();
    // 查询所有 stockId 对应的标签关联（一次性）
    final tagJoinQuery = select(stockItemTags).join([
      innerJoin(stockTags, stockTags.tagId.equalsExp(stockItemTags.id)),
    ])
      ..where(stockTags.stockId.isIn(stockIds));
    final joinedRows = await tagJoinQuery.get();
    // 构造 Map<stockId, List<Tag>>
    final tagMap = <int, List<StockItemTag>>{};
    for (final row in joinedRows) {
      final tag = row.readTable(stockItemTags);
      final stockId = row.readTable(stockTags).stockId;
      tagMap.putIfAbsent(stockId, () => []).add(tag);
    }
    // 赋值 tagList
    for (final item in items) {
      item.tagList = tagMap[item.id] ?? [];
    }
    return items;
  }

  Future<StockItem?> getStockItemWithTagsByCode(String code) async {
    // 查询主对象
    final item = await (select(stockItems)
          ..where((tbl) => tbl.code.equals(code)))
        .getSingleOrNull();
    if (item == null) return null;
    // 查询关联的标签
    final tagJoinQuery = select(stockItemTags).join([
      innerJoin(stockTags, stockTags.tagId.equalsExp(stockItemTags.id)),
    ])
      ..where(stockTags.stockId.equals(item.id));
    final joinedRows = await tagJoinQuery.get();
    // 提取标签
    final tagList =
        joinedRows.map((row) => row.readTable(stockItemTags)).toList();
    item.tagList = tagList;
    return item;
  }

  //排除掉删除的，时间倒叙，置顶排序。
  Future<List<StockItem>> getStockItemsOnHome(
      {bool isMeet = false, bool isNear = false}) {
    return (select(stockItems)
          ..where((tbl) => tbl.opDelete.equals(false))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) => OrderingTerm(
                expression: isMeet
                    ? tbl.cMeetUpdateAt
                    : isNear
                        ? tbl.cNearUpdateAt
                        : tbl.updateAt,
                mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<StockItem>> getStockItemsOnHomeWithDelete(
      {bool isMeet = false, bool isNear = false}) {
    return (select(stockItems)
          ..where((tbl) => tbl.opDelete.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) => OrderingTerm(
                expression: isMeet
                    ? tbl.cMeetUpdateAt
                    : isNear
                        ? tbl.cNearUpdateAt
                        : tbl.updateAt,
                mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<StockItem>> getStockItemsOnHomeWithCollect(
      {bool isMeet = false, bool isNear = false}) {
    return (select(stockItems)
          ..where((tbl) => tbl.opCollect.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) => OrderingTerm(
                expression: isMeet
                    ? tbl.cMeetUpdateAt
                    : isNear
                        ? tbl.cNearUpdateAt
                        : tbl.updateAt,
                mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<StockItem>> getStockItemsOnHomeWithBuy(
      {bool isMeet = false, bool isNear = false}) {
    return (select(stockItems)
          ..where((tbl) => tbl.opBuy.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) => OrderingTerm(
                expression: isMeet
                    ? tbl.cMeetUpdateAt
                    : isNear
                        ? tbl.cNearUpdateAt
                        : tbl.updateAt,
                mode: OrderingMode.desc),
          ]))
        .get();
  }

  //tags
  Future<void> addStockItemTag(StockItemTagsCompanion item) =>
      stockItemTags.insertOne(item);
  Future<void> addStockItemTagOnConflictUpdate(StockItemTagsCompanion item) {
    return stockItemTags.insertOnConflictUpdate(item);
  }

  Future<void> deleteStockItemTag(StockItemTag itemDelete) {
    return (delete(stockItemTags)..where((tbl) => tbl.id.equals(itemDelete.id)))
        .go();
  }

  Future<void> updateStockItemTagWithOp(StockItemTag itemUpdate) {
    return update(stockItemTags).replace(itemUpdate);
  }

  Future<void> updateStockItemTag(
    StockItemTagsCompanion updatedItem,
    int id,
  ) {
    return (update(stockItemTags)..where((tbl) => tbl.id.equals(id)))
        .write(updatedItem);
  }

  Future<List<StockItemTag>> getStockItemTags() {
    return (select(stockItemTags)).get();
  }

  Future<StockItemTag?> getStockItemTag(String name) {
    return (select(stockItemTags)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  // stock_tags
  Future<List<StockTag>> getStockTagsByStockItemId(int stockId) {
    return (select(stockTags)..where((tbl) => tbl.stockId.equals(stockId)))
        .get();
  }

  Future<void> updateStockTagsByStockItemId(
      int stockId, List<StockItemTag> selTags) {
    return batch((batch) {
      batch.deleteWhere(stockTags, (tbl) => tbl.stockId.equals(stockId));
      for (var item in selTags) {
        batch.insert(
            stockTags,
            StockTagsCompanion.insert(
              stockId: stockId,
              tagId: item.id,
            ));
      }
    });
  }

  //note
  Future<void> addNote(NoteItemsCompanion item) => noteItems.insertOne(item);
  Future<void> addNoteOnConflictUpdate(NoteItemsCompanion item) {
    //item updateAt 设置为当前时间
    item = item.copyWith(updateAt: Value(DateTime.now()));
    return noteItems.insertOnConflictUpdate(item);
  }

  Future<void> deleteNote(NoteItem itemDelete) {
    return (delete(noteItems)..where((tbl) => tbl.id.equals(itemDelete.id)))
        .go();
  }

  Future<void> deleteNoteList(List<NoteItem> items) {
    final ids = items.map((e) => e.id).toList();
    return (delete(noteItems)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  Future<void> updateNoteWithOp(NoteItem itemUpdate) {
    return update(noteItems).replace(itemUpdate);
  }

  Future<void> updateBatchNoteWithOp(List<NoteItem> items) {
    return batch((batch) {
      batch.replaceAll(noteItems, items);
    });
  }

  Future<NoteItem?> getNoteItem(int id) {
    return (select(noteItems)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<NoteItem>> getNoteItemsOnHome() {
    return (select(noteItems)
          ..where((tbl) => tbl.opDelete.equals(false))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<NoteItem>> getNoteItemsOnHomeWithDelete() {
    return (select(noteItems)
          ..where((tbl) => tbl.opDelete.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<NoteItem>> getNoteItemsOnHomeWithCollect() {
    return (select(noteItems)
          ..where((tbl) => tbl.opCollect.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }
}

//Stock

// const kNearPoints = 0.03;
class ConditionStatus {
  static const int none = 0;

  static const int nearBuy = 1 << 0; // 0001
  static const int nearSell = 1 << 1; // 0010
  static const int nearBoth = nearBuy | nearSell;

  static const int targetBuy = 1 << 2; // 0100
  static const int targetSell = 1 << 3; // 1000
  static const int targetBoth = targetBuy | targetSell;
}

extension ConditionStatusExt on int {
  bool get hasNearBuy => (this & ConditionStatus.nearBuy) != 0;
  bool get hasNearSell => (this & ConditionStatus.nearSell) != 0;
  bool get hasTargetBuy => (this & ConditionStatus.targetBuy) != 0;
  bool get hasTargetSell => (this & ConditionStatus.targetSell) != 0;

  bool get isNearBoth =>
      (this & ConditionStatus.nearBoth) == ConditionStatus.nearBoth;
  bool get isTargetBoth =>
      (this & ConditionStatus.targetBoth) == ConditionStatus.targetBoth;

  // bool get isNearSingle =>
  //     (this & ConditionStatus.nearBoth) != 0 &&
  //     (this & ConditionStatus.nearBoth) != ConditionStatus.nearBoth;

  // bool get isTargetSingle =>
  //     (this & ConditionStatus.targetBoth) != 0 &&
  //     (this & ConditionStatus.targetBoth) != ConditionStatus.targetBoth;

  bool get isNear => hasNearBuy || hasNearSell || isNearBoth;
  bool get isTarget => hasTargetBuy || hasTargetSell || isTargetBoth;

  String get label {
    if (hasTargetBuy && hasTargetSell) return TextKey.mangzuBS.tr;
    if (hasTargetBuy) return TextKey.mangzuB.tr;
    if (hasTargetSell) return TextKey.mangzuS.tr;
    if (hasNearBuy && hasNearSell) return TextKey.lingjinBS.tr;
    if (hasNearBuy) return TextKey.lingjinB.tr;
    if (hasNearSell) return TextKey.lingjinS.tr;
    return '';
  }
}

class StockItemExtraState {
  int priceCondition;
  int marketCapCondition;
  int peTtmCondition;
  List<StockItemTag> tagList;

  StockItemExtraState({
    int? priceCondition,
    int? marketCapCondition,
    int? peTtmCondition,
    List<StockItemTag>? tagList,
  })  : priceCondition = priceCondition ?? ConditionStatus.none,
        marketCapCondition = marketCapCondition ?? ConditionStatus.none,
        peTtmCondition = peTtmCondition ?? ConditionStatus.none,
        tagList = tagList ?? [];
}

final Map<int, StockItemExtraState> _stockItemExtras = {};

StockItemExtraState _getExtra(int id) {
  return _stockItemExtras.putIfAbsent(id, () => StockItemExtraState());
}

extension StockItemExt on StockItem {
  StockItemExtraState get extra => _getExtra(id);

  int get priceCondition => extra.priceCondition;
  set priceCondition(int value) => extra.priceCondition = value;

  int get marketCapCondition => extra.marketCapCondition;
  set marketCapCondition(int value) => extra.marketCapCondition = value;

  int get peTtmCondition => extra.peTtmCondition;
  set peTtmCondition(int value) => extra.peTtmCondition = value;

  List<StockItemTag> get tagList => extra.tagList;
  set tagList(List<StockItemTag> value) => extra.tagList = value;

  String? homeCellShowTagNames() {
    return tagList.map((e) => e.name).join(" · ");
  }

  String homeCellShowTime({isMeet = false, isNear = false}) {
    return isMeet
        ? ("m" + cMeetUpdateAt.toDateString())
        : isNear
            ? ("n" + cNearUpdateAt.toDateString())
            : updateAt.toDateString();
  }

  double? _calcPoint(String? target, String? current) {
    if ((target ?? "").isNotEmpty && (current ?? "").isNotEmpty) {
      return (double.parse(target!) - double.parse(current!)) /
          double.parse(current);
    }
    return null;
  }

  double? pPriceBuyPoints() => _calcPoint(pPriceBuy, currentPrice);
  double? pMarketCapBuyPoints() => _calcPoint(pMarketCapBuy, totalMarketCap);
  double? pPeTtmBuyPoints() => _calcPoint(pPeTtmBuy, peRatioTtm);

  double? pPriceSalePoints() => _calcPoint(pPriceSale, currentPrice);
  double? pMarketCapSalePoints() => _calcPoint(pMarketCapSale, totalMarketCap);
  double? pPeTtmSalePoints() => _calcPoint(pPeTtmSale, peRatioTtm);

  void setConditions() {
    extra.priceCondition = _setVarCondition(
      buyPoint: pPriceBuyPoints(),
      salePoint: pPriceSalePoints(),
    );
    extra.marketCapCondition = _setVarCondition(
      buyPoint: pMarketCapBuyPoints(),
      salePoint: pMarketCapSalePoints(),
    );
    extra.peTtmCondition = _setVarCondition(
      buyPoint: pPeTtmBuyPoints(),
      salePoint: pPeTtmSalePoints(),
    );
  }

  int _setVarCondition({
    double? buyPoint,
    double? salePoint,
  }) {
    double kNearPoints = GlobalService.to.rxNearBSPoint.value;
    int status = ConditionStatus.none;

    if (buyPoint != null && buyPoint >= 0.0) {
      status |= ConditionStatus.targetBuy;
    } else if (buyPoint != null && buyPoint >= -kNearPoints) {
      status |= ConditionStatus.nearBuy;
    }

    if (salePoint != null && salePoint <= 0.0) {
      status |= ConditionStatus.targetSell;
    } else if (salePoint != null && salePoint <= kNearPoints) {
      status |= ConditionStatus.nearSell;
    }

    return status;
  }

  String showCellConditionInfo() {
    String result = "";

    void append(int condition, String prefix) {
      final label = condition.label;
      if (label.isNotEmpty) {
        if (result.isNotEmpty) result += "\n";
        result += "$prefix:$label";
      }
    }

    // append(extra.priceCondition, TextKey.stockCellP.tr);
    // append(extra.marketCapCondition, TextKey.stockCellM.tr);
    // append(extra.peTtmCondition, TextKey.stockCellPe.tr);

    append(cPriceCondition, TextKey.stockCellP.tr);
    append(cMarketCapCondition, TextKey.stockCellM.tr);
    append(cPeTtmCondition, TextKey.stockCellPe.tr);

    return result.replaceAll('买', 'B').replaceAll('卖', 'S');
  }

  bool _matchCondition(int field, int target) {
    if (target == ConditionStatus.targetBoth) {
      return field.hasTargetBuy || field.hasTargetSell;
    }
    if (target == ConditionStatus.nearBoth) {
      return field.hasNearBuy || field.hasNearSell;
    }
    return (field & target) != 0;
  }

  bool homeConditionTarget(int status) {
    // return _matchCondition(extra.priceCondition, status) ||
    //     _matchCondition(extra.marketCapCondition, status) ||
    //     _matchCondition(extra.peTtmCondition, status);
    return _matchCondition(cPriceCondition, status) ||
        _matchCondition(cMarketCapCondition, status) ||
        _matchCondition(cPeTtmCondition, status);
  }

  bool homeConditionNear(int status) {
    // return _matchCondition(extra.priceCondition, status) ||
    //     _matchCondition(extra.marketCapCondition, status) ||
    //     _matchCondition(extra.peTtmCondition, status);
    return _matchCondition(cPriceCondition, status) ||
        _matchCondition(cMarketCapCondition, status) ||
        _matchCondition(cPeTtmCondition, status);
  }
}
