import 'package:drift/drift.dart';

export 'dart:ui' show Color;

class StockItems extends Table with TableMixin {
  TextColumn get marketType => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get currentPrice => text().nullable()();
  TextColumn get peRatioTtm => text().nullable()();
  TextColumn get totalMarketCap => text().nullable()();
  TextColumn get pbRatio => text().nullable()(); //市净率也先不做
  TextColumn get dividendRatio => text().nullable()(); //股息暂时没有

  BoolColumn get opTop => boolean().withDefault(const Constant(false))();
  BoolColumn get opCollect => boolean().withDefault(const Constant(false))();
  BoolColumn get opDelete => boolean().withDefault(const Constant(false))();
  BoolColumn get opBuy => boolean().withDefault(const Constant(false))();

  //p 计划
  TextColumn get pPriceBuy => text().nullable()();
  TextColumn get pPriceSale => text().nullable()();
  TextColumn get pPriceRemark => text().nullable()();
  TextColumn get pMarketCapBuy => text().nullable()();
  TextColumn get pMarketCapSale => text().nullable()();
  TextColumn get pMarketRemark => text().nullable()();
  TextColumn get pPeTtmBuy => text().nullable()();
  TextColumn get pPeTtmSale => text().nullable()();
  TextColumn get pPeTtmRemark => text().nullable()();

  //记录
  TextColumn get rAllRemark => text().nullable()();
  TextColumn get rEventRemark => text().nullable()();
  TextColumn get rBuyPrice => text().nullable()(); //买入成本
}

class NoteItems extends Table with TableMixin {
  TextColumn get title => text()();
  TextColumn get content => text().nullable()();
  BoolColumn get opTop => boolean().withDefault(const Constant(false))();
  BoolColumn get opCollect => boolean().withDefault(const Constant(false))();
  BoolColumn get opDelete => boolean().withDefault(const Constant(false))();
}

mixin TableMixin on Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updateAt => dateTime().withDefault(currentDateAndTime)();
}

class StockItemTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class StockTags extends Table {
  IntColumn get stockId => integer().references(StockItems, #id)();
  IntColumn get tagId => integer().references(StockItemTags, #id)();
  @override
  Set<Column> get primaryKey => {stockId, tagId};
}

// class NoteTags extends Table {
//   IntColumn get noteId =>
//       integer().customConstraint('REFERENCES note_items(id)')();
//   IntColumn get tagId => integer().customConstraint('REFERENCES tags(id)')();
//   @override
//   Set<Column> get primaryKey => {noteId, tagId};
// }

// class TodoItems extends Table with TableMixin {
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
// // DateTimeColumn get createdAt => dateTime().nullable()();
// }
// @DataClassName('TodoEntry')
// class TodoEntries extends Table with AutoIncrementingPrimaryKey {
//   TextColumn get description => text()();
//
//   // entries can optionally be in a category.
//   IntColumn get category => integer().nullable().references(Categories, #id)();
//   DateTimeColumn get dueDate => dateTime().nullable()();
// }
//
// @DataClassName('Category')
// class Categories extends Table with AutoIncrementingPrimaryKey {
//   TextColumn get name => text()();
//   // We can use type converters to store custom classes in tables.
//   // Here, we're storing colors as integers.
//   IntColumn get color => integer().map(const ColorConverter())();
// }
//
// // Tables can mix-in common definitions if needed
// mixin AutoIncrementingPrimaryKey on Table {
//   IntColumn get id => integer().autoIncrement()();
// }
//
// class ColorConverter extends TypeConverter<Color, int> {
//   const ColorConverter();
//   @override
//   Color fromSql(int fromDb) => Color(fromDb);
//   @override
//   // ignore: deprecated_member_use
//   int toSql(Color value) => value.value;
// }
