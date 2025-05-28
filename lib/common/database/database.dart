import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/database/tables.dart';
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
    print(path);
    return LazyDatabase(() async {
      final file = File(path);
      return NativeDatabase(file);
    });
  }

  @override
  int get schemaVersion => 3;

  //改表要处理合并migration
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.createTable(noteItems);
          }
          if (from == 2) {
            await migrator.createTable(stockItemTags);
            await migrator.createTable(stockTags);
          }
        },
        onCreate: (migrator) async {
          await migrator.createAll();
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

  //排除掉删除的，时间倒叙，置顶排序。
  Future<List<StockItem>> getStockItemsOnHome() {
    return (select(stockItems)
          ..where((tbl) => tbl.opDelete.equals(false))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<StockItem>> getStockItemsOnHomeWithDelete() {
    return (select(stockItems)
          ..where((tbl) => tbl.opDelete.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<StockItem>> getStockItemsOnHomeWithCollect() {
    return (select(stockItems)
          ..where((tbl) => tbl.opCollect.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.opTop, mode: OrderingMode.desc),
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
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

enum ConditionStatus {
  none, // 未符合
  nearBuy, // 临近买
  nearSell, // 临近卖
  nearBoth, // 临近买卖
  targetBuy, // 满足买
  targetSell, // 满足卖
  targetBoth, // 满足买卖
}

extension ConditionStatusLabel on ConditionStatus {
  String get label {
    switch (this) {
      case ConditionStatus.targetBuy:
        return TextKey.mangzuB.tr;
      case ConditionStatus.targetSell:
        return TextKey.mangzuS.tr;
      case ConditionStatus.targetBoth:
        return TextKey.mangzumaimai.tr;
      case ConditionStatus.nearBuy:
        return TextKey.lingjinB.tr;
      case ConditionStatus.nearSell:
        return TextKey.lingjinS.tr;
      case ConditionStatus.nearBoth:
        return TextKey.lingjinmaimai.tr;
      default:
        return '';
    }
  }
}

class StockItemExtraState {
  ConditionStatus priceCondition;
  ConditionStatus marketCapCondition;
  ConditionStatus peTtmCondition;
  List<StockItemTag> tagList;

  StockItemExtraState({
    ConditionStatus? priceCondition,
    ConditionStatus? marketCapCondition,
    ConditionStatus? peTtmCondition,
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

  ConditionStatus get priceCondition => extra.priceCondition;
  set priceCondition(ConditionStatus value) => extra.priceCondition = value;

  ConditionStatus get marketCapCondition => extra.marketCapCondition;
  set marketCapCondition(ConditionStatus value) =>
      extra.marketCapCondition = value;

  ConditionStatus get peTtmCondition => extra.peTtmCondition;
  set peTtmCondition(ConditionStatus value) => extra.peTtmCondition = value;

  List<StockItemTag> get tagList => extra.tagList;
  set tagList(List<StockItemTag> value) => extra.tagList = value;

  String? homeCellShowTagNames() {
    return tagList.map((e) => e.name).join(" · ");
  }

  double? pPriceBuyPoints() {
    double? pPriceBuyPoints;
    if ((pPriceBuy ?? "").isNotEmpty && (currentPrice ?? "").isNotEmpty) {
      pPriceBuyPoints =
          (double.parse(pPriceBuy!) - double.parse(currentPrice!)) /
              double.parse(currentPrice!);
    }
    return pPriceBuyPoints;
  }

  double? pMarketCapBuyPoints() {
    double? pMarketCapBuyPoints;
    if ((pMarketCapBuy ?? "").isNotEmpty && (totalMarketCap ?? "").isNotEmpty) {
      pMarketCapBuyPoints =
          (double.parse(pMarketCapBuy!) - double.parse(totalMarketCap!)) /
              double.parse(totalMarketCap!);
    }
    return pMarketCapBuyPoints;
  }

  double? pPeTtmBuyPoints() {
    double? pPeTtmBuyPoints;
    if ((pPeTtmBuy ?? "").isNotEmpty && (peRatioTtm ?? "").isNotEmpty) {
      pPeTtmBuyPoints = (double.parse(pPeTtmBuy!) - double.parse(peRatioTtm!)) /
          double.parse(peRatioTtm!);
    }
    return pPeTtmBuyPoints;
  }

  double? pPriceSalePoints() {
    double? pPriceSalePoints;
    if ((pPriceSale ?? "").isNotEmpty && (currentPrice ?? "").isNotEmpty) {
      pPriceSalePoints =
          (double.parse(pPriceSale!) - double.parse(currentPrice!)) /
              double.parse(currentPrice!);
    }
    return pPriceSalePoints;
  }

  double? pMarketCapSalePoints() {
    double? pMarketCapSalePoints;
    if ((pMarketCapSale ?? "").isNotEmpty &&
        (totalMarketCap ?? "").isNotEmpty) {
      pMarketCapSalePoints =
          (double.parse(pMarketCapSale!) - double.parse(totalMarketCap!)) /
              double.parse(totalMarketCap!);
    }
    return pMarketCapSalePoints;
  }

  double? pPeTtmSalePoints() {
    double? pPeTtmSalePoints;
    if ((pPeTtmSale ?? "").isNotEmpty && (peRatioTtm ?? "").isNotEmpty) {
      pPeTtmSalePoints =
          (double.parse(pPeTtmSale!) - double.parse(peRatioTtm!)) /
              double.parse(peRatioTtm!);
    }
    return pPeTtmSalePoints;
  }

  //自己设置一些条件
  void setConditions() {
    priceCondition = setVarCondition(
      buyPoint: pPriceBuyPoints(),
      salePoint: pPriceSalePoints(),
    );
    marketCapCondition = setVarCondition(
      buyPoint: pMarketCapBuyPoints(),
      salePoint: pMarketCapSalePoints(),
    );
    peTtmCondition = setVarCondition(
      buyPoint: pPeTtmBuyPoints(),
      salePoint: pPeTtmSalePoints(),
    );
  }

  ConditionStatus setVarCondition({
    double? buyPoint,
    double? salePoint,
  }) {
    double kNearPoints = GlobalService.to.rxNearBSPoint.value;
    bool isTargetBuy = buyPoint != null && buyPoint >= 0.0;
    bool isNearBuy = buyPoint != null && buyPoint >= -kNearPoints;
    bool isTargetSell = salePoint != null && salePoint <= 0.0;
    bool isNearSell = salePoint != null && salePoint <= kNearPoints;
    ConditionStatus tempCondition = ConditionStatus.none;
    if (isTargetBuy && isTargetSell) {
      tempCondition = ConditionStatus.targetBoth;
    } else if (isTargetBuy) {
      tempCondition = ConditionStatus.targetBuy;
    } else if (isTargetSell) {
      tempCondition = ConditionStatus.targetSell;
    } else if (isNearBuy && isNearSell) {
      tempCondition = ConditionStatus.nearBoth;
    } else if (isNearBuy) {
      tempCondition = ConditionStatus.nearBuy;
    } else if (isNearSell) {
      tempCondition = ConditionStatus.nearSell;
    }
    return tempCondition;
  }

  //股票页面使用
  String showCellConditionInfo() {
    String showCellConditionInfo = "";
    if (priceCondition.label.isNotEmpty) {
      showCellConditionInfo =
          TextKey.stockCellP.tr + ":" + priceCondition.label;
    }
    if (marketCapCondition.label.isNotEmpty) {
      showCellConditionInfo = showCellConditionInfo +
          "\n" +
          TextKey.stockCellM.tr +
          ":" +
          marketCapCondition.label;
    }
    if (peTtmCondition.label.isNotEmpty) {
      showCellConditionInfo = showCellConditionInfo +
          "\n" +
          TextKey.stockCellPe.tr +
          ":" +
          peTtmCondition.label;
    }
    return showCellConditionInfo;
  }

  //首页条件筛选
  bool homeConditionTarget(ConditionStatus status) {
    if (status == ConditionStatus.targetBoth) {
      return priceCondition == ConditionStatus.targetBoth ||
          priceCondition == ConditionStatus.targetBuy ||
          priceCondition == ConditionStatus.targetSell ||
          peTtmCondition == ConditionStatus.targetBoth ||
          peTtmCondition == ConditionStatus.targetSell ||
          peTtmCondition == ConditionStatus.targetBuy ||
          marketCapCondition == ConditionStatus.targetBoth ||
          marketCapCondition == ConditionStatus.targetBuy ||
          marketCapCondition == ConditionStatus.targetSell;
    } else {
      return status == priceCondition ||
          status == marketCapCondition ||
          status == peTtmCondition;
    }
  }

  bool homeConditionNear(ConditionStatus status) {
    if (status == ConditionStatus.nearBoth) {
      return priceCondition == ConditionStatus.nearBoth ||
          priceCondition == ConditionStatus.nearBuy ||
          priceCondition == ConditionStatus.nearSell ||
          peTtmCondition == ConditionStatus.nearBoth ||
          peTtmCondition == ConditionStatus.nearSell ||
          peTtmCondition == ConditionStatus.nearBuy ||
          marketCapCondition == ConditionStatus.nearBoth ||
          marketCapCondition == ConditionStatus.nearBuy ||
          marketCapCondition == ConditionStatus.nearSell;
    } else {
      return status == priceCondition ||
          status == marketCapCondition ||
          status == peTtmCondition;
    }
  }
}
