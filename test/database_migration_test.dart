import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

/// A database that creates the schema as it existed at version 6, before
/// the v7 migration added open_price/open_shares/etc. to stock_trades.
class _V6Database extends AppDatabase {
  _V6Database(super.path);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          // Create all non-trade tables with their current schema.
          await migrator.createTable(stockItems);
          await migrator.createTable(noteItems);
          await migrator.createTable(stockItemTags);
          await migrator.createTable(stockTags);
          await migrator.createTable(noteItemTags);
          await migrator.createTable(noteTags);
          // stock_trades at v6: no open_price/open_shares/close_price/close_shares
          // plan_buy_price/plan_sale_price columns.
          await customStatement('''
            CREATE TABLE stock_trades (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') AS INTEGER) * 1000),
              update_at INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') AS INTEGER) * 1000),
              stock_id INTEGER NOT NULL REFERENCES stock_items(id),
              trade_type INTEGER NOT NULL,
              price TEXT,
              shares TEXT,
              remark TEXT,
              trade_date INTEGER
            )
          ''');
        },
      );
}

void main() {
  test(
      'v6 to v7 migration copies price/shares into open_price/open_shares',
      () async {
    final dir = await Directory.systemTemp.createTemp('migration_test');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/v6_to_v7.db';

    // Create a v6 database and insert a legacy trade.
    final v6db = _V6Database(path);
    await v6db.stockItems.insertOne(
      StockItemsCompanion.insert(
        marketType: 'CN',
        name: 'Test Stock',
        code: '000001',
      ),
    );
    const price = '123.45';
    const shares = '100';
    await v6db.customStatement(
      'INSERT INTO stock_trades (stock_id, trade_type, price, shares) VALUES (?, ?, ?, ?)',
      [1, 0, price, shares],
    );
    await v6db.close();

    // Reopen with the real v7 database and run the migration.
    final v7db = AppDatabase(path);
    final trades = await v7db.getStockTradesByStockId(1);
    await v7db.close();

    expect(trades, hasLength(1));
    final trade = trades.first;
    expect(trade.price, price);
    expect(trade.shares, shares);
    expect(trade.openPrice, price);
    expect(trade.openShares, shares);
  });
}
