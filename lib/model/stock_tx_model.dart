/// market_type : "1"
/// name : "青山纸业"
/// code : "sh600103"
/// current_price : "2.21"
/// pe_ratio_ttm : "42.27"
/// total_market_cap : "49.80"
/// pb_ratio : "1.27"
library;

import 'package:get/get.dart';

import '../common/database/database.dart';
import '../common/globle_service.dart';
import '../common/langs/text_key.dart';

class StockTxModel {
  StockTxModel({
    this.marketType,
    this.name,
    this.code,
    this.currentPrice,
    this.peRatioTtm,
    this.totalMarketCap,
    this.pbRatio,
  });

  StockTxModel.fromJson(dynamic json) {
    marketType = json['market_type'];
    name = json['name'];
    code = json['code'];
    currentPrice = json['current_price'];
    peRatioTtm = json['pe_ratio_ttm'];
    totalMarketCap = json['total_market_cap'];
    pbRatio = json['pb_ratio'];
  }
  String? marketType;
  String? name;
  String? code;
  String? currentPrice;
  String? peRatioTtm;
  String? totalMarketCap;
  String? pbRatio;
//   StockTxModel copyWith({  String? marketType,
//   String? name,
//   String? code,
//   String? currentPrice,
//   String? peRatioTtm,
//   String? totalMarketCap,
//   String? pbRatio,
// }) => StockTxModel(  marketType: marketType ?? this.marketType,
//   name: name ?? this.name,
//   code: code ?? this.code,
//   currentPrice: currentPrice ?? this.currentPrice,
//   peRatioTtm: peRatioTtm ?? this.peRatioTtm,
//   totalMarketCap: totalMarketCap ?? this.totalMarketCap,
//   pbRatio: pbRatio ?? this.pbRatio,
// );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['market_type'] = marketType;
    map['name'] = name;
    map['code'] = code;
    map['current_price'] = currentPrice;
    map['pe_ratio_ttm'] = peRatioTtm;
    map['total_market_cap'] = totalMarketCap;
    map['pb_ratio'] = pbRatio;
    return map;
  }

  @override
  String toString() {
    return 'StockTxModel{marketType: $marketType, name: $name, code: $code, currentPrice: $currentPrice, peRatioTtm: $peRatioTtm, totalMarketCap: $totalMarketCap, pbRatio: $pbRatio}';
  }

  //股票页面使用
  String showAllInfo() {
    return "股票名称：$name\n股票代码：$code\n 市价：$currentPrice\n市盈率：$peRatioTtm\n市净率：$pbRatio\n总市值：$totalMarketCap";
  }
}

class StockTxModelExtraState {
  int priceCondition;
  int marketCapCondition;
  int peTtmCondition;
  // List<StockTxModelTag> tagList;

  StockTxModelExtraState({
    int? priceCondition,
    int? marketCapCondition,
    int? peTtmCondition,
    // List<StockTxModelTag>? tagList,
  })  : priceCondition = priceCondition ?? ConditionStatus.none,
        marketCapCondition = marketCapCondition ?? ConditionStatus.none,
        peTtmCondition = peTtmCondition ?? ConditionStatus.none;
  // tagList = tagList ?? [];
}

final Map<String, StockTxModelExtraState> _StockTxModelExtras = {};

StockTxModelExtraState _getExtra(String id) {
  return _StockTxModelExtras.putIfAbsent(id, () => StockTxModelExtraState());
}

extension StockTxModelExt on StockTxModel {
  StockTxModelExtraState get extra => _getExtra(code ?? "0");

  int get priceCondition => extra.priceCondition;
  set priceCondition(int value) => extra.priceCondition = value;

  int get marketCapCondition => extra.marketCapCondition;
  set marketCapCondition(int value) => extra.marketCapCondition = value;

  int get peTtmCondition => extra.peTtmCondition;
  set peTtmCondition(int value) => extra.peTtmCondition = value;

  // List<StockTxModelTag> get tagList => extra.tagList;
  // set tagList(List<StockTxModelTag> value) => extra.tagList = value;

  // String? homeCellShowTagNames() {
  //   return tagList.map((e) => e.name).join(" · ");
  // }

  double? _calcPoint(String? target, String? current) {
    if ((target ?? "").isNotEmpty && (current ?? "").isNotEmpty) {
      return (double.parse(target!) - double.parse(current!)) /
          double.parse(current);
    }
    return null;
  }

  double? pPriceBuyPoints(String? pPriceBuy) =>
      _calcPoint(pPriceBuy, currentPrice);
  double? pMarketCapBuyPoints(
    String? pMarketCapBuy,
  ) =>
      _calcPoint(pMarketCapBuy, totalMarketCap);
  double? pPeTtmBuyPoints(
    String? pPeTtmBuy,
  ) =>
      _calcPoint(pPeTtmBuy, peRatioTtm);

  double? pPriceSalePoints(
    String? pPriceSale,
  ) =>
      _calcPoint(pPriceSale, currentPrice);
  double? pMarketCapSalePoints(
    String? pMarketCapSale,
  ) =>
      _calcPoint(pMarketCapSale, totalMarketCap);
  double? pPeTtmSalePoints(
    String? pPeTtmSale,
  ) =>
      _calcPoint(pPeTtmSale, peRatioTtm);

  void setConditions(
      {String? pPriceBuy,
      String? pMarketCapBuy,
      String? pPeTtmBuy,
      String? pPriceSale,
      String? pMarketCapSale,
      String? pPeTtmSale}) {
    extra.priceCondition = _setVarCondition(
      buyPoint: pPriceBuyPoints(pPriceBuy),
      salePoint: pPriceSalePoints(pPriceSale),
    );
    extra.marketCapCondition = _setVarCondition(
      buyPoint: pMarketCapBuyPoints(pMarketCapBuy),
      salePoint: pMarketCapSalePoints(pMarketCapSale),
    );
    extra.peTtmCondition = _setVarCondition(
      buyPoint: pPeTtmBuyPoints(pPeTtmBuy),
      salePoint: pPeTtmSalePoints(pPeTtmSale),
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

    append(extra.priceCondition, TextKey.stockCellP.tr);
    append(extra.marketCapCondition, TextKey.stockCellM.tr);
    append(extra.peTtmCondition, TextKey.stockCellPe.tr);

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
    return _matchCondition(extra.priceCondition, status) ||
        _matchCondition(extra.marketCapCondition, status) ||
        _matchCondition(extra.peTtmCondition, status);
  }

  bool homeConditionNear(int status) {
    return _matchCondition(extra.priceCondition, status) ||
        _matchCondition(extra.marketCapCondition, status) ||
        _matchCondition(extra.peTtmCondition, status);
  }
}
