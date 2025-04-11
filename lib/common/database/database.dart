import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:stock_notes/common/database/tables.dart';

part 'database.g.dart';

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
  Future<void> deleteStock(StockItem itemDelete) =>
      managers.stockItems.filter((f) => f.id(itemDelete.id)).delete();

  Future<void> updateStock(StockItem itemUpdate) {
    final updatedItem = itemUpdate.copyWith(updateAt: DateTime.now());
    return managers.stockItems.replace(updatedItem);
  }

  // Future<List<StockItem>> get allStockItems => managers.stockItems.get();
  // Future<List<StockItem>> getAllStockItems() async {
  //   return await managers.stockItems.get();
  // }

  Future<List<StockItem>> getStockItemsByTimeDesc() {
    return (select(stockItems)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.updateAt, mode: OrderingMode.desc),
          ]))
        .get();
  }
}
