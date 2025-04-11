import 'dart:ui';

import 'package:drift/drift.dart';

export 'dart:ui' show Color;

// String? marketType;
// String? name;
// String? code;
// String? currentPrice;
// String? peRatioTtm;
// String? totalMarketCap;
// String? pbRatio;
class StockItems extends Table with TableMixin {
  TextColumn get marketType => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get currentPrice => text().nullable()();
  TextColumn get peRatioTtm => text().nullable()();
  TextColumn get totalMarketCap => text().nullable()();
  TextColumn get pbRatio => text().nullable()(); //市净率也先不做
  TextColumn get dividendRatio => text().nullable()(); //股息暂时没有

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

  TextColumn get pAllRemark => text().nullable()();
  TextColumn get pEventRemark => text().nullable()();
}

class TodoItems extends Table with TableMixin {
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  // DateTimeColumn get createdAt => dateTime().nullable()();
}

@DataClassName('TodoEntry')
class TodoEntries extends Table with AutoIncrementingPrimaryKey {
  TextColumn get description => text()();

  // entries can optionally be in a category.
  IntColumn get category => integer().nullable().references(Categories, #id)();
  DateTimeColumn get dueDate => dateTime().nullable()();
}

@DataClassName('Category')
class Categories extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  // We can use type converters to store custom classes in tables.
  // Here, we're storing colors as integers.
  IntColumn get color => integer().map(const ColorConverter())();
}

mixin TableMixin on Table {
  // Primary key column
  late final id = integer().autoIncrement()();

  // Column for created at timestamp
  late final createdAt = dateTime().withDefault(currentDateAndTime)();
  // 更新时间，每次更新时手动设置
  late final updateAt = dateTime().withDefault(currentDateAndTime)();
}

// Tables can mix-in common definitions if needed
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();
  @override
  Color fromSql(int fromDb) => Color(fromDb);
  @override
  // ignore: deprecated_member_use
  int toSql(Color value) => value.value;
}
