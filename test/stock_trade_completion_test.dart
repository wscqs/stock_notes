import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';

void main() {
  group('isTradeCompleted', () {
    test('returns false when openShares or closeShares is null/empty', () {
      expect(_trade(openShares: null, closeShares: null).isCompleted, isFalse);
      expect(_trade(openShares: '100', closeShares: null).isCompleted, isFalse);
      expect(_trade(openShares: '100', closeShares: '').isCompleted, isFalse);
    });

    test('returns false when openShares != closeShares', () {
      expect(_trade(openShares: '100', closeShares: '50').isCompleted, isFalse);
    });

    test('returns true when openShares == closeShares and both > 0', () {
      expect(_trade(openShares: '100', closeShares: '100').isCompleted, isTrue);
    });

    test('returns false when shares are zero', () {
      expect(_trade(openShares: '0', closeShares: '0').isCompleted, isFalse);
    });
  });
}

StockTrade _trade({String? openShares, String? closeShares}) {
  final now = DateTime.now();
  return StockTrade(
    id: 1,
    createdAt: now,
    updateAt: now,
    stockId: 1,
    tradeType: 0,
    openPrice: '10',
    openShares: openShares,
    closePrice: null,
    closeShares: closeShares,
    tradeDate: now,
  );
}
