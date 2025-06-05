// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StockItemsTable extends StockItems
    with TableInfo<$StockItemsTable, StockItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _marketTypeMeta =
      const VerificationMeta('marketType');
  @override
  late final GeneratedColumn<String> marketType = GeneratedColumn<String>(
      'market_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentPriceMeta =
      const VerificationMeta('currentPrice');
  @override
  late final GeneratedColumn<String> currentPrice = GeneratedColumn<String>(
      'current_price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _peRatioTtmMeta =
      const VerificationMeta('peRatioTtm');
  @override
  late final GeneratedColumn<String> peRatioTtm = GeneratedColumn<String>(
      'pe_ratio_ttm', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalMarketCapMeta =
      const VerificationMeta('totalMarketCap');
  @override
  late final GeneratedColumn<String> totalMarketCap = GeneratedColumn<String>(
      'total_market_cap', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pbRatioMeta =
      const VerificationMeta('pbRatio');
  @override
  late final GeneratedColumn<String> pbRatio = GeneratedColumn<String>(
      'pb_ratio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dividendRatioMeta =
      const VerificationMeta('dividendRatio');
  @override
  late final GeneratedColumn<String> dividendRatio = GeneratedColumn<String>(
      'dividend_ratio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _opTopMeta = const VerificationMeta('opTop');
  @override
  late final GeneratedColumn<bool> opTop = GeneratedColumn<bool>(
      'op_top', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_top" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opCollectMeta =
      const VerificationMeta('opCollect');
  @override
  late final GeneratedColumn<bool> opCollect = GeneratedColumn<bool>(
      'op_collect', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_collect" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opDeleteMeta =
      const VerificationMeta('opDelete');
  @override
  late final GeneratedColumn<bool> opDelete = GeneratedColumn<bool>(
      'op_delete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_delete" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opBuyMeta = const VerificationMeta('opBuy');
  @override
  late final GeneratedColumn<bool> opBuy = GeneratedColumn<bool>(
      'op_buy', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_buy" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pPriceBuyMeta =
      const VerificationMeta('pPriceBuy');
  @override
  late final GeneratedColumn<String> pPriceBuy = GeneratedColumn<String>(
      'p_price_buy', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pPriceSaleMeta =
      const VerificationMeta('pPriceSale');
  @override
  late final GeneratedColumn<String> pPriceSale = GeneratedColumn<String>(
      'p_price_sale', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pPriceRemarkMeta =
      const VerificationMeta('pPriceRemark');
  @override
  late final GeneratedColumn<String> pPriceRemark = GeneratedColumn<String>(
      'p_price_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pMarketCapBuyMeta =
      const VerificationMeta('pMarketCapBuy');
  @override
  late final GeneratedColumn<String> pMarketCapBuy = GeneratedColumn<String>(
      'p_market_cap_buy', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pMarketCapSaleMeta =
      const VerificationMeta('pMarketCapSale');
  @override
  late final GeneratedColumn<String> pMarketCapSale = GeneratedColumn<String>(
      'p_market_cap_sale', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pMarketRemarkMeta =
      const VerificationMeta('pMarketRemark');
  @override
  late final GeneratedColumn<String> pMarketRemark = GeneratedColumn<String>(
      'p_market_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pPeTtmBuyMeta =
      const VerificationMeta('pPeTtmBuy');
  @override
  late final GeneratedColumn<String> pPeTtmBuy = GeneratedColumn<String>(
      'p_pe_ttm_buy', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pPeTtmSaleMeta =
      const VerificationMeta('pPeTtmSale');
  @override
  late final GeneratedColumn<String> pPeTtmSale = GeneratedColumn<String>(
      'p_pe_ttm_sale', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pPeTtmRemarkMeta =
      const VerificationMeta('pPeTtmRemark');
  @override
  late final GeneratedColumn<String> pPeTtmRemark = GeneratedColumn<String>(
      'p_pe_ttm_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pAllRemarkMeta =
      const VerificationMeta('pAllRemark');
  @override
  late final GeneratedColumn<String> pAllRemark = GeneratedColumn<String>(
      'p_all_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pEventRemarkMeta =
      const VerificationMeta('pEventRemark');
  @override
  late final GeneratedColumn<String> pEventRemark = GeneratedColumn<String>(
      'p_event_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        updateAt,
        marketType,
        name,
        code,
        currentPrice,
        peRatioTtm,
        totalMarketCap,
        pbRatio,
        dividendRatio,
        opTop,
        opCollect,
        opDelete,
        opBuy,
        pPriceBuy,
        pPriceSale,
        pPriceRemark,
        pMarketCapBuy,
        pMarketCapSale,
        pMarketRemark,
        pPeTtmBuy,
        pPeTtmSale,
        pPeTtmRemark,
        pAllRemark,
        pEventRemark
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_items';
  @override
  VerificationContext validateIntegrity(Insertable<StockItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    if (data.containsKey('market_type')) {
      context.handle(
          _marketTypeMeta,
          marketType.isAcceptableOrUnknown(
              data['market_type']!, _marketTypeMeta));
    } else if (isInserting) {
      context.missing(_marketTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('current_price')) {
      context.handle(
          _currentPriceMeta,
          currentPrice.isAcceptableOrUnknown(
              data['current_price']!, _currentPriceMeta));
    }
    if (data.containsKey('pe_ratio_ttm')) {
      context.handle(
          _peRatioTtmMeta,
          peRatioTtm.isAcceptableOrUnknown(
              data['pe_ratio_ttm']!, _peRatioTtmMeta));
    }
    if (data.containsKey('total_market_cap')) {
      context.handle(
          _totalMarketCapMeta,
          totalMarketCap.isAcceptableOrUnknown(
              data['total_market_cap']!, _totalMarketCapMeta));
    }
    if (data.containsKey('pb_ratio')) {
      context.handle(_pbRatioMeta,
          pbRatio.isAcceptableOrUnknown(data['pb_ratio']!, _pbRatioMeta));
    }
    if (data.containsKey('dividend_ratio')) {
      context.handle(
          _dividendRatioMeta,
          dividendRatio.isAcceptableOrUnknown(
              data['dividend_ratio']!, _dividendRatioMeta));
    }
    if (data.containsKey('op_top')) {
      context.handle(
          _opTopMeta, opTop.isAcceptableOrUnknown(data['op_top']!, _opTopMeta));
    }
    if (data.containsKey('op_collect')) {
      context.handle(_opCollectMeta,
          opCollect.isAcceptableOrUnknown(data['op_collect']!, _opCollectMeta));
    }
    if (data.containsKey('op_delete')) {
      context.handle(_opDeleteMeta,
          opDelete.isAcceptableOrUnknown(data['op_delete']!, _opDeleteMeta));
    }
    if (data.containsKey('op_buy')) {
      context.handle(
          _opBuyMeta, opBuy.isAcceptableOrUnknown(data['op_buy']!, _opBuyMeta));
    }
    if (data.containsKey('p_price_buy')) {
      context.handle(
          _pPriceBuyMeta,
          pPriceBuy.isAcceptableOrUnknown(
              data['p_price_buy']!, _pPriceBuyMeta));
    }
    if (data.containsKey('p_price_sale')) {
      context.handle(
          _pPriceSaleMeta,
          pPriceSale.isAcceptableOrUnknown(
              data['p_price_sale']!, _pPriceSaleMeta));
    }
    if (data.containsKey('p_price_remark')) {
      context.handle(
          _pPriceRemarkMeta,
          pPriceRemark.isAcceptableOrUnknown(
              data['p_price_remark']!, _pPriceRemarkMeta));
    }
    if (data.containsKey('p_market_cap_buy')) {
      context.handle(
          _pMarketCapBuyMeta,
          pMarketCapBuy.isAcceptableOrUnknown(
              data['p_market_cap_buy']!, _pMarketCapBuyMeta));
    }
    if (data.containsKey('p_market_cap_sale')) {
      context.handle(
          _pMarketCapSaleMeta,
          pMarketCapSale.isAcceptableOrUnknown(
              data['p_market_cap_sale']!, _pMarketCapSaleMeta));
    }
    if (data.containsKey('p_market_remark')) {
      context.handle(
          _pMarketRemarkMeta,
          pMarketRemark.isAcceptableOrUnknown(
              data['p_market_remark']!, _pMarketRemarkMeta));
    }
    if (data.containsKey('p_pe_ttm_buy')) {
      context.handle(
          _pPeTtmBuyMeta,
          pPeTtmBuy.isAcceptableOrUnknown(
              data['p_pe_ttm_buy']!, _pPeTtmBuyMeta));
    }
    if (data.containsKey('p_pe_ttm_sale')) {
      context.handle(
          _pPeTtmSaleMeta,
          pPeTtmSale.isAcceptableOrUnknown(
              data['p_pe_ttm_sale']!, _pPeTtmSaleMeta));
    }
    if (data.containsKey('p_pe_ttm_remark')) {
      context.handle(
          _pPeTtmRemarkMeta,
          pPeTtmRemark.isAcceptableOrUnknown(
              data['p_pe_ttm_remark']!, _pPeTtmRemarkMeta));
    }
    if (data.containsKey('p_all_remark')) {
      context.handle(
          _pAllRemarkMeta,
          pAllRemark.isAcceptableOrUnknown(
              data['p_all_remark']!, _pAllRemarkMeta));
    }
    if (data.containsKey('p_event_remark')) {
      context.handle(
          _pEventRemarkMeta,
          pEventRemark.isAcceptableOrUnknown(
              data['p_event_remark']!, _pEventRemarkMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at'])!,
      marketType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      currentPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_price']),
      peRatioTtm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pe_ratio_ttm']),
      totalMarketCap: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}total_market_cap']),
      pbRatio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pb_ratio']),
      dividendRatio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dividend_ratio']),
      opTop: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_top'])!,
      opCollect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_collect'])!,
      opDelete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_delete'])!,
      opBuy: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_buy'])!,
      pPriceBuy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_price_buy']),
      pPriceSale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_price_sale']),
      pPriceRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_price_remark']),
      pMarketCapBuy: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}p_market_cap_buy']),
      pMarketCapSale: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}p_market_cap_sale']),
      pMarketRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_market_remark']),
      pPeTtmBuy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_pe_ttm_buy']),
      pPeTtmSale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_pe_ttm_sale']),
      pPeTtmRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_pe_ttm_remark']),
      pAllRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_all_remark']),
      pEventRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}p_event_remark']),
    );
  }

  @override
  $StockItemsTable createAlias(String alias) {
    return $StockItemsTable(attachedDatabase, alias);
  }
}

class StockItem extends DataClass implements Insertable<StockItem> {
  final int id;
  final DateTime createdAt;
  final DateTime updateAt;
  final String marketType;
  final String name;
  final String code;
  final String? currentPrice;
  final String? peRatioTtm;
  final String? totalMarketCap;
  final String? pbRatio;
  final String? dividendRatio;
  final bool opTop;
  final bool opCollect;
  final bool opDelete;
  final bool opBuy;
  final String? pPriceBuy;
  final String? pPriceSale;
  final String? pPriceRemark;
  final String? pMarketCapBuy;
  final String? pMarketCapSale;
  final String? pMarketRemark;
  final String? pPeTtmBuy;
  final String? pPeTtmSale;
  final String? pPeTtmRemark;
  final String? pAllRemark;
  final String? pEventRemark;
  const StockItem(
      {required this.id,
      required this.createdAt,
      required this.updateAt,
      required this.marketType,
      required this.name,
      required this.code,
      this.currentPrice,
      this.peRatioTtm,
      this.totalMarketCap,
      this.pbRatio,
      this.dividendRatio,
      required this.opTop,
      required this.opCollect,
      required this.opDelete,
      required this.opBuy,
      this.pPriceBuy,
      this.pPriceSale,
      this.pPriceRemark,
      this.pMarketCapBuy,
      this.pMarketCapSale,
      this.pMarketRemark,
      this.pPeTtmBuy,
      this.pPeTtmSale,
      this.pPeTtmRemark,
      this.pAllRemark,
      this.pEventRemark});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['update_at'] = Variable<DateTime>(updateAt);
    map['market_type'] = Variable<String>(marketType);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || currentPrice != null) {
      map['current_price'] = Variable<String>(currentPrice);
    }
    if (!nullToAbsent || peRatioTtm != null) {
      map['pe_ratio_ttm'] = Variable<String>(peRatioTtm);
    }
    if (!nullToAbsent || totalMarketCap != null) {
      map['total_market_cap'] = Variable<String>(totalMarketCap);
    }
    if (!nullToAbsent || pbRatio != null) {
      map['pb_ratio'] = Variable<String>(pbRatio);
    }
    if (!nullToAbsent || dividendRatio != null) {
      map['dividend_ratio'] = Variable<String>(dividendRatio);
    }
    map['op_top'] = Variable<bool>(opTop);
    map['op_collect'] = Variable<bool>(opCollect);
    map['op_delete'] = Variable<bool>(opDelete);
    map['op_buy'] = Variable<bool>(opBuy);
    if (!nullToAbsent || pPriceBuy != null) {
      map['p_price_buy'] = Variable<String>(pPriceBuy);
    }
    if (!nullToAbsent || pPriceSale != null) {
      map['p_price_sale'] = Variable<String>(pPriceSale);
    }
    if (!nullToAbsent || pPriceRemark != null) {
      map['p_price_remark'] = Variable<String>(pPriceRemark);
    }
    if (!nullToAbsent || pMarketCapBuy != null) {
      map['p_market_cap_buy'] = Variable<String>(pMarketCapBuy);
    }
    if (!nullToAbsent || pMarketCapSale != null) {
      map['p_market_cap_sale'] = Variable<String>(pMarketCapSale);
    }
    if (!nullToAbsent || pMarketRemark != null) {
      map['p_market_remark'] = Variable<String>(pMarketRemark);
    }
    if (!nullToAbsent || pPeTtmBuy != null) {
      map['p_pe_ttm_buy'] = Variable<String>(pPeTtmBuy);
    }
    if (!nullToAbsent || pPeTtmSale != null) {
      map['p_pe_ttm_sale'] = Variable<String>(pPeTtmSale);
    }
    if (!nullToAbsent || pPeTtmRemark != null) {
      map['p_pe_ttm_remark'] = Variable<String>(pPeTtmRemark);
    }
    if (!nullToAbsent || pAllRemark != null) {
      map['p_all_remark'] = Variable<String>(pAllRemark);
    }
    if (!nullToAbsent || pEventRemark != null) {
      map['p_event_remark'] = Variable<String>(pEventRemark);
    }
    return map;
  }

  StockItemsCompanion toCompanion(bool nullToAbsent) {
    return StockItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updateAt: Value(updateAt),
      marketType: Value(marketType),
      name: Value(name),
      code: Value(code),
      currentPrice: currentPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPrice),
      peRatioTtm: peRatioTtm == null && nullToAbsent
          ? const Value.absent()
          : Value(peRatioTtm),
      totalMarketCap: totalMarketCap == null && nullToAbsent
          ? const Value.absent()
          : Value(totalMarketCap),
      pbRatio: pbRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(pbRatio),
      dividendRatio: dividendRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(dividendRatio),
      opTop: Value(opTop),
      opCollect: Value(opCollect),
      opDelete: Value(opDelete),
      opBuy: Value(opBuy),
      pPriceBuy: pPriceBuy == null && nullToAbsent
          ? const Value.absent()
          : Value(pPriceBuy),
      pPriceSale: pPriceSale == null && nullToAbsent
          ? const Value.absent()
          : Value(pPriceSale),
      pPriceRemark: pPriceRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(pPriceRemark),
      pMarketCapBuy: pMarketCapBuy == null && nullToAbsent
          ? const Value.absent()
          : Value(pMarketCapBuy),
      pMarketCapSale: pMarketCapSale == null && nullToAbsent
          ? const Value.absent()
          : Value(pMarketCapSale),
      pMarketRemark: pMarketRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(pMarketRemark),
      pPeTtmBuy: pPeTtmBuy == null && nullToAbsent
          ? const Value.absent()
          : Value(pPeTtmBuy),
      pPeTtmSale: pPeTtmSale == null && nullToAbsent
          ? const Value.absent()
          : Value(pPeTtmSale),
      pPeTtmRemark: pPeTtmRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(pPeTtmRemark),
      pAllRemark: pAllRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(pAllRemark),
      pEventRemark: pEventRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(pEventRemark),
    );
  }

  factory StockItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockItem(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updateAt: serializer.fromJson<DateTime>(json['updateAt']),
      marketType: serializer.fromJson<String>(json['marketType']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      currentPrice: serializer.fromJson<String?>(json['currentPrice']),
      peRatioTtm: serializer.fromJson<String?>(json['peRatioTtm']),
      totalMarketCap: serializer.fromJson<String?>(json['totalMarketCap']),
      pbRatio: serializer.fromJson<String?>(json['pbRatio']),
      dividendRatio: serializer.fromJson<String?>(json['dividendRatio']),
      opTop: serializer.fromJson<bool>(json['opTop']),
      opCollect: serializer.fromJson<bool>(json['opCollect']),
      opDelete: serializer.fromJson<bool>(json['opDelete']),
      opBuy: serializer.fromJson<bool>(json['opBuy']),
      pPriceBuy: serializer.fromJson<String?>(json['pPriceBuy']),
      pPriceSale: serializer.fromJson<String?>(json['pPriceSale']),
      pPriceRemark: serializer.fromJson<String?>(json['pPriceRemark']),
      pMarketCapBuy: serializer.fromJson<String?>(json['pMarketCapBuy']),
      pMarketCapSale: serializer.fromJson<String?>(json['pMarketCapSale']),
      pMarketRemark: serializer.fromJson<String?>(json['pMarketRemark']),
      pPeTtmBuy: serializer.fromJson<String?>(json['pPeTtmBuy']),
      pPeTtmSale: serializer.fromJson<String?>(json['pPeTtmSale']),
      pPeTtmRemark: serializer.fromJson<String?>(json['pPeTtmRemark']),
      pAllRemark: serializer.fromJson<String?>(json['pAllRemark']),
      pEventRemark: serializer.fromJson<String?>(json['pEventRemark']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updateAt': serializer.toJson<DateTime>(updateAt),
      'marketType': serializer.toJson<String>(marketType),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'currentPrice': serializer.toJson<String?>(currentPrice),
      'peRatioTtm': serializer.toJson<String?>(peRatioTtm),
      'totalMarketCap': serializer.toJson<String?>(totalMarketCap),
      'pbRatio': serializer.toJson<String?>(pbRatio),
      'dividendRatio': serializer.toJson<String?>(dividendRatio),
      'opTop': serializer.toJson<bool>(opTop),
      'opCollect': serializer.toJson<bool>(opCollect),
      'opDelete': serializer.toJson<bool>(opDelete),
      'opBuy': serializer.toJson<bool>(opBuy),
      'pPriceBuy': serializer.toJson<String?>(pPriceBuy),
      'pPriceSale': serializer.toJson<String?>(pPriceSale),
      'pPriceRemark': serializer.toJson<String?>(pPriceRemark),
      'pMarketCapBuy': serializer.toJson<String?>(pMarketCapBuy),
      'pMarketCapSale': serializer.toJson<String?>(pMarketCapSale),
      'pMarketRemark': serializer.toJson<String?>(pMarketRemark),
      'pPeTtmBuy': serializer.toJson<String?>(pPeTtmBuy),
      'pPeTtmSale': serializer.toJson<String?>(pPeTtmSale),
      'pPeTtmRemark': serializer.toJson<String?>(pPeTtmRemark),
      'pAllRemark': serializer.toJson<String?>(pAllRemark),
      'pEventRemark': serializer.toJson<String?>(pEventRemark),
    };
  }

  StockItem copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updateAt,
          String? marketType,
          String? name,
          String? code,
          Value<String?> currentPrice = const Value.absent(),
          Value<String?> peRatioTtm = const Value.absent(),
          Value<String?> totalMarketCap = const Value.absent(),
          Value<String?> pbRatio = const Value.absent(),
          Value<String?> dividendRatio = const Value.absent(),
          bool? opTop,
          bool? opCollect,
          bool? opDelete,
          bool? opBuy,
          Value<String?> pPriceBuy = const Value.absent(),
          Value<String?> pPriceSale = const Value.absent(),
          Value<String?> pPriceRemark = const Value.absent(),
          Value<String?> pMarketCapBuy = const Value.absent(),
          Value<String?> pMarketCapSale = const Value.absent(),
          Value<String?> pMarketRemark = const Value.absent(),
          Value<String?> pPeTtmBuy = const Value.absent(),
          Value<String?> pPeTtmSale = const Value.absent(),
          Value<String?> pPeTtmRemark = const Value.absent(),
          Value<String?> pAllRemark = const Value.absent(),
          Value<String?> pEventRemark = const Value.absent()}) =>
      StockItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updateAt: updateAt ?? this.updateAt,
        marketType: marketType ?? this.marketType,
        name: name ?? this.name,
        code: code ?? this.code,
        currentPrice:
            currentPrice.present ? currentPrice.value : this.currentPrice,
        peRatioTtm: peRatioTtm.present ? peRatioTtm.value : this.peRatioTtm,
        totalMarketCap:
            totalMarketCap.present ? totalMarketCap.value : this.totalMarketCap,
        pbRatio: pbRatio.present ? pbRatio.value : this.pbRatio,
        dividendRatio:
            dividendRatio.present ? dividendRatio.value : this.dividendRatio,
        opTop: opTop ?? this.opTop,
        opCollect: opCollect ?? this.opCollect,
        opDelete: opDelete ?? this.opDelete,
        opBuy: opBuy ?? this.opBuy,
        pPriceBuy: pPriceBuy.present ? pPriceBuy.value : this.pPriceBuy,
        pPriceSale: pPriceSale.present ? pPriceSale.value : this.pPriceSale,
        pPriceRemark:
            pPriceRemark.present ? pPriceRemark.value : this.pPriceRemark,
        pMarketCapBuy:
            pMarketCapBuy.present ? pMarketCapBuy.value : this.pMarketCapBuy,
        pMarketCapSale:
            pMarketCapSale.present ? pMarketCapSale.value : this.pMarketCapSale,
        pMarketRemark:
            pMarketRemark.present ? pMarketRemark.value : this.pMarketRemark,
        pPeTtmBuy: pPeTtmBuy.present ? pPeTtmBuy.value : this.pPeTtmBuy,
        pPeTtmSale: pPeTtmSale.present ? pPeTtmSale.value : this.pPeTtmSale,
        pPeTtmRemark:
            pPeTtmRemark.present ? pPeTtmRemark.value : this.pPeTtmRemark,
        pAllRemark: pAllRemark.present ? pAllRemark.value : this.pAllRemark,
        pEventRemark:
            pEventRemark.present ? pEventRemark.value : this.pEventRemark,
      );
  StockItem copyWithCompanion(StockItemsCompanion data) {
    return StockItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      marketType:
          data.marketType.present ? data.marketType.value : this.marketType,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      peRatioTtm:
          data.peRatioTtm.present ? data.peRatioTtm.value : this.peRatioTtm,
      totalMarketCap: data.totalMarketCap.present
          ? data.totalMarketCap.value
          : this.totalMarketCap,
      pbRatio: data.pbRatio.present ? data.pbRatio.value : this.pbRatio,
      dividendRatio: data.dividendRatio.present
          ? data.dividendRatio.value
          : this.dividendRatio,
      opTop: data.opTop.present ? data.opTop.value : this.opTop,
      opCollect: data.opCollect.present ? data.opCollect.value : this.opCollect,
      opDelete: data.opDelete.present ? data.opDelete.value : this.opDelete,
      opBuy: data.opBuy.present ? data.opBuy.value : this.opBuy,
      pPriceBuy: data.pPriceBuy.present ? data.pPriceBuy.value : this.pPriceBuy,
      pPriceSale:
          data.pPriceSale.present ? data.pPriceSale.value : this.pPriceSale,
      pPriceRemark: data.pPriceRemark.present
          ? data.pPriceRemark.value
          : this.pPriceRemark,
      pMarketCapBuy: data.pMarketCapBuy.present
          ? data.pMarketCapBuy.value
          : this.pMarketCapBuy,
      pMarketCapSale: data.pMarketCapSale.present
          ? data.pMarketCapSale.value
          : this.pMarketCapSale,
      pMarketRemark: data.pMarketRemark.present
          ? data.pMarketRemark.value
          : this.pMarketRemark,
      pPeTtmBuy: data.pPeTtmBuy.present ? data.pPeTtmBuy.value : this.pPeTtmBuy,
      pPeTtmSale:
          data.pPeTtmSale.present ? data.pPeTtmSale.value : this.pPeTtmSale,
      pPeTtmRemark: data.pPeTtmRemark.present
          ? data.pPeTtmRemark.value
          : this.pPeTtmRemark,
      pAllRemark:
          data.pAllRemark.present ? data.pAllRemark.value : this.pAllRemark,
      pEventRemark: data.pEventRemark.present
          ? data.pEventRemark.value
          : this.pEventRemark,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('marketType: $marketType, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('peRatioTtm: $peRatioTtm, ')
          ..write('totalMarketCap: $totalMarketCap, ')
          ..write('pbRatio: $pbRatio, ')
          ..write('dividendRatio: $dividendRatio, ')
          ..write('opTop: $opTop, ')
          ..write('opCollect: $opCollect, ')
          ..write('opDelete: $opDelete, ')
          ..write('opBuy: $opBuy, ')
          ..write('pPriceBuy: $pPriceBuy, ')
          ..write('pPriceSale: $pPriceSale, ')
          ..write('pPriceRemark: $pPriceRemark, ')
          ..write('pMarketCapBuy: $pMarketCapBuy, ')
          ..write('pMarketCapSale: $pMarketCapSale, ')
          ..write('pMarketRemark: $pMarketRemark, ')
          ..write('pPeTtmBuy: $pPeTtmBuy, ')
          ..write('pPeTtmSale: $pPeTtmSale, ')
          ..write('pPeTtmRemark: $pPeTtmRemark, ')
          ..write('pAllRemark: $pAllRemark, ')
          ..write('pEventRemark: $pEventRemark')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        createdAt,
        updateAt,
        marketType,
        name,
        code,
        currentPrice,
        peRatioTtm,
        totalMarketCap,
        pbRatio,
        dividendRatio,
        opTop,
        opCollect,
        opDelete,
        opBuy,
        pPriceBuy,
        pPriceSale,
        pPriceRemark,
        pMarketCapBuy,
        pMarketCapSale,
        pMarketRemark,
        pPeTtmBuy,
        pPeTtmSale,
        pPeTtmRemark,
        pAllRemark,
        pEventRemark
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updateAt == this.updateAt &&
          other.marketType == this.marketType &&
          other.name == this.name &&
          other.code == this.code &&
          other.currentPrice == this.currentPrice &&
          other.peRatioTtm == this.peRatioTtm &&
          other.totalMarketCap == this.totalMarketCap &&
          other.pbRatio == this.pbRatio &&
          other.dividendRatio == this.dividendRatio &&
          other.opTop == this.opTop &&
          other.opCollect == this.opCollect &&
          other.opDelete == this.opDelete &&
          other.opBuy == this.opBuy &&
          other.pPriceBuy == this.pPriceBuy &&
          other.pPriceSale == this.pPriceSale &&
          other.pPriceRemark == this.pPriceRemark &&
          other.pMarketCapBuy == this.pMarketCapBuy &&
          other.pMarketCapSale == this.pMarketCapSale &&
          other.pMarketRemark == this.pMarketRemark &&
          other.pPeTtmBuy == this.pPeTtmBuy &&
          other.pPeTtmSale == this.pPeTtmSale &&
          other.pPeTtmRemark == this.pPeTtmRemark &&
          other.pAllRemark == this.pAllRemark &&
          other.pEventRemark == this.pEventRemark);
}

class StockItemsCompanion extends UpdateCompanion<StockItem> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updateAt;
  final Value<String> marketType;
  final Value<String> name;
  final Value<String> code;
  final Value<String?> currentPrice;
  final Value<String?> peRatioTtm;
  final Value<String?> totalMarketCap;
  final Value<String?> pbRatio;
  final Value<String?> dividendRatio;
  final Value<bool> opTop;
  final Value<bool> opCollect;
  final Value<bool> opDelete;
  final Value<bool> opBuy;
  final Value<String?> pPriceBuy;
  final Value<String?> pPriceSale;
  final Value<String?> pPriceRemark;
  final Value<String?> pMarketCapBuy;
  final Value<String?> pMarketCapSale;
  final Value<String?> pMarketRemark;
  final Value<String?> pPeTtmBuy;
  final Value<String?> pPeTtmSale;
  final Value<String?> pPeTtmRemark;
  final Value<String?> pAllRemark;
  final Value<String?> pEventRemark;
  const StockItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.marketType = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.peRatioTtm = const Value.absent(),
    this.totalMarketCap = const Value.absent(),
    this.pbRatio = const Value.absent(),
    this.dividendRatio = const Value.absent(),
    this.opTop = const Value.absent(),
    this.opCollect = const Value.absent(),
    this.opDelete = const Value.absent(),
    this.opBuy = const Value.absent(),
    this.pPriceBuy = const Value.absent(),
    this.pPriceSale = const Value.absent(),
    this.pPriceRemark = const Value.absent(),
    this.pMarketCapBuy = const Value.absent(),
    this.pMarketCapSale = const Value.absent(),
    this.pMarketRemark = const Value.absent(),
    this.pPeTtmBuy = const Value.absent(),
    this.pPeTtmSale = const Value.absent(),
    this.pPeTtmRemark = const Value.absent(),
    this.pAllRemark = const Value.absent(),
    this.pEventRemark = const Value.absent(),
  });
  StockItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    required String marketType,
    required String name,
    required String code,
    this.currentPrice = const Value.absent(),
    this.peRatioTtm = const Value.absent(),
    this.totalMarketCap = const Value.absent(),
    this.pbRatio = const Value.absent(),
    this.dividendRatio = const Value.absent(),
    this.opTop = const Value.absent(),
    this.opCollect = const Value.absent(),
    this.opDelete = const Value.absent(),
    this.opBuy = const Value.absent(),
    this.pPriceBuy = const Value.absent(),
    this.pPriceSale = const Value.absent(),
    this.pPriceRemark = const Value.absent(),
    this.pMarketCapBuy = const Value.absent(),
    this.pMarketCapSale = const Value.absent(),
    this.pMarketRemark = const Value.absent(),
    this.pPeTtmBuy = const Value.absent(),
    this.pPeTtmSale = const Value.absent(),
    this.pPeTtmRemark = const Value.absent(),
    this.pAllRemark = const Value.absent(),
    this.pEventRemark = const Value.absent(),
  })  : marketType = Value(marketType),
        name = Value(name),
        code = Value(code);
  static Insertable<StockItem> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updateAt,
    Expression<String>? marketType,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? currentPrice,
    Expression<String>? peRatioTtm,
    Expression<String>? totalMarketCap,
    Expression<String>? pbRatio,
    Expression<String>? dividendRatio,
    Expression<bool>? opTop,
    Expression<bool>? opCollect,
    Expression<bool>? opDelete,
    Expression<bool>? opBuy,
    Expression<String>? pPriceBuy,
    Expression<String>? pPriceSale,
    Expression<String>? pPriceRemark,
    Expression<String>? pMarketCapBuy,
    Expression<String>? pMarketCapSale,
    Expression<String>? pMarketRemark,
    Expression<String>? pPeTtmBuy,
    Expression<String>? pPeTtmSale,
    Expression<String>? pPeTtmRemark,
    Expression<String>? pAllRemark,
    Expression<String>? pEventRemark,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updateAt != null) 'update_at': updateAt,
      if (marketType != null) 'market_type': marketType,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (currentPrice != null) 'current_price': currentPrice,
      if (peRatioTtm != null) 'pe_ratio_ttm': peRatioTtm,
      if (totalMarketCap != null) 'total_market_cap': totalMarketCap,
      if (pbRatio != null) 'pb_ratio': pbRatio,
      if (dividendRatio != null) 'dividend_ratio': dividendRatio,
      if (opTop != null) 'op_top': opTop,
      if (opCollect != null) 'op_collect': opCollect,
      if (opDelete != null) 'op_delete': opDelete,
      if (opBuy != null) 'op_buy': opBuy,
      if (pPriceBuy != null) 'p_price_buy': pPriceBuy,
      if (pPriceSale != null) 'p_price_sale': pPriceSale,
      if (pPriceRemark != null) 'p_price_remark': pPriceRemark,
      if (pMarketCapBuy != null) 'p_market_cap_buy': pMarketCapBuy,
      if (pMarketCapSale != null) 'p_market_cap_sale': pMarketCapSale,
      if (pMarketRemark != null) 'p_market_remark': pMarketRemark,
      if (pPeTtmBuy != null) 'p_pe_ttm_buy': pPeTtmBuy,
      if (pPeTtmSale != null) 'p_pe_ttm_sale': pPeTtmSale,
      if (pPeTtmRemark != null) 'p_pe_ttm_remark': pPeTtmRemark,
      if (pAllRemark != null) 'p_all_remark': pAllRemark,
      if (pEventRemark != null) 'p_event_remark': pEventRemark,
    });
  }

  StockItemsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updateAt,
      Value<String>? marketType,
      Value<String>? name,
      Value<String>? code,
      Value<String?>? currentPrice,
      Value<String?>? peRatioTtm,
      Value<String?>? totalMarketCap,
      Value<String?>? pbRatio,
      Value<String?>? dividendRatio,
      Value<bool>? opTop,
      Value<bool>? opCollect,
      Value<bool>? opDelete,
      Value<bool>? opBuy,
      Value<String?>? pPriceBuy,
      Value<String?>? pPriceSale,
      Value<String?>? pPriceRemark,
      Value<String?>? pMarketCapBuy,
      Value<String?>? pMarketCapSale,
      Value<String?>? pMarketRemark,
      Value<String?>? pPeTtmBuy,
      Value<String?>? pPeTtmSale,
      Value<String?>? pPeTtmRemark,
      Value<String?>? pAllRemark,
      Value<String?>? pEventRemark}) {
    return StockItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      marketType: marketType ?? this.marketType,
      name: name ?? this.name,
      code: code ?? this.code,
      currentPrice: currentPrice ?? this.currentPrice,
      peRatioTtm: peRatioTtm ?? this.peRatioTtm,
      totalMarketCap: totalMarketCap ?? this.totalMarketCap,
      pbRatio: pbRatio ?? this.pbRatio,
      dividendRatio: dividendRatio ?? this.dividendRatio,
      opTop: opTop ?? this.opTop,
      opCollect: opCollect ?? this.opCollect,
      opDelete: opDelete ?? this.opDelete,
      opBuy: opBuy ?? this.opBuy,
      pPriceBuy: pPriceBuy ?? this.pPriceBuy,
      pPriceSale: pPriceSale ?? this.pPriceSale,
      pPriceRemark: pPriceRemark ?? this.pPriceRemark,
      pMarketCapBuy: pMarketCapBuy ?? this.pMarketCapBuy,
      pMarketCapSale: pMarketCapSale ?? this.pMarketCapSale,
      pMarketRemark: pMarketRemark ?? this.pMarketRemark,
      pPeTtmBuy: pPeTtmBuy ?? this.pPeTtmBuy,
      pPeTtmSale: pPeTtmSale ?? this.pPeTtmSale,
      pPeTtmRemark: pPeTtmRemark ?? this.pPeTtmRemark,
      pAllRemark: pAllRemark ?? this.pAllRemark,
      pEventRemark: pEventRemark ?? this.pEventRemark,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    if (marketType.present) {
      map['market_type'] = Variable<String>(marketType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<String>(currentPrice.value);
    }
    if (peRatioTtm.present) {
      map['pe_ratio_ttm'] = Variable<String>(peRatioTtm.value);
    }
    if (totalMarketCap.present) {
      map['total_market_cap'] = Variable<String>(totalMarketCap.value);
    }
    if (pbRatio.present) {
      map['pb_ratio'] = Variable<String>(pbRatio.value);
    }
    if (dividendRatio.present) {
      map['dividend_ratio'] = Variable<String>(dividendRatio.value);
    }
    if (opTop.present) {
      map['op_top'] = Variable<bool>(opTop.value);
    }
    if (opCollect.present) {
      map['op_collect'] = Variable<bool>(opCollect.value);
    }
    if (opDelete.present) {
      map['op_delete'] = Variable<bool>(opDelete.value);
    }
    if (opBuy.present) {
      map['op_buy'] = Variable<bool>(opBuy.value);
    }
    if (pPriceBuy.present) {
      map['p_price_buy'] = Variable<String>(pPriceBuy.value);
    }
    if (pPriceSale.present) {
      map['p_price_sale'] = Variable<String>(pPriceSale.value);
    }
    if (pPriceRemark.present) {
      map['p_price_remark'] = Variable<String>(pPriceRemark.value);
    }
    if (pMarketCapBuy.present) {
      map['p_market_cap_buy'] = Variable<String>(pMarketCapBuy.value);
    }
    if (pMarketCapSale.present) {
      map['p_market_cap_sale'] = Variable<String>(pMarketCapSale.value);
    }
    if (pMarketRemark.present) {
      map['p_market_remark'] = Variable<String>(pMarketRemark.value);
    }
    if (pPeTtmBuy.present) {
      map['p_pe_ttm_buy'] = Variable<String>(pPeTtmBuy.value);
    }
    if (pPeTtmSale.present) {
      map['p_pe_ttm_sale'] = Variable<String>(pPeTtmSale.value);
    }
    if (pPeTtmRemark.present) {
      map['p_pe_ttm_remark'] = Variable<String>(pPeTtmRemark.value);
    }
    if (pAllRemark.present) {
      map['p_all_remark'] = Variable<String>(pAllRemark.value);
    }
    if (pEventRemark.present) {
      map['p_event_remark'] = Variable<String>(pEventRemark.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('marketType: $marketType, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('peRatioTtm: $peRatioTtm, ')
          ..write('totalMarketCap: $totalMarketCap, ')
          ..write('pbRatio: $pbRatio, ')
          ..write('dividendRatio: $dividendRatio, ')
          ..write('opTop: $opTop, ')
          ..write('opCollect: $opCollect, ')
          ..write('opDelete: $opDelete, ')
          ..write('opBuy: $opBuy, ')
          ..write('pPriceBuy: $pPriceBuy, ')
          ..write('pPriceSale: $pPriceSale, ')
          ..write('pPriceRemark: $pPriceRemark, ')
          ..write('pMarketCapBuy: $pMarketCapBuy, ')
          ..write('pMarketCapSale: $pMarketCapSale, ')
          ..write('pMarketRemark: $pMarketRemark, ')
          ..write('pPeTtmBuy: $pPeTtmBuy, ')
          ..write('pPeTtmSale: $pPeTtmSale, ')
          ..write('pPeTtmRemark: $pPeTtmRemark, ')
          ..write('pAllRemark: $pAllRemark, ')
          ..write('pEventRemark: $pEventRemark')
          ..write(')'))
        .toString();
  }
}

class $NoteItemsTable extends NoteItems
    with TableInfo<$NoteItemsTable, NoteItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _opTopMeta = const VerificationMeta('opTop');
  @override
  late final GeneratedColumn<bool> opTop = GeneratedColumn<bool>(
      'op_top', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_top" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opCollectMeta =
      const VerificationMeta('opCollect');
  @override
  late final GeneratedColumn<bool> opCollect = GeneratedColumn<bool>(
      'op_collect', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_collect" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _opDeleteMeta =
      const VerificationMeta('opDelete');
  @override
  late final GeneratedColumn<bool> opDelete = GeneratedColumn<bool>(
      'op_delete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("op_delete" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updateAt, title, content, opTop, opCollect, opDelete];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_items';
  @override
  VerificationContext validateIntegrity(Insertable<NoteItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('op_top')) {
      context.handle(
          _opTopMeta, opTop.isAcceptableOrUnknown(data['op_top']!, _opTopMeta));
    }
    if (data.containsKey('op_collect')) {
      context.handle(_opCollectMeta,
          opCollect.isAcceptableOrUnknown(data['op_collect']!, _opCollectMeta));
    }
    if (data.containsKey('op_delete')) {
      context.handle(_opDeleteMeta,
          opDelete.isAcceptableOrUnknown(data['op_delete']!, _opDeleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      opTop: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_top'])!,
      opCollect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_collect'])!,
      opDelete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}op_delete'])!,
    );
  }

  @override
  $NoteItemsTable createAlias(String alias) {
    return $NoteItemsTable(attachedDatabase, alias);
  }
}

class NoteItem extends DataClass implements Insertable<NoteItem> {
  final int id;
  final DateTime createdAt;
  final DateTime updateAt;
  final String title;
  final String? content;
  final bool opTop;
  final bool opCollect;
  final bool opDelete;
  const NoteItem(
      {required this.id,
      required this.createdAt,
      required this.updateAt,
      required this.title,
      this.content,
      required this.opTop,
      required this.opCollect,
      required this.opDelete});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['update_at'] = Variable<DateTime>(updateAt);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['op_top'] = Variable<bool>(opTop);
    map['op_collect'] = Variable<bool>(opCollect);
    map['op_delete'] = Variable<bool>(opDelete);
    return map;
  }

  NoteItemsCompanion toCompanion(bool nullToAbsent) {
    return NoteItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updateAt: Value(updateAt),
      title: Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      opTop: Value(opTop),
      opCollect: Value(opCollect),
      opDelete: Value(opDelete),
    );
  }

  factory NoteItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteItem(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updateAt: serializer.fromJson<DateTime>(json['updateAt']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      opTop: serializer.fromJson<bool>(json['opTop']),
      opCollect: serializer.fromJson<bool>(json['opCollect']),
      opDelete: serializer.fromJson<bool>(json['opDelete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updateAt': serializer.toJson<DateTime>(updateAt),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String?>(content),
      'opTop': serializer.toJson<bool>(opTop),
      'opCollect': serializer.toJson<bool>(opCollect),
      'opDelete': serializer.toJson<bool>(opDelete),
    };
  }

  NoteItem copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updateAt,
          String? title,
          Value<String?> content = const Value.absent(),
          bool? opTop,
          bool? opCollect,
          bool? opDelete}) =>
      NoteItem(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updateAt: updateAt ?? this.updateAt,
        title: title ?? this.title,
        content: content.present ? content.value : this.content,
        opTop: opTop ?? this.opTop,
        opCollect: opCollect ?? this.opCollect,
        opDelete: opDelete ?? this.opDelete,
      );
  NoteItem copyWithCompanion(NoteItemsCompanion data) {
    return NoteItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      opTop: data.opTop.present ? data.opTop.value : this.opTop,
      opCollect: data.opCollect.present ? data.opCollect.value : this.opCollect,
      opDelete: data.opDelete.present ? data.opDelete.value : this.opDelete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('opTop: $opTop, ')
          ..write('opCollect: $opCollect, ')
          ..write('opDelete: $opDelete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createdAt, updateAt, title, content, opTop, opCollect, opDelete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updateAt == this.updateAt &&
          other.title == this.title &&
          other.content == this.content &&
          other.opTop == this.opTop &&
          other.opCollect == this.opCollect &&
          other.opDelete == this.opDelete);
}

class NoteItemsCompanion extends UpdateCompanion<NoteItem> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updateAt;
  final Value<String> title;
  final Value<String?> content;
  final Value<bool> opTop;
  final Value<bool> opCollect;
  final Value<bool> opDelete;
  const NoteItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.opTop = const Value.absent(),
    this.opCollect = const Value.absent(),
    this.opDelete = const Value.absent(),
  });
  NoteItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    required String title,
    this.content = const Value.absent(),
    this.opTop = const Value.absent(),
    this.opCollect = const Value.absent(),
    this.opDelete = const Value.absent(),
  }) : title = Value(title);
  static Insertable<NoteItem> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updateAt,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? opTop,
    Expression<bool>? opCollect,
    Expression<bool>? opDelete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updateAt != null) 'update_at': updateAt,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (opTop != null) 'op_top': opTop,
      if (opCollect != null) 'op_collect': opCollect,
      if (opDelete != null) 'op_delete': opDelete,
    });
  }

  NoteItemsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updateAt,
      Value<String>? title,
      Value<String?>? content,
      Value<bool>? opTop,
      Value<bool>? opCollect,
      Value<bool>? opDelete}) {
    return NoteItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      title: title ?? this.title,
      content: content ?? this.content,
      opTop: opTop ?? this.opTop,
      opCollect: opCollect ?? this.opCollect,
      opDelete: opDelete ?? this.opDelete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (opTop.present) {
      map['op_top'] = Variable<bool>(opTop.value);
    }
    if (opCollect.present) {
      map['op_collect'] = Variable<bool>(opCollect.value);
    }
    if (opDelete.present) {
      map['op_delete'] = Variable<bool>(opDelete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('opTop: $opTop, ')
          ..write('opCollect: $opCollect, ')
          ..write('opDelete: $opDelete')
          ..write(')'))
        .toString();
  }
}

