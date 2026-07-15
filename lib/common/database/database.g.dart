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
  static const VerificationMeta _rAllRemarkMeta =
      const VerificationMeta('rAllRemark');
  @override
  late final GeneratedColumn<String> rAllRemark = GeneratedColumn<String>(
      'r_all_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rEventRemarkMeta =
      const VerificationMeta('rEventRemark');
  @override
  late final GeneratedColumn<String> rEventRemark = GeneratedColumn<String>(
      'r_event_remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rBuyPriceMeta =
      const VerificationMeta('rBuyPrice');
  @override
  late final GeneratedColumn<String> rBuyPrice = GeneratedColumn<String>(
      'r_buy_price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rHoldSharesMeta =
      const VerificationMeta('rHoldShares');
  @override
  late final GeneratedColumn<String> rHoldShares = GeneratedColumn<String>(
      'r_hold_shares', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rNoteMeta = const VerificationMeta('rNote');
  @override
  late final GeneratedColumn<String> rNote = GeneratedColumn<String>(
      'r_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cMeetUpdateAtMeta =
      const VerificationMeta('cMeetUpdateAt');
  @override
  late final GeneratedColumn<DateTime> cMeetUpdateAt =
      GeneratedColumn<DateTime>('c_meet_update_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _cNearUpdateAtMeta =
      const VerificationMeta('cNearUpdateAt');
  @override
  late final GeneratedColumn<DateTime> cNearUpdateAt =
      GeneratedColumn<DateTime>('c_near_update_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _cPriceConditionMeta =
      const VerificationMeta('cPriceCondition');
  @override
  late final GeneratedColumn<int> cPriceCondition = GeneratedColumn<int>(
      'c_price_condition', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cMarketCapConditionMeta =
      const VerificationMeta('cMarketCapCondition');
  @override
  late final GeneratedColumn<int> cMarketCapCondition = GeneratedColumn<int>(
      'c_market_cap_condition', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cPeTtmConditionMeta =
      const VerificationMeta('cPeTtmCondition');
  @override
  late final GeneratedColumn<int> cPeTtmCondition = GeneratedColumn<int>(
      'c_pe_ttm_condition', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
        rAllRemark,
        rEventRemark,
        rBuyPrice,
        rHoldShares,
        rNote,
        cMeetUpdateAt,
        cNearUpdateAt,
        cPriceCondition,
        cMarketCapCondition,
        cPeTtmCondition
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
    if (data.containsKey('r_all_remark')) {
      context.handle(
          _rAllRemarkMeta,
          rAllRemark.isAcceptableOrUnknown(
              data['r_all_remark']!, _rAllRemarkMeta));
    }
    if (data.containsKey('r_event_remark')) {
      context.handle(
          _rEventRemarkMeta,
          rEventRemark.isAcceptableOrUnknown(
              data['r_event_remark']!, _rEventRemarkMeta));
    }
    if (data.containsKey('r_buy_price')) {
      context.handle(
          _rBuyPriceMeta,
          rBuyPrice.isAcceptableOrUnknown(
              data['r_buy_price']!, _rBuyPriceMeta));
    }
    if (data.containsKey('r_hold_shares')) {
      context.handle(
          _rHoldSharesMeta,
          rHoldShares.isAcceptableOrUnknown(
              data['r_hold_shares']!, _rHoldSharesMeta));
    }
    if (data.containsKey('r_note')) {
      context.handle(
          _rNoteMeta, rNote.isAcceptableOrUnknown(data['r_note']!, _rNoteMeta));
    }
    if (data.containsKey('c_meet_update_at')) {
      context.handle(
          _cMeetUpdateAtMeta,
          cMeetUpdateAt.isAcceptableOrUnknown(
              data['c_meet_update_at']!, _cMeetUpdateAtMeta));
    }
    if (data.containsKey('c_near_update_at')) {
      context.handle(
          _cNearUpdateAtMeta,
          cNearUpdateAt.isAcceptableOrUnknown(
              data['c_near_update_at']!, _cNearUpdateAtMeta));
    }
    if (data.containsKey('c_price_condition')) {
      context.handle(
          _cPriceConditionMeta,
          cPriceCondition.isAcceptableOrUnknown(
              data['c_price_condition']!, _cPriceConditionMeta));
    }
    if (data.containsKey('c_market_cap_condition')) {
      context.handle(
          _cMarketCapConditionMeta,
          cMarketCapCondition.isAcceptableOrUnknown(
              data['c_market_cap_condition']!, _cMarketCapConditionMeta));
    }
    if (data.containsKey('c_pe_ttm_condition')) {
      context.handle(
          _cPeTtmConditionMeta,
          cPeTtmCondition.isAcceptableOrUnknown(
              data['c_pe_ttm_condition']!, _cPeTtmConditionMeta));
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
      rAllRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}r_all_remark']),
      rEventRemark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}r_event_remark']),
      rBuyPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}r_buy_price']),
      rHoldShares: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}r_hold_shares']),
      rNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}r_note']),
      cMeetUpdateAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}c_meet_update_at'])!,
      cNearUpdateAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}c_near_update_at'])!,
      cPriceCondition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}c_price_condition'])!,
      cMarketCapCondition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}c_market_cap_condition'])!,
      cPeTtmCondition: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}c_pe_ttm_condition'])!,
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
  final String? rAllRemark;
  final String? rEventRemark;
  final String? rBuyPrice;
  final String? rHoldShares;
  final String? rNote;
  final DateTime cMeetUpdateAt;
  final DateTime cNearUpdateAt;
  final int cPriceCondition;
  final int cMarketCapCondition;
  final int cPeTtmCondition;
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
      this.rAllRemark,
      this.rEventRemark,
      this.rBuyPrice,
      this.rHoldShares,
      this.rNote,
      required this.cMeetUpdateAt,
      required this.cNearUpdateAt,
      required this.cPriceCondition,
      required this.cMarketCapCondition,
      required this.cPeTtmCondition});
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
    if (!nullToAbsent || rAllRemark != null) {
      map['r_all_remark'] = Variable<String>(rAllRemark);
    }
    if (!nullToAbsent || rEventRemark != null) {
      map['r_event_remark'] = Variable<String>(rEventRemark);
    }
    if (!nullToAbsent || rBuyPrice != null) {
      map['r_buy_price'] = Variable<String>(rBuyPrice);
    }
    if (!nullToAbsent || rHoldShares != null) {
      map['r_hold_shares'] = Variable<String>(rHoldShares);
    }
    if (!nullToAbsent || rNote != null) {
      map['r_note'] = Variable<String>(rNote);
    }
    map['c_meet_update_at'] = Variable<DateTime>(cMeetUpdateAt);
    map['c_near_update_at'] = Variable<DateTime>(cNearUpdateAt);
    map['c_price_condition'] = Variable<int>(cPriceCondition);
    map['c_market_cap_condition'] = Variable<int>(cMarketCapCondition);
    map['c_pe_ttm_condition'] = Variable<int>(cPeTtmCondition);
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
      rAllRemark: rAllRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(rAllRemark),
      rEventRemark: rEventRemark == null && nullToAbsent
          ? const Value.absent()
          : Value(rEventRemark),
      rBuyPrice: rBuyPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(rBuyPrice),
      rHoldShares: rHoldShares == null && nullToAbsent
          ? const Value.absent()
          : Value(rHoldShares),
      rNote:
          rNote == null && nullToAbsent ? const Value.absent() : Value(rNote),
      cMeetUpdateAt: Value(cMeetUpdateAt),
      cNearUpdateAt: Value(cNearUpdateAt),
      cPriceCondition: Value(cPriceCondition),
      cMarketCapCondition: Value(cMarketCapCondition),
      cPeTtmCondition: Value(cPeTtmCondition),
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
      rAllRemark: serializer.fromJson<String?>(json['rAllRemark']),
      rEventRemark: serializer.fromJson<String?>(json['rEventRemark']),
      rBuyPrice: serializer.fromJson<String?>(json['rBuyPrice']),
      rHoldShares: serializer.fromJson<String?>(json['rHoldShares']),
      rNote: serializer.fromJson<String?>(json['rNote']),
      cMeetUpdateAt: serializer.fromJson<DateTime>(json['cMeetUpdateAt']),
      cNearUpdateAt: serializer.fromJson<DateTime>(json['cNearUpdateAt']),
      cPriceCondition: serializer.fromJson<int>(json['cPriceCondition']),
      cMarketCapCondition:
          serializer.fromJson<int>(json['cMarketCapCondition']),
      cPeTtmCondition: serializer.fromJson<int>(json['cPeTtmCondition']),
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
      'rAllRemark': serializer.toJson<String?>(rAllRemark),
      'rEventRemark': serializer.toJson<String?>(rEventRemark),
      'rBuyPrice': serializer.toJson<String?>(rBuyPrice),
      'rHoldShares': serializer.toJson<String?>(rHoldShares),
      'rNote': serializer.toJson<String?>(rNote),
      'cMeetUpdateAt': serializer.toJson<DateTime>(cMeetUpdateAt),
      'cNearUpdateAt': serializer.toJson<DateTime>(cNearUpdateAt),
      'cPriceCondition': serializer.toJson<int>(cPriceCondition),
      'cMarketCapCondition': serializer.toJson<int>(cMarketCapCondition),
      'cPeTtmCondition': serializer.toJson<int>(cPeTtmCondition),
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
          Value<String?> rAllRemark = const Value.absent(),
          Value<String?> rEventRemark = const Value.absent(),
          Value<String?> rBuyPrice = const Value.absent(),
          Value<String?> rHoldShares = const Value.absent(),
          Value<String?> rNote = const Value.absent(),
          DateTime? cMeetUpdateAt,
          DateTime? cNearUpdateAt,
          int? cPriceCondition,
          int? cMarketCapCondition,
          int? cPeTtmCondition}) =>
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
        rAllRemark: rAllRemark.present ? rAllRemark.value : this.rAllRemark,
        rEventRemark:
            rEventRemark.present ? rEventRemark.value : this.rEventRemark,
        rBuyPrice: rBuyPrice.present ? rBuyPrice.value : this.rBuyPrice,
        rHoldShares: rHoldShares.present ? rHoldShares.value : this.rHoldShares,
        rNote: rNote.present ? rNote.value : this.rNote,
        cMeetUpdateAt: cMeetUpdateAt ?? this.cMeetUpdateAt,
        cNearUpdateAt: cNearUpdateAt ?? this.cNearUpdateAt,
        cPriceCondition: cPriceCondition ?? this.cPriceCondition,
        cMarketCapCondition: cMarketCapCondition ?? this.cMarketCapCondition,
        cPeTtmCondition: cPeTtmCondition ?? this.cPeTtmCondition,
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
      rAllRemark:
          data.rAllRemark.present ? data.rAllRemark.value : this.rAllRemark,
      rEventRemark: data.rEventRemark.present
          ? data.rEventRemark.value
          : this.rEventRemark,
      rBuyPrice: data.rBuyPrice.present ? data.rBuyPrice.value : this.rBuyPrice,
      rHoldShares:
          data.rHoldShares.present ? data.rHoldShares.value : this.rHoldShares,
      rNote: data.rNote.present ? data.rNote.value : this.rNote,
      cMeetUpdateAt: data.cMeetUpdateAt.present
          ? data.cMeetUpdateAt.value
          : this.cMeetUpdateAt,
      cNearUpdateAt: data.cNearUpdateAt.present
          ? data.cNearUpdateAt.value
          : this.cNearUpdateAt,
      cPriceCondition: data.cPriceCondition.present
          ? data.cPriceCondition.value
          : this.cPriceCondition,
      cMarketCapCondition: data.cMarketCapCondition.present
          ? data.cMarketCapCondition.value
          : this.cMarketCapCondition,
      cPeTtmCondition: data.cPeTtmCondition.present
          ? data.cPeTtmCondition.value
          : this.cPeTtmCondition,
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
          ..write('rAllRemark: $rAllRemark, ')
          ..write('rEventRemark: $rEventRemark, ')
          ..write('rBuyPrice: $rBuyPrice, ')
          ..write('rHoldShares: $rHoldShares, ')
          ..write('rNote: $rNote, ')
          ..write('cMeetUpdateAt: $cMeetUpdateAt, ')
          ..write('cNearUpdateAt: $cNearUpdateAt, ')
          ..write('cPriceCondition: $cPriceCondition, ')
          ..write('cMarketCapCondition: $cMarketCapCondition, ')
          ..write('cPeTtmCondition: $cPeTtmCondition')
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
        rAllRemark,
        rEventRemark,
        rBuyPrice,
        rHoldShares,
        rNote,
        cMeetUpdateAt,
        cNearUpdateAt,
        cPriceCondition,
        cMarketCapCondition,
        cPeTtmCondition
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
          other.rAllRemark == this.rAllRemark &&
          other.rEventRemark == this.rEventRemark &&
          other.rBuyPrice == this.rBuyPrice &&
          other.rHoldShares == this.rHoldShares &&
          other.rNote == this.rNote &&
          other.cMeetUpdateAt == this.cMeetUpdateAt &&
          other.cNearUpdateAt == this.cNearUpdateAt &&
          other.cPriceCondition == this.cPriceCondition &&
          other.cMarketCapCondition == this.cMarketCapCondition &&
          other.cPeTtmCondition == this.cPeTtmCondition);
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
  final Value<String?> rAllRemark;
  final Value<String?> rEventRemark;
  final Value<String?> rBuyPrice;
  final Value<String?> rHoldShares;
  final Value<String?> rNote;
  final Value<DateTime> cMeetUpdateAt;
  final Value<DateTime> cNearUpdateAt;
  final Value<int> cPriceCondition;
  final Value<int> cMarketCapCondition;
  final Value<int> cPeTtmCondition;
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
    this.rAllRemark = const Value.absent(),
    this.rEventRemark = const Value.absent(),
    this.rBuyPrice = const Value.absent(),
    this.rHoldShares = const Value.absent(),
    this.rNote = const Value.absent(),
    this.cMeetUpdateAt = const Value.absent(),
    this.cNearUpdateAt = const Value.absent(),
    this.cPriceCondition = const Value.absent(),
    this.cMarketCapCondition = const Value.absent(),
    this.cPeTtmCondition = const Value.absent(),
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
    this.rAllRemark = const Value.absent(),
    this.rEventRemark = const Value.absent(),
    this.rBuyPrice = const Value.absent(),
    this.rHoldShares = const Value.absent(),
    this.rNote = const Value.absent(),
    this.cMeetUpdateAt = const Value.absent(),
    this.cNearUpdateAt = const Value.absent(),
    this.cPriceCondition = const Value.absent(),
    this.cMarketCapCondition = const Value.absent(),
    this.cPeTtmCondition = const Value.absent(),
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
    Expression<String>? rAllRemark,
    Expression<String>? rEventRemark,
    Expression<String>? rBuyPrice,
    Expression<String>? rHoldShares,
    Expression<String>? rNote,
    Expression<DateTime>? cMeetUpdateAt,
    Expression<DateTime>? cNearUpdateAt,
    Expression<int>? cPriceCondition,
    Expression<int>? cMarketCapCondition,
    Expression<int>? cPeTtmCondition,
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
      if (rAllRemark != null) 'r_all_remark': rAllRemark,
      if (rEventRemark != null) 'r_event_remark': rEventRemark,
      if (rBuyPrice != null) 'r_buy_price': rBuyPrice,
      if (rHoldShares != null) 'r_hold_shares': rHoldShares,
      if (rNote != null) 'r_note': rNote,
      if (cMeetUpdateAt != null) 'c_meet_update_at': cMeetUpdateAt,
      if (cNearUpdateAt != null) 'c_near_update_at': cNearUpdateAt,
      if (cPriceCondition != null) 'c_price_condition': cPriceCondition,
      if (cMarketCapCondition != null)
        'c_market_cap_condition': cMarketCapCondition,
      if (cPeTtmCondition != null) 'c_pe_ttm_condition': cPeTtmCondition,
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
      Value<String?>? rAllRemark,
      Value<String?>? rEventRemark,
      Value<String?>? rBuyPrice,
      Value<String?>? rHoldShares,
      Value<String?>? rNote,
      Value<DateTime>? cMeetUpdateAt,
      Value<DateTime>? cNearUpdateAt,
      Value<int>? cPriceCondition,
      Value<int>? cMarketCapCondition,
      Value<int>? cPeTtmCondition}) {
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
      rAllRemark: rAllRemark ?? this.rAllRemark,
      rEventRemark: rEventRemark ?? this.rEventRemark,
      rBuyPrice: rBuyPrice ?? this.rBuyPrice,
      rHoldShares: rHoldShares ?? this.rHoldShares,
      rNote: rNote ?? this.rNote,
      cMeetUpdateAt: cMeetUpdateAt ?? this.cMeetUpdateAt,
      cNearUpdateAt: cNearUpdateAt ?? this.cNearUpdateAt,
      cPriceCondition: cPriceCondition ?? this.cPriceCondition,
      cMarketCapCondition: cMarketCapCondition ?? this.cMarketCapCondition,
      cPeTtmCondition: cPeTtmCondition ?? this.cPeTtmCondition,
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
    if (rAllRemark.present) {
      map['r_all_remark'] = Variable<String>(rAllRemark.value);
    }
    if (rEventRemark.present) {
      map['r_event_remark'] = Variable<String>(rEventRemark.value);
    }
    if (rBuyPrice.present) {
      map['r_buy_price'] = Variable<String>(rBuyPrice.value);
    }
    if (rHoldShares.present) {
      map['r_hold_shares'] = Variable<String>(rHoldShares.value);
    }
    if (rNote.present) {
      map['r_note'] = Variable<String>(rNote.value);
    }
    if (cMeetUpdateAt.present) {
      map['c_meet_update_at'] = Variable<DateTime>(cMeetUpdateAt.value);
    }
    if (cNearUpdateAt.present) {
      map['c_near_update_at'] = Variable<DateTime>(cNearUpdateAt.value);
    }
    if (cPriceCondition.present) {
      map['c_price_condition'] = Variable<int>(cPriceCondition.value);
    }
    if (cMarketCapCondition.present) {
      map['c_market_cap_condition'] = Variable<int>(cMarketCapCondition.value);
    }
    if (cPeTtmCondition.present) {
      map['c_pe_ttm_condition'] = Variable<int>(cPeTtmCondition.value);
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
          ..write('rAllRemark: $rAllRemark, ')
          ..write('rEventRemark: $rEventRemark, ')
          ..write('rBuyPrice: $rBuyPrice, ')
          ..write('rHoldShares: $rHoldShares, ')
          ..write('rNote: $rNote, ')
          ..write('cMeetUpdateAt: $cMeetUpdateAt, ')
          ..write('cNearUpdateAt: $cNearUpdateAt, ')
          ..write('cPriceCondition: $cPriceCondition, ')
          ..write('cMarketCapCondition: $cMarketCapCondition, ')
          ..write('cPeTtmCondition: $cPeTtmCondition')
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

class $StockTradesTable extends StockTrades
    with TableInfo<$StockTradesTable, StockTrade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockTradesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stockIdMeta =
      const VerificationMeta('stockId');
  @override
  late final GeneratedColumn<int> stockId = GeneratedColumn<int>(
      'stock_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES stock_items (id)'));
  static const VerificationMeta _tradeTypeMeta =
      const VerificationMeta('tradeType');
  @override
  late final GeneratedColumn<int> tradeType = GeneratedColumn<int>(
      'trade_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<String> shares = GeneratedColumn<String>(
      'shares', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
      'remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updateAt, stockId, tradeType, price, shares, remark];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_trades';
  @override
  VerificationContext validateIntegrity(Insertable<StockTrade> instance,
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
    if (data.containsKey('stock_id')) {
      context.handle(_stockIdMeta,
          stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta));
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('trade_type')) {
      context.handle(_tradeTypeMeta,
          tradeType.isAcceptableOrUnknown(data['trade_type']!, _tradeTypeMeta));
    } else if (isInserting) {
      context.missing(_tradeTypeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('shares')) {
      context.handle(_sharesMeta,
          shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta));
    }
    if (data.containsKey('remark')) {
      context.handle(_remarkMeta,
          remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockTrade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockTrade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at'])!,
      stockId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_id'])!,
      tradeType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trade_type'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price']),
      shares: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shares']),
      remark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remark']),
    );
  }

  @override
  $StockTradesTable createAlias(String alias) {
    return $StockTradesTable(attachedDatabase, alias);
  }
}

