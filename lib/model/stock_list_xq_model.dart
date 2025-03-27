/// items : [{"market":{"status_id":1,"region":"CN","status":"未开盘","time_zone":"Asia/Shanghai","time_zone_desc":null,"delay_tag":0},"quote":{"symbol":"SZ000001","code":"000001","exchange":"SZ","name":"平安银行","type":11,"sub_type":"1","status":1,"current":11.49,"currency":"CNY","percent":-0.09,"chg":-0.01,"timestamp":1742281479000,"time":1742281479000,"lot_size":100,"tick_size":0.01,"open":11.52,"last_close":11.5,"high":11.54,"low":11.48,"avg_price":11.503,"volume":160529000,"amount":1846500421.28,"turnover_rate":0.83,"amplitude":0.52,"market_capital":222974000095,"float_market_capital":222970020557,"total_shares":19405918198,"float_shares":19405571850,"issue_date":670608000000,"lock_set":null,"current_year_percent":-1.79,"high52w":13.1473,"low52w":9.1745,"limit_up":12.65,"limit_down":10.35,"volume_ratio":0.79,"eps":2.29,"pe_ttm":5.01,"pe_forecast":5.01,"pe_lyr":5.01,"navps":21.89,"pb":0.525,"dividend":0.965,"dividend_yield":8.399,"profit":44508000000,"profit_four":44508000000,"profit_forecast":44508000000,"pledge_ratio":0.04,"goodwill_in_net_assets":1.52937705368582,"timestamp_ext":null,"current_ext":null,"volume_ext":null,"traded_amount_ext":null,"no_profit":"N","no_profit_desc":"已盈利","weighted_voting_rights":"N","weighted_voting_rights_desc":"无差异","is_registration":"N","is_registration_desc":"否","is_vie":"N","is_vie_desc":"否","security_status":null},"others":{"cyb_switch":true},"tags":["CNY"]},{"market":{"status_id":1,"region":"CN","status":"未开盘","time_zone":"Asia/Shanghai","time_zone_desc":null,"delay_tag":0},"quote":{"symbol":"SZ399001","code":"399001","exchange":"SZ","name":"深证成指","type":12,"sub_type":null,"status":1,"current":11014.75,"currency":"CNY","percent":0.52,"chg":56.93,"timestamp":1742281479000,"time":1742281479000,"lot_size":100,"tick_size":0.01,"open":10999.32,"last_close":10957.82,"high":11041.41,"low":10958.87,"avg_price":11014.75,"volume":67026091831,"amount":933349997313,"turnover_rate":2.88,"amplitude":0.75,"market_capital":36077671538083.1,"float_market_capital":10718549912440.8,"total_shares":3275396312,"float_shares":2328796761105,"issue_date":774633600000,"lock_set":null,"current_year_percent":5.76,"high52w":11864.11,"low52w":7908.52,"rise_count":1634,"flat_count":125,"fall_count":1137,"volume_ratio":0.93},"others":{"cyb_switch":true},"tags":["CNY"]}]
/// items_size : 2

class StockListXqModel {
  StockListXqModel({
    this.items,
    this.itemsSize,
  });

  StockListXqModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    itemsSize = json['items_size'];
  }
  List<Items>? items;
  int? itemsSize;
  StockListXqModel copyWith({
    List<Items>? items,
    int? itemsSize,
  }) =>
      StockListXqModel(
        items: items ?? this.items,
        itemsSize: itemsSize ?? this.itemsSize,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['items_size'] = itemsSize;
    return map;
  }
}

/// market : {"status_id":1,"region":"CN","status":"未开盘","time_zone":"Asia/Shanghai","time_zone_desc":null,"delay_tag":0}
/// quote : {"symbol":"SZ000001","code":"000001","exchange":"SZ","name":"平安银行","type":11,"sub_type":"1","status":1,"current":11.49,"currency":"CNY","percent":-0.09,"chg":-0.01,"timestamp":1742281479000,"time":1742281479000,"lot_size":100,"tick_size":0.01,"open":11.52,"last_close":11.5,"high":11.54,"low":11.48,"avg_price":11.503,"volume":160529000,"amount":1846500421.28,"turnover_rate":0.83,"amplitude":0.52,"market_capital":222974000095,"float_market_capital":222970020557,"total_shares":19405918198,"float_shares":19405571850,"issue_date":670608000000,"lock_set":null,"current_year_percent":-1.79,"high52w":13.1473,"low52w":9.1745,"limit_up":12.65,"limit_down":10.35,"volume_ratio":0.79,"eps":2.29,"pe_ttm":5.01,"pe_forecast":5.01,"pe_lyr":5.01,"navps":21.89,"pb":0.525,"dividend":0.965,"dividend_yield":8.399,"profit":44508000000,"profit_four":44508000000,"profit_forecast":44508000000,"pledge_ratio":0.04,"goodwill_in_net_assets":1.52937705368582,"timestamp_ext":null,"current_ext":null,"volume_ext":null,"traded_amount_ext":null,"no_profit":"N","no_profit_desc":"已盈利","weighted_voting_rights":"N","weighted_voting_rights_desc":"无差异","is_registration":"N","is_registration_desc":"否","is_vie":"N","is_vie_desc":"否","security_status":null}
/// others : {"cyb_switch":true}
/// tags : ["CNY"]

