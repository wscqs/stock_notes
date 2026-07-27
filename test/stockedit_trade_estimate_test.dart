import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';

void main() {
  group('calculateTradeEstimateFromValues', () {
    test('null/empty current price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: null,
          tradePrice: '10',
          shares: '100',
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '',
          tradePrice: '10',
          shares: '100',
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test('null/empty trade price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          tradePrice: null,
          shares: '100',
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          tradePrice: '',
          shares: '100',
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test('zero trade price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          tradePrice: '0',
          shares: '100',
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test(
        'valid current price and trade price compute correct yield rate for buy',
        () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        tradePrice: '10',
        shares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.2, 1e-10));
      expect(result.profit, isNull);
    });

    test('valid shares compute correct profit for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        tradePrice: '10',
        shares: '100',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.2, 1e-10));
      expect(result.profit, closeTo(200, 1e-10));
    });

    test(
        'missing/invalid shares result in profit null but yield rate computed for buy',
        () {
      for (final shares in [null, '', 'abc']) {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '12',
          tradePrice: '10',
          shares: shares,
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.2, 1e-10),
            reason: 'shares = $shares');
        expect(result.profit, isNull, reason: 'shares = $shares');
      }
    });

    test('negative yield rate when current price < trade price for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '8',
        tradePrice: '10',
        shares: '100',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(-0.2, 1e-10));
      expect(result.profit, closeTo(-200, 1e-10));
    });

    test('zero yield rate when current price == trade price for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        tradePrice: '10',
        shares: '100',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.0, 1e-10));
      expect(result.profit, closeTo(0.0, 1e-10));
    });

    test('sell trade computes profit as (sell price - current price) * shares',
        () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        tradePrice: '12',
        shares: '100',
        tradeType: 1,
      );
      expect(result.profit, closeTo(200, 1e-10));
    });

    test('sell trade computes yield rate relative to current price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        tradePrice: '12',
        shares: '100',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.2, 1e-10));
    });

    test('sell trade shows loss when current price > sell price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        tradePrice: '10',
        shares: '100',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(-1 / 6, 1e-10));
      expect(result.profit, closeTo(-200, 1e-10));
    });

    test('sell trade shows zero when current price == sell price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        tradePrice: '10',
        shares: '100',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.0, 1e-10));
      expect(result.profit, closeTo(0.0, 1e-10));
    });
  });
}
