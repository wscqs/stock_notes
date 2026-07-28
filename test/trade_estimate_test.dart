import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';

void main() {
  group('calculateTradeEstimateFromValues', () {
    test('做多未平仓按当前价计算浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('做多已平仓按实际价差计算', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '10',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(150.0, 0.0001));
    });

    test('做空未平仓按当前价计算浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '90',
        openPrice: '100',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.10, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('做空已平仓按实际价差计算', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '95',
        openPrice: '100',
        closePrice: '90',
        openShares: '10',
        closeShares: '10',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.05, 0.0001));
      expect(result.profit, closeTo(100.0, 0.0001));
    });

    test('开仓价无效返回 null', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '100',
        openPrice: '',
        closePrice: null,
        openShares: '10',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, isNull);
      expect(result.profit, isNull);
    });

    test('股数不一致按当前价浮盈', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '5',
        tradeType: 0,
      );
      expect(result.profit, closeTo(100.0, 0.0001));
    });
  });
}