class Items {
  Items({
    this.market,
    this.quote,
    this.others,
    this.tags,
  });

  Items.fromJson(dynamic json) {
    market = json['market'] != null ? Market.fromJson(json['market']) : null;
    quote = json['quote'] != null ? Quote.fromJson(json['quote']) : null;
    others = json['others'] != null ? Others.fromJson(json['others']) : null;
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
  }
  Market? market;
  Quote? quote;
  Others? others;
  List<String>? tags;
  Items copyWith({
    Market? market,
    Quote? quote,
    Others? others,
    List<String>? tags,
  }) =>
      Items(
        market: market ?? this.market,
        quote: quote ?? this.quote,
        others: others ?? this.others,
        tags: tags ?? this.tags,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (market != null) {
      map['market'] = market?.toJson();
    }
    if (quote != null) {
      map['quote'] = quote?.toJson();
    }
    if (others != null) {
      map['others'] = others?.toJson();
    }
    map['tags'] = tags;
    return map;
  }
}

/// cyb_switch : true

class Others {
  Others({
    this.cybSwitch,
  });

  Others.fromJson(dynamic json) {
    cybSwitch = json['cyb_switch'];
  }
  bool? cybSwitch;
  Others copyWith({
    bool? cybSwitch,
  }) =>
      Others(
        cybSwitch: cybSwitch ?? this.cybSwitch,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cyb_switch'] = cybSwitch;
    return map;
  }
}

/// symbol : "SZ000001"
/// code : "000001"
/// exchange : "SZ"
/// name : "平安银行"
/// type : 11
/// sub_type : "1"
/// status : 1
/// current : 11.49
/// currency : "CNY"
/// percent : -0.09
/// chg : -0.01
/// timestamp : 1742281479000
/// time : 1742281479000
/// lot_size : 100
/// tick_size : 0.01
/// open : 11.52
/// last_close : 11.5
/// high : 11.54
/// low : 11.48
/// avg_price : 11.503
/// volume : 160529000
/// amount : 1846500421.28
/// turnover_rate : 0.83
/// amplitude : 0.52
/// market_capital : 222974000095
/// float_market_capital : 222970020557
/// total_shares : 19405918198
/// float_shares : 19405571850
/// issue_date : 670608000000
/// lock_set : null
/// current_year_percent : -1.79
/// high52w : 13.1473
/// low52w : 9.1745
/// limit_up : 12.65
/// limit_down : 10.35
/// volume_ratio : 0.79
/// eps : 2.29
/// pe_ttm : 5.01
/// pe_forecast : 5.01
/// pe_lyr : 5.01
/// navps : 21.89
/// pb : 0.525
/// dividend : 0.965
/// dividend_yield : 8.399
/// profit : 44508000000
/// profit_four : 44508000000
/// profit_forecast : 44508000000
/// pledge_ratio : 0.04
/// goodwill_in_net_assets : 1.52937705368582
/// timestamp_ext : null
/// current_ext : null
/// volume_ext : null
/// traded_amount_ext : null
/// no_profit : "N"
/// no_profit_desc : "已盈利"
/// weighted_voting_rights : "N"
/// weighted_voting_rights_desc : "无差异"
/// is_registration : "N"
/// is_registration_desc : "否"
/// is_vie : "N"
/// is_vie_desc : "否"
/// security_status : null

