import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:stock_notes/common/database/tables.dart';

part 'database.g.dart';

//  await Get.putAsync(() async => AppDatabase());
//  final db = Get.find<AppDatabase>();

@DriftDatabase(tables: [StockItems]) //TodoItems,
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

  // Future<void> addTodo(TodoItem item) => into(todoItems).insert(item);
  // Future<void> deleteTodo(TodoItem itemDelete) =>
  //     managers.todoItems.filter((f) => f.id(itemDelete.id)).delete();
  // Future<void> updateTodo(TodoItem itemUpdate) =>
  //     managers.todoItems.replace(itemUpdate);
  // Future<List<TodoItem>> get allTodoItems => managers.todoItems.get();
  // Future<List<TodoItem>> getAllTodoItems() async {
  //   return await managers.todoItems.get();
  // }

  Future<void> addStock(StockItemsCompanion item) => stockItems.insertOne(item);
  Future<void> addStockOnConflictUpdate(StockItemsCompanion item) {
    //item updateAt 设置为当前时间
    item = item.copyWith(updateAt: Value(DateTime.now()));
    return stockItems.insertOnConflictUpdate(item);
  }

  // Future<void> deleteStock(StockItem itemDelete) =>
  //     managers.stockItems.filter((f) => f.id(itemDelete.id)).delete();
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

  // Future<void> updateStockWithContent(StockItem itemUpdate) {
  //   final updatedItem = itemUpdate.copyWith(updateAt: DateTime.now());
  //   return managers.stockItems.replace(itemUpdate);
  // }
  // Future<List<StockItem>> get allStockItems => managers.stockItems.get();
  // Future<List<StockItem>> getAllStockItems() async {
  //   return await managers.stockItems.get();
  // }

  // Future<List<StockItem>> getStockItemsByTimeDesc() {
  //   return (select(stockItems)
  //         ..orderBy([
  //           (tbl) =>
  //               OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
  //         ]))
  //       .get();
  // }

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
}
