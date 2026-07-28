import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/app/modules/stockedit/controllers/stockedit_controller.dart';

void main() {
  group('calculateTradeEstimateFromValues', () {
    test('null/empty current price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: null,
          openPrice: '10',
          closePrice: null,
          openShares: '100',
          closeShares: null,
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '',
          openPrice: '10',
          closePrice: null,
          openShares: '100',
          closeShares: null,
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test('null/empty open price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          openPrice: null,
          closePrice: null,
          openShares: '100',
          closeShares: null,
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          openPrice: '',
          closePrice: null,
          openShares: '100',
          closeShares: null,
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test('zero open price returns (null, null)', () {
      expect(
        calculateTradeEstimateFromValues(
          currentPrice: '12',
          openPrice: '0',
          closePrice: null,
          openShares: '100',
          closeShares: null,
          tradeType: 0,
        ),
        (yieldRate: null, profit: null),
      );
    });

    test(
        'valid current price and open price compute correct yield rate for buy',
        () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        openPrice: '10',
        closePrice: null,
        openShares: null,
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.2, 1e-10));
      expect(result.profit, isNull);
    });

    test('valid shares compute correct profit for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        openPrice: '10',
        closePrice: null,
        openShares: '100',
        closeShares: null,
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
          openPrice: '10',
          closePrice: null,
          openShares: shares,
          closeShares: null,
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.2, 1e-10),
            reason: 'shares = $shares');
        expect(result.profit, isNull, reason: 'shares = $shares');
      }
    });

    test('negative yield rate when current price < open price for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '8',
        openPrice: '10',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(-0.2, 1e-10));
      expect(result.profit, closeTo(-200, 1e-10));
    });

    test('zero yield rate when current price == open price for buy', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        openPrice: '10',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.0, 1e-10));
      expect(result.profit, closeTo(0.0, 1e-10));
    });

    test('short trade computes profit as (open price - current price) * shares',
        () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        openPrice: '12',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.profit, closeTo(200, 1e-10));
    });

    test('short trade computes yield rate relative to open price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        openPrice: '12',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(2 / 12, 1e-10));
    });

    test('short trade shows loss when current price > open price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '12',
        openPrice: '10',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(-0.2, 1e-10));
      expect(result.profit, closeTo(-200, 1e-10));
    });

    test('short trade shows zero when current price == open price', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '10',
        openPrice: '10',
        closePrice: null,
        openShares: '100',
        closeShares: null,
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.0, 1e-10));
      expect(result.profit, closeTo(0.0, 1e-10));
    });

    test('closed long trade uses close price for profit', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '10',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.1, 1e-10));
      expect(result.profit, closeTo(150, 1e-10));
    });

    test('closed short trade uses close price for profit', () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '95',
        openPrice: '100',
        closePrice: '90',
        openShares: '10',
        closeShares: '10',
        tradeType: 1,
      );
      expect(result.yieldRate, closeTo(0.05, 1e-10));
      expect(result.profit, closeTo(100, 1e-10));
    });

    test('mismatched close shares falls back to current-price unrealized P&L',
        () {
      final result = calculateTradeEstimateFromValues(
        currentPrice: '110',
        openPrice: '100',
        closePrice: '115',
        openShares: '10',
        closeShares: '5',
        tradeType: 0,
      );
      expect(result.yieldRate, closeTo(0.1, 1e-10));
      expect(result.profit, closeTo(100.0, 1e-10));
    });

    group('close price edge cases fall back to current-price unrealized P&L', () {
      test('close price provided but close shares is null', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: '115',
          openShares: '10',
          closeShares: null,
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, closeTo(100.0, 1e-10));
      });

      test('close price provided but close shares is empty', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: '115',
          openShares: '10',
          closeShares: '',
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, closeTo(100.0, 1e-10));
      });

      test('close shares equals open shares but close price is empty', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: '',
          openShares: '10',
          closeShares: '10',
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, closeTo(100.0, 1e-10));
      });

      test('close price is unparseable', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: 'abc',
          openShares: '10',
          closeShares: '10',
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, closeTo(100.0, 1e-10));
      });
    });

    group('zero or negative open shares result in null profit', () {
      test('zero open shares', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: null,
          openShares: '0',
          closeShares: null,
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, isNull);
      });

      test('negative open shares', () {
        final result = calculateTradeEstimateFromValues(
          currentPrice: '110',
          openPrice: '100',
          closePrice: null,
          openShares: '-10',
          closeShares: null,
          tradeType: 0,
        );
        expect(result.yieldRate, closeTo(0.1, 1e-10));
        expect(result.profit, isNull);
      });
    });
  });
}