class StockTrade extends DataClass implements Insertable<StockTrade> {
  final int id;
  final DateTime createdAt;
  final DateTime updateAt;
  final int stockId;
  final int tradeType;
  final String? price;
  final String? shares;
  final String? remark;
  const StockTrade(
      {required this.id,
      required this.createdAt,
      required this.updateAt,
      required this.stockId,
      required this.tradeType,
      this.price,
      this.shares,
      this.remark});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['update_at'] = Variable<DateTime>(updateAt);
    map['stock_id'] = Variable<int>(stockId);
    map['trade_type'] = Variable<int>(tradeType);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String>(price);
    }
    if (!nullToAbsent || shares != null) {
      map['shares'] = Variable<String>(shares);
    }
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    return map;
  }

  StockTradesCompanion toCompanion(bool nullToAbsent) {
    return StockTradesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updateAt: Value(updateAt),
      stockId: Value(stockId),
      tradeType: Value(tradeType),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      shares:
          shares == null && nullToAbsent ? const Value.absent() : Value(shares),
      remark:
          remark == null && nullToAbsent ? const Value.absent() : Value(remark),
    );
  }

  factory StockTrade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockTrade(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updateAt: serializer.fromJson<DateTime>(json['updateAt']),
      stockId: serializer.fromJson<int>(json['stockId']),
      tradeType: serializer.fromJson<int>(json['tradeType']),
      price: serializer.fromJson<String?>(json['price']),
      shares: serializer.fromJson<String?>(json['shares']),
      remark: serializer.fromJson<String?>(json['remark']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updateAt': serializer.toJson<DateTime>(updateAt),
      'stockId': serializer.toJson<int>(stockId),
      'tradeType': serializer.toJson<int>(tradeType),
      'price': serializer.toJson<String?>(price),
      'shares': serializer.toJson<String?>(shares),
      'remark': serializer.toJson<String?>(remark),
    };
  }

  StockTrade copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updateAt,
          int? stockId,
          int? tradeType,
          Value<String?> price = const Value.absent(),
          Value<String?> shares = const Value.absent(),
          Value<String?> remark = const Value.absent()}) =>
      StockTrade(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updateAt: updateAt ?? this.updateAt,
        stockId: stockId ?? this.stockId,
        tradeType: tradeType ?? this.tradeType,
        price: price.present ? price.value : this.price,
        shares: shares.present ? shares.value : this.shares,
        remark: remark.present ? remark.value : this.remark,
      );
  StockTrade copyWithCompanion(StockTradesCompanion data) {
    return StockTrade(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      tradeType: data.tradeType.present ? data.tradeType.value : this.tradeType,
      price: data.price.present ? data.price.value : this.price,
      shares: data.shares.present ? data.shares.value : this.shares,
      remark: data.remark.present ? data.remark.value : this.remark,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockTrade(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('stockId: $stockId, ')
          ..write('tradeType: $tradeType, ')
          ..write('price: $price, ')
          ..write('shares: $shares, ')
          ..write('remark: $remark')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createdAt, updateAt, stockId, tradeType, price, shares, remark);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockTrade &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updateAt == this.updateAt &&
          other.stockId == this.stockId &&
          other.tradeType == this.tradeType &&
          other.price == this.price &&
          other.shares == this.shares &&
          other.remark == this.remark);
}

