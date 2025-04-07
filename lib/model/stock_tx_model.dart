/// market_type : "1"
/// name : "青山纸业"
/// code : "sh600103"
/// current_price : "2.21"
/// pe_ratio_ttm : "42.27"
/// total_market_cap : "49.80"
/// pb_ratio : "1.27"

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