class Quote {
  Quote({
    this.symbol,
    this.code,
    this.exchange,
    this.name,
    this.type,
    this.subType,
    this.status,
    this.current,
    this.currency,
    this.percent,
    this.chg,
    this.timestamp,
    this.time,
    this.lotSize,
    this.tickSize,
    this.open,
    this.lastClose,
    this.high,
    this.low,
    this.avgPrice,
    this.volume,
    this.amount,
    this.turnoverRate,
    this.amplitude,
    this.marketCapital,
    this.floatMarketCapital,
    this.totalShares,
    this.floatShares,
    this.issueDate,
    this.lockSet,
    this.currentYearPercent,
    this.high52w,
    this.low52w,
    this.limitUp,
    this.limitDown,
    this.volumeRatio,
    this.eps,
    this.peTtm,
    this.peForecast,
    this.peLyr,
    this.navps,
    this.pb,
    this.dividend,
    this.dividendYield,
    this.profit,
    this.profitFour,
    this.profitForecast,
    this.pledgeRatio,
    this.goodwillInNetAssets,
    this.timestampExt,
    this.currentExt,
    this.volumeExt,
    this.tradedAmountExt,
    this.noProfit,
    this.noProfitDesc,
    this.weightedVotingRights,
    this.weightedVotingRightsDesc,
    this.isRegistration,
    this.isRegistrationDesc,
    this.isVie,
    this.isVieDesc,
    this.securityStatus,
  });

