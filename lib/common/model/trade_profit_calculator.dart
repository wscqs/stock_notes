import 'dart:math' as math;

import 'package:stock_notes/common/https/stock_kline_service.dart';

class TradeProfitPoint {
  final DateTime date;
  final double profit;
  final double yieldRate;
  final double dailyClose;
  const TradeProfitPoint(
      this.date, this.profit, this.yieldRate, this.dailyClose);
}

class TradeProfitSeries {
  final List<TradeProfitPoint> points;
  final double maxDrawdown;
  const TradeProfitSeries(this.points, this.maxDrawdown);
}

class TradeProfitCalculator {
  static TradeProfitSeries calculate({
    required String? openPrice,
    required String? openShares,
    required int tradeType,
    required List<StockDailyClose> dailyCloses,
    String? actualClosePrice,
    String? latestPrice,
    DateTime? latestDate,
  }) {
    final shares = double.tryParse(openShares ?? '');
    if (shares == null || shares <= 0 || dailyCloses.isEmpty) {
      return const TradeProfitSeries([], 0);
    }
    final baseline = dailyCloses.first.close;
    final rawOpen = double.tryParse(openPrice ?? '');
    if (baseline <= 0 || rawOpen == null || rawOpen <= 0) {
      return const TradeProfitSeries([], 0);
    }
    final closeOverride = double.tryParse(actualClosePrice ?? '');
    final values = dailyCloses.map((day) => day.close).toList();
    final pointDates = dailyCloses.map((day) => day.date).toList();
    final latestOverride = double.tryParse(latestPrice ?? '');
    final latestValue = closeOverride == null || closeOverride <= 0
        ? latestOverride
        : closeOverride;
    var lastProfitOverride = latestValue == null || latestValue <= 0
        ? null
        : (latestValue - rawOpen) * shares;
    if (lastProfitOverride != null && !lastProfitOverride.isFinite) {
      lastProfitOverride = null;
    }
    if (lastProfitOverride != null &&
        latestDate != null &&
        pointDates.isNotEmpty &&
        latestDate.isAfter(pointDates.last)) {
      values.add(latestValue!);
      pointDates.add(latestDate);
    }
    final direction = tradeType == 1 ? -1.0 : 1.0;
    final points = <TradeProfitPoint>[];
    for (var i = 0; i < values.length; i++) {
      final difference = (values[i] - rawOpen) * direction;
      final profit = i == values.length - 1 && lastProfitOverride != null
          ? lastProfitOverride * direction
          : difference * shares;
      points.add(TradeProfitPoint(
          pointDates[i], profit, profit / shares / rawOpen, values[i]));
    }
    final hasProfit = points.skip(1).any((point) => point.profit > 0);
    final peak = hasProfit
        ? points.skip(1).map((point) => point.profit).reduce(math.max)
        : points.last.profit;
    final drawdown = math.max(0.0, peak - points.last.profit);
    return TradeProfitSeries(points, drawdown);
  }
}
