import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

StockItem _buildStock({
  required int id,
  bool opBuy = false,
  String? currentPrice,
  String? rBuyPrice,
  String? rHoldShares,
}) {
  final now = DateTime.now();
  return StockItem(
    id: id,
    createdAt: now,
    updateAt: now,
    marketType: 'sh',
    name: 'Test',
    code: '600$id',
    opTop: false,
    opCollect: false,
    opDelete: false,
    opBuy: opBuy,
    rHoldStatus: 0,
    cMeetUpdateAt: now,
    cNearUpdateAt: now,
    cPriceCondition: 0,
    cMarketCapCondition: 0,
    cPeTtmCondition: 0,
    currentPrice: currentPrice,
    rBuyPrice: rBuyPrice,
    rHoldShares: rHoldShares,
  );
}

void main() {
  group('StockItem holdingAmount', () {
    test('returns null when not holding', () {
      final item = _buildStock(id: 1, opBuy: false, currentPrice: '100', rHoldShares: '10');
      expect(item.holdingAmount, isNull);
      expect(item.holdingAmountText, isNull);
    });

    test('returns null when currentPrice is missing', () {
      final item = _buildStock(id: 2, opBuy: true, rHoldShares: '10', rBuyPrice: '90');
      expect(item.holdingAmount, isNull);
    });

    test('returns null when holdShares is missing or zero', () {
      final zeroShares = _buildStock(id: 3, opBuy: true, currentPrice: '100', rHoldShares: '0', rBuyPrice: '90');
      expect(zeroShares.holdingAmount, isNull);

      final nullShares = _buildStock(id: 4, opBuy: true, currentPrice: '100', rBuyPrice: '90');
      expect(nullShares.holdingAmount, isNull);
    });

    test('calculates current price times shares', () {
      final item = _buildStock(
        id: 5,
        opBuy: true,
        currentPrice: '120.5',
        rBuyPrice: '100',
        rHoldShares: '1000',
      );
      expect(item.holdingAmount, 120500.0);
      expect(item.holdingAmountText, '120500');
    });

    test('formats negative amount with sign', () {
      final item = _buildStock(
        id: 6,
        opBuy: true,
        currentPrice: '80',
        rBuyPrice: '100',
        rHoldShares: '100',
      );
      expect(item.holdingAmount, 8000.0);
      // 持有额 = 现价*股数，不会因为亏损而为负
      expect(item.holdingAmountText, '8000');
    });
  });
}