  Quote.fromJson(dynamic json) {
    symbol = json['symbol'];
    code = json['code'];
    exchange = json['exchange'];
    name = json['name'];
    type = json['type'];
    subType = json['sub_type'];
    status = json['status'];
    current = json['current'];
    currency = json['currency'];
    percent = json['percent'];
    chg = json['chg'];
    timestamp = json['timestamp'];
    time = json['time'];
    lotSize = json['lot_size'];
    tickSize = json['tick_size'];
    open = json['open'];
    lastClose = json['last_close'];
    high = json['high'];
    low = json['low'];
    avgPrice = json['avg_price'];
    volume = json['volume'];
    amount = json['amount'];
    turnoverRate = json['turnover_rate'];
    amplitude = json['amplitude'];
    marketCapital = json['market_capital'];
    floatMarketCapital = json['float_market_capital'];
    totalShares = json['total_shares'];
    floatShares = json['float_shares'];
    issueDate = json['issue_date'];
    lockSet = json['lock_set'];
    currentYearPercent = json['current_year_percent'];
    high52w = json['high52w'];
    low52w = json['low52w'];
    limitUp = json['limit_up'];
    limitDown = json['limit_down'];
    volumeRatio = json['volume_ratio'];
    eps = json['eps'];
    peTtm = json['pe_ttm'];
    peForecast = json['pe_forecast'];
    peLyr = json['pe_lyr'];
    navps = json['navps'];
    pb = json['pb'];
    dividend = json['dividend'];
    dividendYield = json['dividend_yield'];
    profit = json['profit'];
    profitFour = json['profit_four'];
    profitForecast = json['profit_forecast'];
    pledgeRatio = json['pledge_ratio'];
    goodwillInNetAssets = json['goodwill_in_net_assets'];
    timestampExt = json['timestamp_ext'];
    currentExt = json['current_ext'];
    volumeExt = json['volume_ext'];
    tradedAmountExt = json['traded_amount_ext'];
    noProfit = json['no_profit'];
    noProfitDesc = json['no_profit_desc'];
    weightedVotingRights = json['weighted_voting_rights'];
    weightedVotingRightsDesc = json['weighted_voting_rights_desc'];
    isRegistration = json['is_registration'];
    isRegistrationDesc = json['is_registration_desc'];
    isVie = json['is_vie'];
    isVieDesc = json['is_vie_desc'];
    securityStatus = json['security_status'];
  }
  String? symbol;
  String? code;
  String? exchange;
  String? name;
  int? type;
  String? subType;
  int? status;
  double? current;
  String? currency;
  double? percent;
  double? chg;
  int? timestamp;
  int? time;
  int? lotSize;
  double? tickSize;
  double? open;
  double? lastClose;
  double? high;
  double? low;
  double? avgPrice;
  int? volume;
  double? amount;
  double? turnoverRate;
  double? amplitude;
  int? marketCapital;
  int? floatMarketCapital;
  int? totalShares;
  int? floatShares;
  int? issueDate;
  dynamic lockSet;
  double? currentYearPercent;
  double? high52w;
  double? low52w;
  double? limitUp;
  double? limitDown;
  double? volumeRatio;
  double? eps;
  double? peTtm;
  double? peForecast;
  double? peLyr;
  double? navps;
  double? pb;
  double? dividend;
  double? dividendYield;
  int? profit;
  int? profitFour;
  int? profitForecast;
  double? pledgeRatio;
  double? goodwillInNetAssets;
  dynamic timestampExt;
  dynamic currentExt;
  dynamic volumeExt;
  dynamic tradedAmountExt;
  String? noProfit;
  String? noProfitDesc;
  String? weightedVotingRights;
  String? weightedVotingRightsDesc;
  String? isRegistration;
  String? isRegistrationDesc;
  String? isVie;
  String? isVieDesc;
  dynamic securityStatus;
  Quote copyWith({
    String? symbol,
    String? code,
    String? exchange,
    String? name,
    int? type,
    String? subType,
    int? status,
    double? current,
    String? currency,
    double? percent,
    double? chg,
    int? timestamp,
    int? time,
    int? lotSize,
    double? tickSize,
    double? open,
    double? lastClose,
    double? high,
    double? low,
    double? avgPrice,
    int? volume,
    double? amount,
    double? turnoverRate,
    double? amplitude,
    int? marketCapital,
    int? floatMarketCapital,
    int? totalShares,
    int? floatShares,
    int? issueDate,
    dynamic lockSet,
    double? currentYearPercent,
    double? high52w,
    double? low52w,
    double? limitUp,
    double? limitDown,
    double? volumeRatio,
    double? eps,
    double? peTtm,
    double? peForecast,
    double? peLyr,
    double? navps,
    double? pb,
    double? dividend,
    double? dividendYield,
    int? profit,
    int? profitFour,
    int? profitForecast,
    double? pledgeRatio,
    double? goodwillInNetAssets,
    dynamic timestampExt,
    dynamic currentExt,
    dynamic volumeExt,
    dynamic tradedAmountExt,
    String? noProfit,
    String? noProfitDesc,
    String? weightedVotingRights,
    String? weightedVotingRightsDesc,
    String? isRegistration,
    String? isRegistrationDesc,
    String? isVie,
    String? isVieDesc,
    dynamic securityStatus,
  }) =>
      Quote(
        symbol: symbol ?? this.symbol,
        code: code ?? this.code,
        exchange: exchange ?? this.exchange,
        name: name ?? this.name,
        type: type ?? this.type,
        subType: subType ?? this.subType,
        status: status ?? this.status,
        current: current ?? this.current,
        currency: currency ?? this.currency,
        percent: percent ?? this.percent,
        chg: chg ?? this.chg,
        timestamp: timestamp ?? this.timestamp,
        time: time ?? this.time,
        lotSize: lotSize ?? this.lotSize,
        tickSize: tickSize ?? this.tickSize,
        open: open ?? this.open,
        lastClose: lastClose ?? this.lastClose,
        high: high ?? this.high,
        low: low ?? this.low,
        avgPrice: avgPrice ?? this.avgPrice,
        volume: volume ?? this.volume,
        amount: amount ?? this.amount,
        turnoverRate: turnoverRate ?? this.turnoverRate,
        amplitude: amplitude ?? this.amplitude,
        marketCapital: marketCapital ?? this.marketCapital,
        floatMarketCapital: floatMarketCapital ?? this.floatMarketCapital,
        totalShares: totalShares ?? this.totalShares,
        floatShares: floatShares ?? this.floatShares,
        issueDate: issueDate ?? this.issueDate,
        lockSet: lockSet ?? this.lockSet,
        currentYearPercent: currentYearPercent ?? this.currentYearPercent,
        high52w: high52w ?? this.high52w,
        low52w: low52w ?? this.low52w,
        limitUp: limitUp ?? this.limitUp,
        limitDown: limitDown ?? this.limitDown,
        volumeRatio: volumeRatio ?? this.volumeRatio,
        eps: eps ?? this.eps,
        peTtm: peTtm ?? this.peTtm,
        peForecast: peForecast ?? this.peForecast,
        peLyr: peLyr ?? this.peLyr,
        navps: navps ?? this.navps,
        pb: pb ?? this.pb,
        dividend: dividend ?? this.dividend,
        dividendYield: dividendYield ?? this.dividendYield,
        profit: profit ?? this.profit,
        profitFour: profitFour ?? this.profitFour,
        profitForecast: profitForecast ?? this.profitForecast,
        pledgeRatio: pledgeRatio ?? this.pledgeRatio,
        goodwillInNetAssets: goodwillInNetAssets ?? this.goodwillInNetAssets,
        timestampExt: timestampExt ?? this.timestampExt,
        currentExt: currentExt ?? this.currentExt,
        volumeExt: volumeExt ?? this.volumeExt,
        tradedAmountExt: tradedAmountExt ?? this.tradedAmountExt,
        noProfit: noProfit ?? this.noProfit,
        noProfitDesc: noProfitDesc ?? this.noProfitDesc,
        weightedVotingRights: weightedVotingRights ?? this.weightedVotingRights,
        weightedVotingRightsDesc:
            weightedVotingRightsDesc ?? this.weightedVotingRightsDesc,
        isRegistration: isRegistration ?? this.isRegistration,
        isRegistrationDesc: isRegistrationDesc ?? this.isRegistrationDesc,
        isVie: isVie ?? this.isVie,
        isVieDesc: isVieDesc ?? this.isVieDesc,
        securityStatus: securityStatus ?? this.securityStatus,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = symbol;
    map['code'] = code;
    map['exchange'] = exchange;
    map['name'] = name;
    map['type'] = type;
    map['sub_type'] = subType;
    map['status'] = status;
    map['current'] = current;
    map['currency'] = currency;
    map['percent'] = percent;
    map['chg'] = chg;
    map['timestamp'] = timestamp;
    map['time'] = time;
    map['lot_size'] = lotSize;
    map['tick_size'] = tickSize;
    map['open'] = open;
    map['last_close'] = lastClose;
    map['high'] = high;
    map['low'] = low;
    map['avg_price'] = avgPrice;
    map['volume'] = volume;
    map['amount'] = amount;
    map['turnover_rate'] = turnoverRate;
    map['amplitude'] = amplitude;
    map['market_capital'] = marketCapital;
    map['float_market_capital'] = floatMarketCapital;
    map['total_shares'] = totalShares;
    map['float_shares'] = floatShares;
    map['issue_date'] = issueDate;
    map['lock_set'] = lockSet;
    map['current_year_percent'] = currentYearPercent;
    map['high52w'] = high52w;
    map['low52w'] = low52w;
    map['limit_up'] = limitUp;
    map['limit_down'] = limitDown;
    map['volume_ratio'] = volumeRatio;
    map['eps'] = eps;
    map['pe_ttm'] = peTtm;
    map['pe_forecast'] = peForecast;
    map['pe_lyr'] = peLyr;
    map['navps'] = navps;
    map['pb'] = pb;
    map['dividend'] = dividend;
    map['dividend_yield'] = dividendYield;
    map['profit'] = profit;
    map['profit_four'] = profitFour;
    map['profit_forecast'] = profitForecast;
    map['pledge_ratio'] = pledgeRatio;
    map['goodwill_in_net_assets'] = goodwillInNetAssets;
    map['timestamp_ext'] = timestampExt;
    map['current_ext'] = currentExt;
    map['volume_ext'] = volumeExt;
    map['traded_amount_ext'] = tradedAmountExt;
    map['no_profit'] = noProfit;
    map['no_profit_desc'] = noProfitDesc;
    map['weighted_voting_rights'] = weightedVotingRights;
    map['weighted_voting_rights_desc'] = weightedVotingRightsDesc;
    map['is_registration'] = isRegistration;
    map['is_registration_desc'] = isRegistrationDesc;
    map['is_vie'] = isVie;
    map['is_vie_desc'] = isVieDesc;
    map['security_status'] = securityStatus;
    return map;
  }
}

