import 'package:stock_notes/common/database/database.dart';

extension StockTradeExt on StockTrade {
  bool get isCompleted {
    final open = double.tryParse(openShares ?? '');
    final close = double.tryParse(closeShares ?? '');
    return open != null && close != null && open > 0 && open == close;
  }
}

/// Pure calculation used by trade UI controllers.
/// Returns the estimated yield rate and, when [openShares] is valid, the profit.
/// [tradeType] 0=buy (买 / long), 1=sell (short).
/// For long: open is the buy, close is the sell.
/// For short: open is the sell, close is the buy/cover.
/// When [openShares] equals [closeShares] and [closePrice] is valid, profit is
/// realized using the actual close price; otherwise it uses [currentPrice] for
/// unrealized profit.
({double? yieldRate, double? profit}) calculateTradeEstimateFromValues({
  required String? currentPrice,
  required String? openPrice,
  required String? closePrice,
  required String? openShares,
  required String? closeShares,
  required int tradeType,
}) {
  if (currentPrice == null ||
      currentPrice.isEmpty ||
      openPrice == null ||
      openPrice.isEmpty) {
    return (yieldRate: null, profit: null);
  }

  final current = double.tryParse(currentPrice);
  final open = double.tryParse(openPrice);
  if (current == null || open == null || open == 0) {
    return (yieldRate: null, profit: null);
  }

  final isShort = tradeType == 1; // 卖 = 先卖后买
  final openCount = double.tryParse(openShares ?? '');
  final closeCount = double.tryParse(closeShares ?? '');
  final hasClose = closePrice != null && closePrice.isNotEmpty;
  final close = hasClose ? double.tryParse(closePrice) : null;
  final isCompleted = openCount != null &&
      openCount > 0 &&
      closeCount != null &&
      closeCount > 0 &&
      openCount == closeCount &&
      close != null;

  final yieldRate = isCompleted
      ? (isShort ? (open - close) / open : (close - open) / open)
      : (isShort ? (open - current) / open : (current - open) / open);

  double? profit;

  if (openCount != null && openCount > 0) {
    if (closeCount != null &&
        closeCount > 0 &&
        openCount == closeCount &&
        close != null) {
      profit =
          isShort ? (open - close) * openCount : (close - open) * openCount;
    } else {
      profit =
          isShort ? (open - current) * openCount : (current - open) * openCount;
    }
  }

  return (yieldRate: yieldRate, profit: profit);
}

enum TradeMeetStatus { none, b, s, bs }

extension StockTradeConditionExt on StockTrade {
  TradeMeetStatus meetStatus(String? currentPrice) {
    final current = double.tryParse(currentPrice ?? '');
    final planBuy = double.tryParse(planBuyPrice ?? '');
    final planSale = double.tryParse(planSalePrice ?? '');

    if (current == null) return TradeMeetStatus.none;

    bool meetB = false;
    bool meetS = false;

    // B = current reached the planned buy price (below or equal).
    // S = current reached the planned sale price (above or equal).
    // This matches the stock-level B/S semantics and makes take-profit on
    // a long position show S, not B.
    if (planBuy != null && current <= planBuy) meetB = true;
    if (planSale != null && current >= planSale) meetS = true;

    if (meetB && meetS) return TradeMeetStatus.bs;
    if (meetB) return TradeMeetStatus.b;
    if (meetS) return TradeMeetStatus.s;
    return TradeMeetStatus.none;
  }
}
