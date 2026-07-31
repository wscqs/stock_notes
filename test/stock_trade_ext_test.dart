import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';

void main() {
  final base = StockTrade(
    id: 1,
    createdAt: DateTime(2026, 7, 27),
    updateAt: DateTime(2026, 7, 27),
    stockId: 1,
    tradeType: 0,
    openPrice: '100',
    openShares: '10',
    planBuyPrice: '90',
    planSalePrice: '110',
    tradeDate: DateTime(2026, 7, 27),
  );

  StockTrade buildTrade({
    required int tradeType,
    String? planBuyPrice,
    String? planSalePrice,
  }) {
    return base.copyWith(
      tradeType: tradeType,
      planBuyPrice: planBuyPrice == null
          ? const Value.absent()
          : Value(planBuyPrice),
      planSalePrice: planSalePrice == null
          ? const Value.absent()
          : Value(planSalePrice),
    );
  }

  test('buy long: current >= planSalePrice returns s', () {
    final trade = buildTrade(
      tradeType: 0,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus('115'), TradeMeetStatus.s);
  });

  test('buy long: current <= planBuyPrice returns b', () {
    final trade = buildTrade(
      tradeType: 0,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus('85'), TradeMeetStatus.b);
  });

  test('buy long: both conditions returns bs', () {
    final trade = buildTrade(
      tradeType: 0,
      planBuyPrice: '110',
      planSalePrice: '90',
    );
    expect(trade.meetStatus('100'), TradeMeetStatus.bs);
  });

  test('sell short: current <= planBuyPrice returns b', () {
    final trade = buildTrade(
      tradeType: 1,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus('85'), TradeMeetStatus.b);
  });

  test('sell short: current >= planSalePrice returns s', () {
    final trade = buildTrade(
      tradeType: 1,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus('115'), TradeMeetStatus.s);
  });

  test('sell short: both conditions returns bs', () {
    final trade = buildTrade(
      tradeType: 1,
      planBuyPrice: '110',
      planSalePrice: '90',
    );
    expect(trade.meetStatus('100'), TradeMeetStatus.bs);
  });

  test('returns none when currentPrice is invalid', () {
    final trade = buildTrade(
      tradeType: 0,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus(null), TradeMeetStatus.none);
    expect(trade.meetStatus(''), TradeMeetStatus.none);
    expect(trade.meetStatus('abc'), TradeMeetStatus.none);
  });

  test('returns none when plan prices are missing', () {
    final trade = buildTrade(tradeType: 0);
    expect(trade.meetStatus('100'), TradeMeetStatus.none);
  });

  test('buy long: current below planSalePrice and no planBuy returns none', () {
    final trade = StockTrade(
      id: 1,
      createdAt: DateTime(2026, 7, 27),
      updateAt: DateTime(2026, 7, 27),
      stockId: 1,
      tradeType: 0,
      openPrice: '100',
      openShares: '10',
      planSalePrice: '23',
      tradeDate: DateTime(2026, 7, 27),
    );
    expect(trade.meetStatus('12.56'), TradeMeetStatus.none);
  });

  test('returns none when neither condition is met', () {
    final trade = buildTrade(
      tradeType: 0,
      planBuyPrice: '90',
      planSalePrice: '110',
    );
    expect(trade.meetStatus('100'), TradeMeetStatus.none);
  });
}
