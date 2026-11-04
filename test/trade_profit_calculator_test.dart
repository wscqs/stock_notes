import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/https/stock_kline_service.dart';
import 'package:stock_notes/common/model/trade_profit_calculator.dart';

void main() {
  final dates = [
    DateTime(2026, 1, 1),
    DateTime(2026, 1, 2),
    DateTime(2026, 1, 3)
  ];
  List<StockDailyClose> closes(List<double> values) => [
        for (var i = 0; i < values.length; i++)
          StockDailyClose(dates[i], values[i])
      ];

  test('long uses open-day adjusted close and latest drawdown', () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '10',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([10, 16, 12]));
    expect(result.points.map((p) => p.profit), [0, 600, 200]);
    expect(result.maxDrawdown, 400);
    expect(result.points.last.yieldRate, closeTo(.2, 0.00001));
  });

  test('short reverses price direction', () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '10',
        openShares: '100',
        tradeType: 1,
        dailyCloses: closes([10, 8, 9]));
    expect(result.points.map((p) => p.profit), [0, 200, 100]);
    expect(result.maxDrawdown, 100);
  });

  test('drawdown is zero when trade has never been profitable', () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '10',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([10, 8, 9]));
    expect(result.maxDrawdown, 0);
  });

  test('completed final point uses actual close price', () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '10',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([8, 12, 9.6]),
        actualClosePrice: '13');
    expect(result.points.last.profit, 300);
    expect(result.points[1].profit, 200);
    expect(result.maxDrawdown, 0);
  });

  test('invalid shares and empty history produce no points', () {
    expect(
        TradeProfitCalculator.calculate(
            openPrice: '10',
            openShares: '0',
            tradeType: 0,
            dailyCloses: closes([10])).points,
        isEmpty);
    expect(
        TradeProfitCalculator.calculate(
            openPrice: '10',
            openShares: '100',
            tradeType: 0,
            dailyCloses: const []).points,
        isEmpty);
  });

  test('missing current price keeps the latest kline point', () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '10',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([10, 16, 12]),
        latestPrice: '');
    expect(result.points.last.profit, 200);
  });

  test(
      'latest-point rate uses actual open price even when baseline is adjusted',
      () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '25',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([20, 22]),
        latestPrice: '24');
    // profit = -100; yieldRate must be -4%, not -20% from adjusted baseline 20.
    expect(result.points.last.profit, -100);
    expect(result.points.last.yieldRate, closeTo(-0.04, 0.000001));
  });

  test('adjusted history and realtime endpoint share the same yield baseline',
      () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '25',
        openShares: '100',
        tradeType: 0,
        dailyCloses: closes([20, 16, 19]),
        latestPrice: '23.75');
    expect(result.points.map((point) => point.yieldRate), [
      closeTo(-0.20, 0.000001),
      closeTo(-0.36, 0.000001),
      closeTo(-0.05, 0.000001)
    ]);
    expect(result.points[1].profit, closeTo(-900, 0.000001));
  });

  test('Jianghuai history and current price stay on the same adjusted scale',
      () {
    final result = TradeProfitCalculator.calculate(
        openPrice: '19.886',
        openShares: '1500',
        tradeType: 0,
        dailyCloses: [
          StockDailyClose(DateTime(2026, 9, 30), 27.47),
          StockDailyClose(DateTime(2026, 11, 3), 18.12),
        ],
        latestPrice: '18.62',
        latestDate: DateTime(2026, 11, 4));
    expect(result.points.first.profit, closeTo(11376, 0.000001));
    expect(result.points, hasLength(3));
    expect(result.points.last.date, DateTime(2026, 11, 4));
    expect(result.points[1].yieldRate, closeTo(-0.08880674, 0.000001));
    expect(result.points.last.yieldRate, closeTo(-0.06366288, 0.000001));
  });
}