/// status_id : 1
/// region : "CN"
/// status : "未开盘"
/// time_zone : "Asia/Shanghai"
/// time_zone_desc : null
/// delay_tag : 0

class Market {
  Market({
    this.statusId,
    this.region,
    this.status,
    this.timeZone,
    this.timeZoneDesc,
    this.delayTag,
  });

  Market.fromJson(dynamic json) {
    statusId = json['status_id'];
    region = json['region'];
    status = json['status'];
    timeZone = json['time_zone'];
    timeZoneDesc = json['time_zone_desc'];
    delayTag = json['delay_tag'];
  }
  int? statusId;
  String? region;
  String? status;
  String? timeZone;
  dynamic timeZoneDesc;
  int? delayTag;
  Market copyWith({
    int? statusId,
    String? region,
    String? status,
    String? timeZone,
    dynamic timeZoneDesc,
    int? delayTag,
  }) =>
      Market(
        statusId: statusId ?? this.statusId,
        region: region ?? this.region,
        status: status ?? this.status,
        timeZone: timeZone ?? this.timeZone,
        timeZoneDesc: timeZoneDesc ?? this.timeZoneDesc,
        delayTag: delayTag ?? this.delayTag,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_id'] = statusId;
    map['region'] = region;
    map['status'] = status;
    map['time_zone'] = timeZone;
    map['time_zone_desc'] = timeZoneDesc;
    map['delay_tag'] = delayTag;
    return map;
  }
}