class StockTradesCompanion extends UpdateCompanion<StockTrade> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updateAt;
  final Value<int> stockId;
  final Value<int> tradeType;
  final Value<String?> price;
  final Value<String?> shares;
  final Value<String?> remark;
  const StockTradesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.stockId = const Value.absent(),
    this.tradeType = const Value.absent(),
    this.price = const Value.absent(),
    this.shares = const Value.absent(),
    this.remark = const Value.absent(),
  });
  StockTradesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    required int stockId,
    required int tradeType,
    this.price = const Value.absent(),
    this.shares = const Value.absent(),
    this.remark = const Value.absent(),
  })  : stockId = Value(stockId),
        tradeType = Value(tradeType);
  static Insertable<StockTrade> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updateAt,
    Expression<int>? stockId,
    Expression<int>? tradeType,
    Expression<String>? price,
    Expression<String>? shares,
    Expression<String>? remark,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updateAt != null) 'update_at': updateAt,
      if (stockId != null) 'stock_id': stockId,
      if (tradeType != null) 'trade_type': tradeType,
      if (price != null) 'price': price,
      if (shares != null) 'shares': shares,
      if (remark != null) 'remark': remark,
    });
  }

  StockTradesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updateAt,
      Value<int>? stockId,
      Value<int>? tradeType,
      Value<String?>? price,
      Value<String?>? shares,
      Value<String?>? remark}) {
    return StockTradesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      stockId: stockId ?? this.stockId,
      tradeType: tradeType ?? this.tradeType,
      price: price ?? this.price,
      shares: shares ?? this.shares,
      remark: remark ?? this.remark,
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
    if (stockId.present) {
      map['stock_id'] = Variable<int>(stockId.value);
    }
    if (tradeType.present) {
      map['trade_type'] = Variable<int>(tradeType.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (shares.present) {
      map['shares'] = Variable<String>(shares.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockTradesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('stockId: $stockId, ')
          ..write('tradeType: $tradeType, ')
          ..write('price: $price, ')
          ..write('shares: $shares, ')
          ..write('remark: $remark')
          ..write(')'))
        .toString();
  }
}

class $NoteItemTagsTable extends NoteItemTags
    with TableInfo<$NoteItemTagsTable, NoteItemTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteItemTagsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'note_item_tags';
  @override
  VerificationContext validateIntegrity(Insertable<NoteItemTag> instance,
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
  NoteItemTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteItemTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $NoteItemTagsTable createAlias(String alias) {
    return $NoteItemTagsTable(attachedDatabase, alias);
  }
}

class NoteItemTag extends DataClass implements Insertable<NoteItemTag> {
  final int id;
  final String name;
  const NoteItemTag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  NoteItemTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteItemTagsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory NoteItemTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteItemTag(
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

  NoteItemTag copyWith({int? id, String? name}) => NoteItemTag(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  NoteItemTag copyWithCompanion(NoteItemTagsCompanion data) {
    return NoteItemTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteItemTag(')
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
      (other is NoteItemTag && other.id == this.id && other.name == this.name);
}

class NoteItemTagsCompanion extends UpdateCompanion<NoteItemTag> {
  final Value<int> id;
  final Value<String> name;
  const NoteItemTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  NoteItemTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<NoteItemTag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  NoteItemTagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return NoteItemTagsCompanion(
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
    return (StringBuffer('NoteItemTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $NoteTagsTable extends NoteTags with TableInfo<$NoteTagsTable, NoteTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<int> noteId = GeneratedColumn<int>(
      'note_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES note_items (id)'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES note_item_tags (id)'));
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tags';
  @override
  VerificationContext validateIntegrity(Insertable<NoteTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  NoteTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTag(
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $NoteTagsTable createAlias(String alias) {
    return $NoteTagsTable(attachedDatabase, alias);
  }
}

class NoteTag extends DataClass implements Insertable<NoteTag> {
  final int noteId;
  final int tagId;
  const NoteTag({required this.noteId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<int>(noteId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  NoteTagsCompanion toCompanion(bool nullToAbsent) {
    return NoteTagsCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
    );
  }

  factory NoteTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTag(
      noteId: serializer.fromJson<int>(json['noteId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<int>(noteId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  NoteTag copyWith({int? noteId, int? tagId}) => NoteTag(
        noteId: noteId ?? this.noteId,
        tagId: tagId ?? this.tagId,
      );
  NoteTag copyWithCompanion(NoteTagsCompanion data) {
    return NoteTag(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTag(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTag &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId);
}

class NoteTagsCompanion extends UpdateCompanion<NoteTag> {
  final Value<int> noteId;
  final Value<int> tagId;
  final Value<int> rowid;
  const NoteTagsCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagsCompanion.insert({
    required int noteId,
    required int tagId,
    this.rowid = const Value.absent(),
  })  : noteId = Value(noteId),
        tagId = Value(tagId);
  static Insertable<NoteTag> custom({
    Expression<int>? noteId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagsCompanion copyWith(
      {Value<int>? noteId, Value<int>? tagId, Value<int>? rowid}) {
    return NoteTagsCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<int>(noteId.value);
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
    return (StringBuffer('NoteTagsCompanion(')
          ..write('noteId: $noteId, ')
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
  late final $StockTradesTable stockTrades = $StockTradesTable(this);
  late final $NoteItemTagsTable noteItemTags = $NoteItemTagsTable(this);
  late final $NoteTagsTable noteTags = $NoteTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        stockItems,
        noteItems,
        stockItemTags,
        stockTags,
        stockTrades,
        noteItemTags,
        noteTags
      ];
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
  Value<String?> rAllRemark,
  Value<String?> rEventRemark,
  Value<String?> rBuyPrice,
  Value<String?> rHoldShares,
  Value<String?> rNote,
  Value<DateTime> cMeetUpdateAt,
  Value<DateTime> cNearUpdateAt,
  Value<int> cPriceCondition,
  Value<int> cMarketCapCondition,
  Value<int> cPeTtmCondition,
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
  Value<String?> rAllRemark,
  Value<String?> rEventRemark,
  Value<String?> rBuyPrice,
  Value<String?> rHoldShares,
  Value<String?> rNote,
  Value<DateTime> cMeetUpdateAt,
  Value<DateTime> cNearUpdateAt,
  Value<int> cPriceCondition,
  Value<int> cMarketCapCondition,
  Value<int> cPeTtmCondition,
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

  static MultiTypedResultKey<$StockTradesTable, List<StockTrade>>
      _stockTradesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.stockTrades,
          aliasName:
              $_aliasNameGenerator(db.stockItems.id, db.stockTrades.stockId));

  $$StockTradesTableProcessedTableManager get stockTradesRefs {
    final manager = $$StockTradesTableTableManager($_db, $_db.stockTrades)
        .filter((f) => f.stockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockTradesRefsTable($_db));
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

  ColumnFilters<String> get rAllRemark => $composableBuilder(
      column: $table.rAllRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rEventRemark => $composableBuilder(
      column: $table.rEventRemark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rBuyPrice => $composableBuilder(
      column: $table.rBuyPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rHoldShares => $composableBuilder(
      column: $table.rHoldShares, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rNote => $composableBuilder(
      column: $table.rNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cMeetUpdateAt => $composableBuilder(
      column: $table.cMeetUpdateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cNearUpdateAt => $composableBuilder(
      column: $table.cNearUpdateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cPriceCondition => $composableBuilder(
      column: $table.cPriceCondition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cMarketCapCondition => $composableBuilder(
      column: $table.cMarketCapCondition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cPeTtmCondition => $composableBuilder(
      column: $table.cPeTtmCondition,
      builder: (column) => ColumnFilters(column));

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

  Expression<bool> stockTradesRefs(
      Expression<bool> Function($$StockTradesTableFilterComposer f) f) {
    final $$StockTradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTrades,
        getReferencedColumn: (t) => t.stockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTradesTableFilterComposer(
              $db: $db,
              $table: $db.stockTrades,
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

  ColumnOrderings<String> get rAllRemark => $composableBuilder(
      column: $table.rAllRemark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rEventRemark => $composableBuilder(
      column: $table.rEventRemark,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rBuyPrice => $composableBuilder(
      column: $table.rBuyPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rHoldShares => $composableBuilder(
      column: $table.rHoldShares, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rNote => $composableBuilder(
      column: $table.rNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cMeetUpdateAt => $composableBuilder(
      column: $table.cMeetUpdateAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cNearUpdateAt => $composableBuilder(
      column: $table.cNearUpdateAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cPriceCondition => $composableBuilder(
      column: $table.cPriceCondition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cMarketCapCondition => $composableBuilder(
      column: $table.cMarketCapCondition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cPeTtmCondition => $composableBuilder(
      column: $table.cPeTtmCondition,
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

  GeneratedColumn<String> get rAllRemark => $composableBuilder(
      column: $table.rAllRemark, builder: (column) => column);

  GeneratedColumn<String> get rEventRemark => $composableBuilder(
      column: $table.rEventRemark, builder: (column) => column);

  GeneratedColumn<String> get rBuyPrice =>
      $composableBuilder(column: $table.rBuyPrice, builder: (column) => column);

  GeneratedColumn<String> get rHoldShares => $composableBuilder(
      column: $table.rHoldShares, builder: (column) => column);

  GeneratedColumn<String> get rNote =>
      $composableBuilder(column: $table.rNote, builder: (column) => column);

  GeneratedColumn<DateTime> get cMeetUpdateAt => $composableBuilder(
      column: $table.cMeetUpdateAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cNearUpdateAt => $composableBuilder(
      column: $table.cNearUpdateAt, builder: (column) => column);

  GeneratedColumn<int> get cPriceCondition => $composableBuilder(
      column: $table.cPriceCondition, builder: (column) => column);

  GeneratedColumn<int> get cMarketCapCondition => $composableBuilder(
      column: $table.cMarketCapCondition, builder: (column) => column);

  GeneratedColumn<int> get cPeTtmCondition => $composableBuilder(
      column: $table.cPeTtmCondition, builder: (column) => column);

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

  Expression<T> stockTradesRefs<T extends Object>(
      Expression<T> Function($$StockTradesTableAnnotationComposer a) f) {
    final $$StockTradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockTrades,
        getReferencedColumn: (t) => t.stockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockTradesTableAnnotationComposer(
              $db: $db,
              $table: $db.stockTrades,
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
    PrefetchHooks Function({bool stockTagsRefs, bool stockTradesRefs})> {
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
            Value<String?> rAllRemark = const Value.absent(),
            Value<String?> rEventRemark = const Value.absent(),
            Value<String?> rBuyPrice = const Value.absent(),
            Value<String?> rHoldShares = const Value.absent(),
            Value<String?> rNote = const Value.absent(),
            Value<DateTime> cMeetUpdateAt = const Value.absent(),
            Value<DateTime> cNearUpdateAt = const Value.absent(),
            Value<int> cPriceCondition = const Value.absent(),
            Value<int> cMarketCapCondition = const Value.absent(),
            Value<int> cPeTtmCondition = const Value.absent(),
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
            rAllRemark: rAllRemark,
            rEventRemark: rEventRemark,
            rBuyPrice: rBuyPrice,
            rHoldShares: rHoldShares,
            rNote: rNote,
            cMeetUpdateAt: cMeetUpdateAt,
            cNearUpdateAt: cNearUpdateAt,
            cPriceCondition: cPriceCondition,
            cMarketCapCondition: cMarketCapCondition,
            cPeTtmCondition: cPeTtmCondition,
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
            Value<String?> rAllRemark = const Value.absent(),
            Value<String?> rEventRemark = const Value.absent(),
            Value<String?> rBuyPrice = const Value.absent(),
            Value<String?> rHoldShares = const Value.absent(),
            Value<String?> rNote = const Value.absent(),
            Value<DateTime> cMeetUpdateAt = const Value.absent(),
            Value<DateTime> cNearUpdateAt = const Value.absent(),
            Value<int> cPriceCondition = const Value.absent(),
            Value<int> cMarketCapCondition = const Value.absent(),
            Value<int> cPeTtmCondition = const Value.absent(),
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
            rAllRemark: rAllRemark,
            rEventRemark: rEventRemark,
            rBuyPrice: rBuyPrice,
            rHoldShares: rHoldShares,
            rNote: rNote,
            cMeetUpdateAt: cMeetUpdateAt,
            cNearUpdateAt: cNearUpdateAt,
            cPriceCondition: cPriceCondition,
            cMarketCapCondition: cMarketCapCondition,
            cPeTtmCondition: cPeTtmCondition,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {stockTagsRefs = false, stockTradesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (stockTagsRefs) db.stockTags,
                if (stockTradesRefs) db.stockTrades
              ],
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
                        typedResults: items),
                  if (stockTradesRefs)
                    await $_getPrefetchedData<StockItem, $StockItemsTable,
                            StockTrade>(
                        currentTable: table,
                        referencedTable: $$StockItemsTableReferences
                            ._stockTradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StockItemsTableReferences(db, table, p0)
                                .stockTradesRefs,
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
    PrefetchHooks Function({bool stockTagsRefs, bool stockTradesRefs})>;
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

final class $$NoteItemsTableReferences
    extends BaseReferences<_$AppDatabase, $NoteItemsTable, NoteItem> {
  $$NoteItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteTagsTable, List<NoteTag>> _noteTagsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.noteTags,
          aliasName: $_aliasNameGenerator(db.noteItems.id, db.noteTags.noteId));

  $$NoteTagsTableProcessedTableManager get noteTagsRefs {
    final manager = $$NoteTagsTableTableManager($_db, $_db.noteTags)
        .filter((f) => f.noteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  Expression<bool> noteTagsRefs(
      Expression<bool> Function($$NoteTagsTableFilterComposer f) f) {
    final $$NoteTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteTags,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteTagsTableFilterComposer(
              $db: $db,
              $table: $db.noteTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  Expression<T> noteTagsRefs<T extends Object>(
      Expression<T> Function($$NoteTagsTableAnnotationComposer a) f) {
    final $$NoteTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteTags,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.noteTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
    (NoteItem, $$NoteItemsTableReferences),
    NoteItem,
    PrefetchHooks Function({bool noteTagsRefs})> {
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
              .map((e) => (
                    e.readTable(table),
                    $$NoteItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (noteTagsRefs) db.noteTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteTagsRefs)
                    await $_getPrefetchedData<NoteItem, $NoteItemsTable,
                            NoteTag>(
                        currentTable: table,
                        referencedTable:
                            $$NoteItemsTableReferences._noteTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NoteItemsTableReferences(db, table, p0)
                                .noteTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.noteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (NoteItem, $$NoteItemsTableReferences),
    NoteItem,
    PrefetchHooks Function({bool noteTagsRefs})>;
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
typedef $$StockTradesTableCreateCompanionBuilder = StockTradesCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  required int stockId,
  required int tradeType,
  Value<String?> price,
  Value<String?> shares,
  Value<String?> remark,
});
typedef $$StockTradesTableUpdateCompanionBuilder = StockTradesCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<DateTime> updateAt,
  Value<int> stockId,
  Value<int> tradeType,
  Value<String?> price,
  Value<String?> shares,
  Value<String?> remark,
});

final class $$StockTradesTableReferences
    extends BaseReferences<_$AppDatabase, $StockTradesTable, StockTrade> {
  $$StockTradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StockItemsTable _stockIdTable(_$AppDatabase db) =>
      db.stockItems.createAlias(
          $_aliasNameGenerator(db.stockTrades.stockId, db.stockItems.id));

  $$StockItemsTableProcessedTableManager get stockId {
    final $_column = $_itemColumn<int>('stock_id')!;

    final manager = $$StockItemsTableTableManager($_db, $_db.stockItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockTradesTableFilterComposer
    extends Composer<_$AppDatabase, $StockTradesTable> {
  $$StockTradesTableFilterComposer({
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

  ColumnFilters<int> get tradeType => $composableBuilder(
      column: $table.tradeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shares => $composableBuilder(
      column: $table.shares, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remark => $composableBuilder(
      column: $table.remark, builder: (column) => ColumnFilters(column));

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
}

class $$StockTradesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockTradesTable> {
  $$StockTradesTableOrderingComposer({
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

  ColumnOrderings<int> get tradeType => $composableBuilder(
      column: $table.tradeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shares => $composableBuilder(
      column: $table.shares, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remark => $composableBuilder(
      column: $table.remark, builder: (column) => ColumnOrderings(column));

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
}

class $$StockTradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockTradesTable> {
  $$StockTradesTableAnnotationComposer({
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

  GeneratedColumn<int> get tradeType =>
      $composableBuilder(column: $table.tradeType, builder: (column) => column);

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

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
}

class $$StockTradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockTradesTable,
    StockTrade,
    $$StockTradesTableFilterComposer,
    $$StockTradesTableOrderingComposer,
    $$StockTradesTableAnnotationComposer,
    $$StockTradesTableCreateCompanionBuilder,
    $$StockTradesTableUpdateCompanionBuilder,
    (StockTrade, $$StockTradesTableReferences),
    StockTrade,
    PrefetchHooks Function({bool stockId})> {
  $$StockTradesTableTableManager(_$AppDatabase db, $StockTradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockTradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockTradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockTradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            Value<int> stockId = const Value.absent(),
            Value<int> tradeType = const Value.absent(),
            Value<String?> price = const Value.absent(),
            Value<String?> shares = const Value.absent(),
            Value<String?> remark = const Value.absent(),
          }) =>
              StockTradesCompanion(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            stockId: stockId,
            tradeType: tradeType,
            price: price,
            shares: shares,
            remark: remark,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updateAt = const Value.absent(),
            required int stockId,
            required int tradeType,
            Value<String?> price = const Value.absent(),
            Value<String?> shares = const Value.absent(),
            Value<String?> remark = const Value.absent(),
          }) =>
              StockTradesCompanion.insert(
            id: id,
            createdAt: createdAt,
            updateAt: updateAt,
            stockId: stockId,
            tradeType: tradeType,
            price: price,
            shares: shares,
            remark: remark,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockTradesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({stockId = false}) {
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
                        $$StockTradesTableReferences._stockIdTable(db),
                    referencedColumn:
                        $$StockTradesTableReferences._stockIdTable(db).id,
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

typedef $$StockTradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockTradesTable,
    StockTrade,
    $$StockTradesTableFilterComposer,
    $$StockTradesTableOrderingComposer,
    $$StockTradesTableAnnotationComposer,
    $$StockTradesTableCreateCompanionBuilder,
    $$StockTradesTableUpdateCompanionBuilder,
    (StockTrade, $$StockTradesTableReferences),
    StockTrade,
    PrefetchHooks Function({bool stockId})>;
typedef $$NoteItemTagsTableCreateCompanionBuilder = NoteItemTagsCompanion
    Function({
  Value<int> id,
  required String name,
});
typedef $$NoteItemTagsTableUpdateCompanionBuilder = NoteItemTagsCompanion
    Function({
  Value<int> id,
  Value<String> name,
});

final class $$NoteItemTagsTableReferences
    extends BaseReferences<_$AppDatabase, $NoteItemTagsTable, NoteItemTag> {
  $$NoteItemTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteTagsTable, List<NoteTag>> _noteTagsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.noteTags,
          aliasName:
              $_aliasNameGenerator(db.noteItemTags.id, db.noteTags.tagId));

  $$NoteTagsTableProcessedTableManager get noteTagsRefs {
    final manager = $$NoteTagsTableTableManager($_db, $_db.noteTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NoteItemTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteItemTagsTable> {
  $$NoteItemTagsTableFilterComposer({
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

  Expression<bool> noteTagsRefs(
      Expression<bool> Function($$NoteTagsTableFilterComposer f) f) {
    final $$NoteTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteTagsTableFilterComposer(
              $db: $db,
              $table: $db.noteTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NoteItemTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteItemTagsTable> {
  $$NoteItemTagsTableOrderingComposer({
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

class $$NoteItemTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteItemTagsTable> {
  $$NoteItemTagsTableAnnotationComposer({
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

  Expression<T> noteTagsRefs<T extends Object>(
      Expression<T> Function($$NoteTagsTableAnnotationComposer a) f) {
    final $$NoteTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.noteTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.noteTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NoteItemTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteItemTagsTable,
    NoteItemTag,
    $$NoteItemTagsTableFilterComposer,
    $$NoteItemTagsTableOrderingComposer,
    $$NoteItemTagsTableAnnotationComposer,
    $$NoteItemTagsTableCreateCompanionBuilder,
    $$NoteItemTagsTableUpdateCompanionBuilder,
    (NoteItemTag, $$NoteItemTagsTableReferences),
    NoteItemTag,
    PrefetchHooks Function({bool noteTagsRefs})> {
  $$NoteItemTagsTableTableManager(_$AppDatabase db, $NoteItemTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteItemTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteItemTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteItemTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              NoteItemTagsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              NoteItemTagsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NoteItemTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (noteTagsRefs) db.noteTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteTagsRefs)
                    await $_getPrefetchedData<NoteItemTag, $NoteItemTagsTable,
                            NoteTag>(
                        currentTable: table,
                        referencedTable: $$NoteItemTagsTableReferences
                            ._noteTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NoteItemTagsTableReferences(db, table, p0)
                                .noteTagsRefs,
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

typedef $$NoteItemTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteItemTagsTable,
    NoteItemTag,
    $$NoteItemTagsTableFilterComposer,
    $$NoteItemTagsTableOrderingComposer,
    $$NoteItemTagsTableAnnotationComposer,
    $$NoteItemTagsTableCreateCompanionBuilder,
    $$NoteItemTagsTableUpdateCompanionBuilder,
    (NoteItemTag, $$NoteItemTagsTableReferences),
    NoteItemTag,
    PrefetchHooks Function({bool noteTagsRefs})>;
typedef $$NoteTagsTableCreateCompanionBuilder = NoteTagsCompanion Function({
  required int noteId,
  required int tagId,
  Value<int> rowid,
});
typedef $$NoteTagsTableUpdateCompanionBuilder = NoteTagsCompanion Function({
  Value<int> noteId,
  Value<int> tagId,
  Value<int> rowid,
});

final class $$NoteTagsTableReferences
    extends BaseReferences<_$AppDatabase, $NoteTagsTable, NoteTag> {
  $$NoteTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NoteItemsTable _noteIdTable(_$AppDatabase db) => db.noteItems
      .createAlias($_aliasNameGenerator(db.noteTags.noteId, db.noteItems.id));

  $$NoteItemsTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<int>('note_id')!;

    final manager = $$NoteItemsTableTableManager($_db, $_db.noteItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $NoteItemTagsTable _tagIdTable(_$AppDatabase db) => db.noteItemTags
      .createAlias($_aliasNameGenerator(db.noteTags.tagId, db.noteItemTags.id));

  $$NoteItemTagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$NoteItemTagsTableTableManager($_db, $_db.noteItemTags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NoteTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NoteItemsTableFilterComposer get noteId {
    final $$NoteItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemsTableFilterComposer(
              $db: $db,
              $table: $db.noteItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$NoteItemTagsTableFilterComposer get tagId {
    final $$NoteItemTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.noteItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemTagsTableFilterComposer(
              $db: $db,
              $table: $db.noteItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NoteItemsTableOrderingComposer get noteId {
    final $$NoteItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemsTableOrderingComposer(
              $db: $db,
              $table: $db.noteItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$NoteItemTagsTableOrderingComposer get tagId {
    final $$NoteItemTagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.noteItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemTagsTableOrderingComposer(
              $db: $db,
              $table: $db.noteItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagsTable> {
  $$NoteTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NoteItemsTableAnnotationComposer get noteId {
    final $$NoteItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.noteItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$NoteItemTagsTableAnnotationComposer get tagId {
    final $$NoteItemTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.noteItemTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteItemTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.noteItemTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NoteTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTag,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTag, $$NoteTagsTableReferences),
    NoteTag,
    PrefetchHooks Function({bool noteId, bool tagId})> {
  $$NoteTagsTableTableManager(_$AppDatabase db, $NoteTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> noteId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion(
            noteId: noteId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int noteId,
            required int tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteTagsCompanion.insert(
            noteId: noteId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$NoteTagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({noteId = false, tagId = false}) {
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
                if (noteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.noteId,
                    referencedTable: $$NoteTagsTableReferences._noteIdTable(db),
                    referencedColumn:
                        $$NoteTagsTableReferences._noteIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable: $$NoteTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$NoteTagsTableReferences._tagIdTable(db).id,
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

typedef $$NoteTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NoteTagsTable,
    NoteTag,
    $$NoteTagsTableFilterComposer,
    $$NoteTagsTableOrderingComposer,
    $$NoteTagsTableAnnotationComposer,
    $$NoteTagsTableCreateCompanionBuilder,
    $$NoteTagsTableUpdateCompanionBuilder,
    (NoteTag, $$NoteTagsTableReferences),
    NoteTag,
    PrefetchHooks Function({bool noteId, bool tagId})>;

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
  $$StockTradesTableTableManager get stockTrades =>
      $$StockTradesTableTableManager(_db, _db.stockTrades);
  $$NoteItemTagsTableTableManager get noteItemTags =>
      $$NoteItemTagsTableTableManager(_db, _db.noteItemTags);
  $$NoteTagsTableTableManager get noteTags =>
      $$NoteTagsTableTableManager(_db, _db.noteTags);
}
