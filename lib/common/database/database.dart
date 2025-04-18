import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:stock_notes/common/database/tables.dart';

part 'database.g.dart';

//  await Get.putAsync(() async => AppDatabase());
//  final db = Get.find<AppDatabase>();

@DriftDatabase(tables: [StockItems, NoteItems])
class AppDatabase extends _$AppDatabase {
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'stock_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  //stock
  Future<void> addStock(StockItemsCompanion item) => stockItems.insertOne(item);
  Future<void> addStockOnConflictUpdate(StockItemsCompanion item) {
    //item updateAt 设置为当前时间
    item = item.copyWith(updateAt: Value(DateTime.now()));
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

  Future<void> updateBatchStockWithOp(List<StockItem> items) {
    return batch((batch) {
      batch.replaceAll(stockItems, items);
    });
  }

  Future<StockItem> getStockItem(String code) {
    return (select(stockItems)..where((tbl) => tbl.code.equals(code)))
        .getSingle();
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

  Future<NoteItem> getNoteItem(int id) {
    return (select(noteItems)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<List<NoteItem>> getNoteItemsOnHome() {
    return (select(noteItems)
          ..orderBy([
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
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<NoteItem>> getNoteItemsOnHomeWithCollect() {
    return (select(noteItems)
          ..where((tbl) => tbl.opCollect.equals(true))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }
}