class $StockItemTagsTable extends StockItemTags
    with TableInfo<$StockItemTagsTable, StockItemTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockItemTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_item_tags';
  @override
  VerificationContext validateIntegrity(Insertable<StockItemTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockItemTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockItemTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $StockItemTagsTable createAlias(String alias) {
    return $StockItemTagsTable(attachedDatabase, alias);
  }
}

class StockItemTag extends DataClass implements Insertable<StockItemTag> {
  final int id;
  final String name;
  const StockItemTag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  StockItemTagsCompanion toCompanion(bool nullToAbsent) {
    return StockItemTagsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory StockItemTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockItemTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  StockItemTag copyWith({int? id, String? name}) => StockItemTag(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  StockItemTag copyWithCompanion(StockItemTagsCompanion data) {
    return StockItemTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockItemTag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockItemTag && other.id == this.id && other.name == this.name);
}

class StockItemTagsCompanion extends UpdateCompanion<StockItemTag> {
  final Value<int> id;
  final Value<String> name;
  const StockItemTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  StockItemTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<StockItemTag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  StockItemTagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return StockItemTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockItemTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $StockTagsTable extends StockTags
    with TableInfo<$StockTagsTable, StockTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stockIdMeta =
      const VerificationMeta('stockId');
  @override
  late final GeneratedColumn<int> stockId = GeneratedColumn<int>(
      'stock_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES stock_items (id)'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stock_item_tags (id)'));
  @override
  List<GeneratedColumn> get $columns => [stockId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_tags';
  @override
  VerificationContext validateIntegrity(Insertable<StockTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stock_id')) {
      context.handle(_stockIdMeta,
          stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta));
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stockId, tagId};
  @override
  StockTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockTag(
      stockId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $StockTagsTable createAlias(String alias) {
    return $StockTagsTable(attachedDatabase, alias);
  }
}

class StockTag extends DataClass implements Insertable<StockTag> {
  final int stockId;
  final int tagId;
  const StockTag({required this.stockId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stock_id'] = Variable<int>(stockId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  StockTagsCompanion toCompanion(bool nullToAbsent) {
    return StockTagsCompanion(
      stockId: Value(stockId),
      tagId: Value(tagId),
    );
  }

  factory StockTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockTag(
      stockId: serializer.fromJson<int>(json['stockId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stockId': serializer.toJson<int>(stockId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  StockTag copyWith({int? stockId, int? tagId}) => StockTag(
        stockId: stockId ?? this.stockId,
        tagId: tagId ?? this.tagId,
      );
  StockTag copyWithCompanion(StockTagsCompanion data) {
    return StockTag(
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockTag(')
          ..write('stockId: $stockId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stockId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockTag &&
          other.stockId == this.stockId &&
          other.tagId == this.tagId);
}

class StockTagsCompanion extends UpdateCompanion<StockTag> {
  final Value<int> stockId;
  final Value<int> tagId;
  final Value<int> rowid;
  const StockTagsCompanion({
    this.stockId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockTagsCompanion.insert({
    required int stockId,
    required int tagId,
    this.rowid = const Value.absent(),
  })  : stockId = Value(stockId),
        tagId = Value(tagId);
  static Insertable<StockTag> custom({
    Expression<int>? stockId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stockId != null) 'stock_id': stockId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockTagsCompanion copyWith(
      {Value<int>? stockId, Value<int>? tagId, Value<int>? rowid}) {
    return StockTagsCompanion(
      stockId: stockId ?? this.stockId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stockId.present) {
      map['stock_id'] = Variable<int>(stockId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockTagsCompanion(')
          ..write('stockId: $stockId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StockItemsTable stockItems = $StockItemsTable(this);
  late final $NoteItemsTable noteItems = $NoteItemsTable(this);
  late final $StockItemTagsTable stockItemTags = $StockItemTagsTable(this);
  late final $StockTagsTable stockTags = $StockTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [stockItems, noteItems, stockItemTags, stockTags];
}

typedef $$StockItemsTableCreateCompanionBuilder = StockItemsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  required String marketType,
  required String name,
  required String code,
  Value<String?> currentPrice,
  Value<String?> peRatioTtm,
  Value<String?> totalMarketCap,
  Value<String?> pbRatio,
  Value<String?> dividendRatio,
  Value<bool> opTop,
  Value<bool> opCollect,
  Value<bool> opDelete,
  Value<bool> opBuy,
  Value<String?> pPriceBuy,
  Value<String?> pPriceSale,
  Value<String?> pPriceRemark,
  Value<String?> pMarketCapBuy,
  Value<String?> pMarketCapSale,
  Value<String?> pMarketRemark,
  Value<String?> pPeTtmBuy,
  Value<String?> pPeTtmSale,
  Value<String?> pPeTtmRemark,
  Value<String?> pAllRemark,
  Value<String?> pEventRemark,
});
typedef $$StockItemsTableUpdateCompanionBuilder = StockItemsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  Value<String> marketType,
  Value<String> name,
  Value<String> code,
  Value<String?> currentPrice,
  Value<String?> peRatioTtm,
  Value<String?> totalMarketCap,
  Value<String?> pbRatio,
  Value<String?> dividendRatio,
  Value<bool> opTop,
  Value<bool> opCollect,
  Value<bool> opDelete,
  Value<bool> opBuy,
  Value<String?> pPriceBuy,
  Value<String?> pPriceSale,
  Value<String?> pPriceRemark,
  Value<String?> pMarketCapBuy,
  Value<String?> pMarketCapSale,
  Value<String?> pMarketRemark,
  Value<String?> pPeTtmBuy,
  Value<String?> pPeTtmSale,
  Value<String?> pPeTtmRemark,
  Value<String?> pAllRemark,
  Value<String?> pEventRemark,
});

final class $$StockItemsTableReferences
    extends BaseReferences<_$AppDatabase, $StockItemsTable, StockItem> {
  $$StockItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockTagsTable, List<StockTag>>
      _stockTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockTags,
              aliasName:
                  $_aliasNameGenerator(db.stockItems.id, db.stockTags.stockId));

  $$StockTagsTableProcessedTableManager get stockTagsRefs {
    final manager = $$StockTagsTableTableManager($_db, $_db.stockTags)
        .filter((f) => f.stockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StockItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StockItemsTable> {
  $$StockItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketType => $composableBuilder(
      column: $table.marketType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get peRatioTtm => $composableBuilder(
      column: $table.peRatioTtm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalMarketCap => $composableBuilder(
      column: $table.totalMarketCap,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pbRatio => $composableBuilder(
      column: $table.pbRatio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dividendRatio => $composableBuilder(
      column: $table.dividendRatio, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opTop => $composableBuilder(
      column: $table.opTop, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opCollect => $composableBuilder(
      column: $table.opCollect, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opDelete => $composableBuilder(
      column: $table.opDelete, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opBuy => $composableBuilder(
      column: $table.opBuy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPriceBuy => $composableBuilder(
      column: $table.pPriceBuy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPriceSale => $composableBuilder(
      column: $table.pPriceSale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPriceRemark => $composableBuilder(
      column: $table.pPriceRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pMarketCapBuy => $composableBuilder(
      column: $table.pMarketCapBuy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pMarketCapSale => $composableBuilder(
      column: $table.pMarketCapSale,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pMarketRemark => $composableBuilder(
      column: $table.pMarketRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPeTtmBuy => $composableBuilder(
      column: $table.pPeTtmBuy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPeTtmSale => $composableBuilder(
      column: $table.pPeTtmSale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pPeTtmRemark => $composableBuilder(
      column: $table.pPeTtmRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pAllRemark => $composableBuilder(
      column: $table.pAllRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pEventRemark => $composableBuilder(
      column: $table.pEventRemark, builder: (column) => ColumnFilters(column));

  Expression<bool> stockTagsRefs(
      Expression<bool> Function($$StockTagsTableFilterComposer f) f) {
    final $$StockTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTags,
        getReferencedColumn: (t) => t.stockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTagsTableFilterComposer(
              $db: $db,
              $table: $db.stockTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StockItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockItemsTable> {
  $$StockItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketType => $composableBuilder(
      column: $table.marketType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentPrice => $composableBuilder(
      column: $table.currentPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get peRatioTtm => $composableBuilder(
      column: $table.peRatioTtm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalMarketCap => $composableBuilder(
      column: $table.totalMarketCap,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pbRatio => $composableBuilder(
      column: $table.pbRatio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dividendRatio => $composableBuilder(
      column: $table.dividendRatio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opTop => $composableBuilder(
      column: $table.opTop, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opCollect => $composableBuilder(
      column: $table.opCollect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opDelete => $composableBuilder(
      column: $table.opDelete, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opBuy => $composableBuilder(
      column: $table.opBuy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPriceBuy => $composableBuilder(
      column: $table.pPriceBuy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPriceSale => $composableBuilder(
      column: $table.pPriceSale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPriceRemark => $composableBuilder(
      column: $table.pPriceRemark,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pMarketCapBuy => $composableBuilder(
      column: $table.pMarketCapBuy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pMarketCapSale => $composableBuilder(
      column: $table.pMarketCapSale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pMarketRemark => $composableBuilder(
      column: $table.pMarketRemark,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPeTtmBuy => $composableBuilder(
      column: $table.pPeTtmBuy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPeTtmSale => $composableBuilder(
      column: $table.pPeTtmSale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pPeTtmRemark => $composableBuilder(
      column: $table.pPeTtmRemark,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pAllRemark => $composableBuilder(
      column: $table.pAllRemark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pEventRemark => $composableBuilder(
      column: $table.pEventRemark,
      builder: (column) => ColumnOrderings(column));
}

class $$StockItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockItemsTable> {
  $$StockItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<String> get marketType => $composableBuilder(
      column: $table.marketType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => column);

  GeneratedColumn<String> get peRatioTtm => $composableBuilder(
      column: $table.peRatioTtm, builder: (column) => column);

  GeneratedColumn<String> get totalMarketCap => $composableBuilder(
      column: $table.totalMarketCap, builder: (column) => column);

  GeneratedColumn<String> get pbRatio =>
      $composableBuilder(column: $table.pbRatio, builder: (column) => column);

  GeneratedColumn<String> get dividendRatio => $composableBuilder(
      column: $table.dividendRatio, builder: (column) => column);

  GeneratedColumn<bool> get opTop =>
      $composableBuilder(column: $table.opTop, builder: (column) => column);

  GeneratedColumn<bool> get opCollect =>
      $composableBuilder(column: $table.opCollect, builder: (column) => column);

  GeneratedColumn<bool> get opDelete =>
      $composableBuilder(column: $table.opDelete, builder: (column) => column);

  GeneratedColumn<bool> get opBuy =>
      $composableBuilder(column: $table.opBuy, builder: (column) => column);

  GeneratedColumn<String> get pPriceBuy =>
      $composableBuilder(column: $table.pPriceBuy, builder: (column) => column);

  GeneratedColumn<String> get pPriceSale => $composableBuilder(
      column: $table.pPriceSale, builder: (column) => column);

  GeneratedColumn<String> get pPriceRemark => $composableBuilder(
      column: $table.pPriceRemark, builder: (column) => column);

  GeneratedColumn<String> get pMarketCapBuy => $composableBuilder(
      column: $table.pMarketCapBuy, builder: (column) => column);

  GeneratedColumn<String> get pMarketCapSale => $composableBuilder(
      column: $table.pMarketCapSale, builder: (column) => column);

  GeneratedColumn<String> get pMarketRemark => $composableBuilder(
      column: $table.pMarketRemark, builder: (column) => column);

  GeneratedColumn<String> get pPeTtmBuy =>
      $composableBuilder(column: $table.pPeTtmBuy, builder: (column) => column);

  GeneratedColumn<String> get pPeTtmSale => $composableBuilder(
      column: $table.pPeTtmSale, builder: (column) => column);

  GeneratedColumn<String> get pPeTtmRemark => $composableBuilder(
      column: $table.pPeTtmRemark, builder: (column) => column);

  GeneratedColumn<String> get pAllRemark => $composableBuilder(
      column: $table.pAllRemark, builder: (column) => column);

  GeneratedColumn<String> get pEventRemark => $composableBuilder(
      column: $table.pEventRemark, builder: (column) => column);

  Expression<T> stockTagsRefs<T extends Object>(
      Expression<T> Function($$StockTagsTableAnnotationComposer a) f) {
    final $$StockTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTags,
        getReferencedColumn: (t) => t.stockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StockItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockItemsTable,
    StockItem,
    $$StockItemsTableFilterComposer,
    $$StockItemsTableOrderingComposer,
    $$StockItemsTableAnnotationComposer,
    $$StockItemsTableCreateCompanionBuilder,
    $$StockItemsTableUpdateCompanionBuilder,
    (StockItem, $$StockItemsTableReferences),
    StockItem,
    PrefetchHooks Function({bool stockTagsRefs})> {
  $$StockItemsTableTableManager(_$AppDatabase db, $StockItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            Value<String> marketType = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String?> currentPrice = const Value.absent(),
            Value<String?> peRatioTtm = const Value.absent(),
            Value<String?> totalMarketCap = const Value.absent(),
            Value<String?> pbRatio = const Value.absent(),
            Value<String?> dividendRatio = const Value.absent(),
            Value<bool> opTop = const Value.absent(),
            Value<bool> opCollect = const Value.absent(),
            Value<bool> opDelete = const Value.absent(),
            Value<bool> opBuy = const Value.absent(),
            Value<String?> pPriceBuy = const Value.absent(),
            Value<String?> pPriceSale = const Value.absent(),
            Value<String?> pPriceRemark = const Value.absent(),
            Value<String?> pMarketCapBuy = const Value.absent(),
            Value<String?> pMarketCapSale = const Value.absent(),
            Value<String?> pMarketRemark = const Value.absent(),
            Value<String?> pPeTtmBuy = const Value.absent(),
            Value<String?> pPeTtmSale = const Value.absent(),
            Value<String?> pPeTtmRemark = const Value.absent(),
            Value<String?> pAllRemark = const Value.absent(),
            Value<String?> pEventRemark = const Value.absent(),
          }) =>
              StockItemsCompanion(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            marketType: marketType,
            name: name,
            code: code,
            currentPrice: currentPrice,
            peRatioTtm: peRatioTtm,
            totalMarketCap: totalMarketCap,
            pbRatio: pbRatio,
            dividendRatio: dividendRatio,
            opTop: opTop,
            opCollect: opCollect,
            opDelete: opDelete,
            opBuy: opBuy,
            pPriceBuy: pPriceBuy,
            pPriceSale: pPriceSale,
            pPriceRemark: pPriceRemark,
            pMarketCapBuy: pMarketCapBuy,
            pMarketCapSale: pMarketCapSale,
            pMarketRemark: pMarketRemark,
            pPeTtmBuy: pPeTtmBuy,
            pPeTtmSale: pPeTtmSale,
            pPeTtmRemark: pPeTtmRemark,
            pAllRemark: pAllRemark,
            pEventRemark: pEventRemark,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            required String marketType,
            required String name,
            required String code,
            Value<String?> currentPrice = const Value.absent(),
            Value<String?> peRatioTtm = const Value.absent(),
            Value<String?> totalMarketCap = const Value.absent(),
            Value<String?> pbRatio = const Value.absent(),
            Value<String?> dividendRatio = const Value.absent(),
            Value<bool> opTop = const Value.absent(),
            Value<bool> opCollect = const Value.absent(),
            Value<bool> opDelete = const Value.absent(),
            Value<bool> opBuy = const Value.absent(),
            Value<String?> pPriceBuy = const Value.absent(),
            Value<String?> pPriceSale = const Value.absent(),
            Value<String?> pPriceRemark = const Value.absent(),
            Value<String?> pMarketCapBuy = const Value.absent(),
            Value<String?> pMarketCapSale = const Value.absent(),
            Value<String?> pMarketRemark = const Value.absent(),
            Value<String?> pPeTtmBuy = const Value.absent(),
            Value<String?> pPeTtmSale = const Value.absent(),
            Value<String?> pPeTtmRemark = const Value.absent(),
            Value<String?> pAllRemark = const Value.absent(),
            Value<String?> pEventRemark = const Value.absent(),
          }) =>
              StockItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            marketType: marketType,
            name: name,
            code: code,
            currentPrice: currentPrice,
            peRatioTtm: peRatioTtm,
            totalMarketCap: totalMarketCap,
            pbRatio: pbRatio,
            dividendRatio: dividendRatio,
            opTop: opTop,
            opCollect: opCollect,
            opDelete: opDelete,
            opBuy: opBuy,
            pPriceBuy: pPriceBuy,
            pPriceSale: pPriceSale,
            pPriceRemark: pPriceRemark,
            pMarketCapBuy: pMarketCapBuy,
            pMarketCapSale: pMarketCapSale,
            pMarketRemark: pMarketRemark,
            pPeTtmBuy: pPeTtmBuy,
            pPeTtmSale: pPeTtmSale,
            pPeTtmRemark: pPeTtmRemark,
            pAllRemark: pAllRemark,
            pEventRemark: pEventRemark,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({stockTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (stockTagsRefs) db.stockTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stockTagsRefs)
                    await $_getPrefetchedData<StockItem, $StockItemsTable,
                            StockTag>(
                        currentTable: table,
                        referencedTable:
                            $$StockItemsTableReferences._stockTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StockItemsTableReferences(db, table, p0)
                                .stockTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.stockId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StockItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockItemsTable,
    StockItem,
    $$StockItemsTableFilterComposer,
    $$StockItemsTableOrderingComposer,
    $$StockItemsTableAnnotationComposer,
    $$StockItemsTableCreateCompanionBuilder,
    $$StockItemsTableUpdateCompanionBuilder,
    (StockItem, $$StockItemsTableReferences),
    StockItem,
    PrefetchHooks Function({bool stockTagsRefs})>;
typedef $$NoteItemsTableCreateCompanionBuilder = NoteItemsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  required String title,
  Value<String?> content,
  Value<bool> opTop,
  Value<bool> opCollect,
  Value<bool> opDelete,
});
typedef $$NoteItemsTableUpdateCompanionBuilder = NoteItemsCompanion Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  Value<String> title,
  Value<String?> content,
  Value<bool> opTop,
  Value<bool> opCollect,
  Value<bool> opDelete,
});

class $$NoteItemsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteItemsTable> {
  $$NoteItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opTop => $composableBuilder(
      column: $table.opTop, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opCollect => $composableBuilder(
      column: $table.opCollect, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opDelete => $composableBuilder(
      column: $table.opDelete, builder: (column) => ColumnFilters(column));
}

class $$NoteItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteItemsTable> {
  $$NoteItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opTop => $composableBuilder(
      column: $table.opTop, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opCollect => $composableBuilder(
      column: $table.opCollect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opDelete => $composableBuilder(
      column: $table.opDelete, builder: (column) => ColumnOrderings(column));
}

class $$NoteItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteItemsTable> {
  $$NoteItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get opTop =>
      $composableBuilder(column: $table.opTop, builder: (column) => column);

  GeneratedColumn<bool> get opCollect =>
      $composableBuilder(column: $table.opCollect, builder: (column) => column);

  GeneratedColumn<bool> get opDelete =>
      $composableBuilder(column: $table.opDelete, builder: (column) => column);
}

class $$NoteItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteItemsTable,
    NoteItem,
    $$NoteItemsTableFilterComposer,
    $$NoteItemsTableOrderingComposer,
    $$NoteItemsTableAnnotationComposer,
    $$NoteItemsTableCreateCompanionBuilder,
    $$NoteItemsTableUpdateCompanionBuilder,
    (NoteItem, BaseReferences<_$AppDatabase, $NoteItemsTable, NoteItem>),
    NoteItem,
    PrefetchHooks Function()> {
  $$NoteItemsTableTableManager(_$AppDatabase db, $NoteItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<bool> opTop = const Value.absent(),
            Value<bool> opCollect = const Value.absent(),
            Value<bool> opDelete = const Value.absent(),
          }) =>
              NoteItemsCompanion(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            title: title,
            content: content,
            opTop: opTop,
            opCollect: opCollect,
            opDelete: opDelete,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            required String title,
            Value<String?> content = const Value.absent(),
            Value<bool> opTop = const Value.absent(),
            Value<bool> opCollect = const Value.absent(),
            Value<bool> opDelete = const Value.absent(),
          }) =>
              NoteItemsCompanion.insert(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            title: title,
            content: content,
            opTop: opTop,
            opCollect: opCollect,
            opDelete: opDelete,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NoteItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteItemsTable,
    NoteItem,
    $$NoteItemsTableFilterComposer,
    $$NoteItemsTableOrderingComposer,
    $$NoteItemsTableAnnotationComposer,
    $$NoteItemsTableCreateCompanionBuilder,
    $$NoteItemsTableUpdateCompanionBuilder,
    (NoteItem, BaseReferences<_$AppDatabase, $NoteItemsTable, NoteItem>),
    NoteItem,
    PrefetchHooks Function()>;
typedef $$StockItemTagsTableCreateCompanionBuilder = StockItemTagsCompanion
    Function({
  Value<int> id,
  required String name,
});
typedef $$StockItemTagsTableUpdateCompanionBuilder = StockItemTagsCompanion
    Function({
  Value<int> id,
  Value<String> name,
});

final class $$StockItemTagsTableReferences
    extends BaseReferences<_$AppDatabase, $StockItemTagsTable, StockItemTag> {
  $$StockItemTagsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockTagsTable, List<StockTag>>
      _stockTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.stockTags,
          aliasName:
              $_aliasNameGenerator(db.stockItemTags.id, db.stockTags.tagId));

  $$StockTagsTableProcessedTableManager get stockTagsRefs {
    final manager = $$StockTagsTableTableManager($_db, $_db.stockTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StockItemTagsTableFilterComposer
    extends Composer<_$AppDatabase, $StockItemTagsTable> {
  $$StockItemTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> stockTagsRefs(
      Expression<bool> Function($$StockTagsTableFilterComposer f) f) {
    final $$StockTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTagsTableFilterComposer(
              $db: $db,
              $table: $db.stockTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StockItemTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockItemTagsTable> {
  $$StockItemTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$StockItemTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockItemTagsTable> {
  $$StockItemTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> stockTagsRefs<T extends Object>(
      Expression<T> Function($$StockTagsTableAnnotationComposer a) f) {
    final $$StockTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StockItemTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockItemTagsTable,
    StockItemTag,
    $$StockItemTagsTableFilterComposer,
    $$StockItemTagsTableOrderingComposer,
    $$StockItemTagsTableAnnotationComposer,
    $$StockItemTagsTableCreateCompanionBuilder,
    $$StockItemTagsTableUpdateCompanionBuilder,
    (StockItemTag, $$StockItemTagsTableReferences),
    StockItemTag,
    PrefetchHooks Function({bool stockTagsRefs})> {
  $$StockItemTagsTableTableManager(_$AppDatabase db, $StockItemTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockItemTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockItemTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockItemTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              StockItemTagsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              StockItemTagsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockItemTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({stockTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (stockTagsRefs) db.stockTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stockTagsRefs)
                    await $_getPrefetchedData<StockItemTag, $StockItemTagsTable,
                            StockTag>(
                        currentTable: table,
                        referencedTable: $$StockItemTagsTableReferences
                            ._stockTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StockItemTagsTableReferences(db, table, p0)
                                .stockTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StockItemTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockItemTagsTable,
    StockItemTag,
    $$StockItemTagsTableFilterComposer,
    $$StockItemTagsTableOrderingComposer,
    $$StockItemTagsTableAnnotationComposer,
    $$StockItemTagsTableCreateCompanionBuilder,
    $$StockItemTagsTableUpdateCompanionBuilder,
    (StockItemTag, $$StockItemTagsTableReferences),
    StockItemTag,
    PrefetchHooks Function({bool stockTagsRefs})>;
typedef $$StockTagsTableCreateCompanionBuilder = StockTagsCompanion Function({
  required int stockId,
  required int tagId,
  Value<int> rowid,
});
typedef $$StockTagsTableUpdateCompanionBuilder = StockTagsCompanion Function({
  Value<int> stockId,
  Value<int> tagId,
  Value<int> rowid,
});

final class $$StockTagsTableReferences
    extends BaseReferences<_$AppDatabase, $StockTagsTable, StockTag> {
  $$StockTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StockItemsTable _stockIdTable(_$AppDatabase db) =>
      db.stockItems.createAlias(
          $_aliasNameGenerator(db.stockTags.stockId, db.stockItems.id));

  $$StockItemsTableProcessedTableManager get stockId {
    final $_column = $_itemColumn<int>('stock_id')!;

    final manager = $$StockItemsTableTableManager($_db, $_db.stockItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StockItemTagsTable _tagIdTable(_$AppDatabase db) =>
      db.stockItemTags.createAlias(
          $_aliasNameGenerator(db.stockTags.tagId, db.stockItemTags.id));

  $$StockItemTagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$StockItemTagsTableTableManager($_db, $_db.stockItemTags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockTagsTableFilterComposer
    extends Composer<_$AppDatabase, $StockTagsTable> {
  $$StockTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StockItemsTableFilterComposer get stockId {
    final $$StockItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stockId,
        referencedTable: $db.stockItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemsTableFilterComposer(
              $db: $db,
              $table: $db.stockItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StockItemTagsTableFilterComposer get tagId {
    final $$StockItemTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.stockItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemTagsTableFilterComposer(
              $db: $db,
              $table: $db.stockItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockTagsTable> {
  $$StockTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StockItemsTableOrderingComposer get stockId {
    final $$StockItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stockId,
        referencedTable: $db.stockItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemsTableOrderingComposer(
              $db: $db,
              $table: $db.stockItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StockItemTagsTableOrderingComposer get tagId {
    final $$StockItemTagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.stockItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemTagsTableOrderingComposer(
              $db: $db,
              $table: $db.stockItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockTagsTable> {
  $$StockTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StockItemsTableAnnotationComposer get stockId {
    final $$StockItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.stockId,
        referencedTable: $db.stockItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StockItemTagsTableAnnotationComposer get tagId {
    final $$StockItemTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.stockItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockItemTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockTagsTable,
    StockTag,
    $$StockTagsTableFilterComposer,
    $$StockTagsTableOrderingComposer,
    $$StockTagsTableAnnotationComposer,
    $$StockTagsTableCreateCompanionBuilder,
    $$StockTagsTableUpdateCompanionBuilder,
    (StockTag, $$StockTagsTableReferences),
    StockTag,
    PrefetchHooks Function({bool stockId, bool tagId})> {
  $$StockTagsTableTableManager(_$AppDatabase db, $StockTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> stockId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockTagsCompanion(
            stockId: stockId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int stockId,
            required int tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              StockTagsCompanion.insert(
            stockId: stockId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({stockId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (stockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.stockId,
                    referencedTable:
                        $$StockTagsTableReferences._stockIdTable(db),
                    referencedColumn:
                        $$StockTagsTableReferences._stockIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable: $$StockTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$StockTagsTableReferences._tagIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockTagsTable,
    StockTag,
    $$StockTagsTableFilterComposer,
    $$StockTagsTableOrderingComposer,
    $$StockTagsTableAnnotationComposer,
    $$StockTagsTableCreateCompanionBuilder,
    $$StockTagsTableUpdateCompanionBuilder,
    (StockTag, $$StockTagsTableReferences),
    StockTag,
    PrefetchHooks Function({bool stockId, bool tagId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StockItemsTableTableManager get stockItems =>
      $$StockItemsTableTableManager(_db, _db.stockItems);
  $$NoteItemsTableTableManager get noteItems =>
      $$NoteItemsTableTableManager(_db, _db.noteItems);
  $$StockItemTagsTableTableManager get stockItemTags =>
      $$StockItemTagsTableTableManager(_db, _db.stockItemTags);
  $$StockTagsTableTableManager get stockTags =>
      $$StockTagsTableTableManager(_db, _db.stockTags);
}
