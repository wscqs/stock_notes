import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/https/stock_kline_service.dart';

void main() {
  final now = DateTime(2026, 11, 4);
  StockItem stock(String market, String code) => StockItem(
      id: 1,
      createdAt: now,
      updateAt: now,
      marketType: market,
      name: 'Test',
      code: code,
      opTop: false,
      opCollect: false,
      opDelete: false,
      opBuy: false,
      cMeetUpdateAt: now,
      cNearUpdateAt: now,
      cPriceCondition: 0,
      cMarketCapCondition: 0,
      cPeTtmCondition: 0,
      rHoldStatus: 0);

  test('parses A-share qfqday and sorts/deduplicates by date', () {
    final rows = StockKlineService.parseDaily({
      'code': 0,
      'data': {
        'sh600900': {
          'qfqday': [
            ['2023-01-04', '10', '11', '12', '9', '100'],
            ['2023-01-03', '9', '10', '11', '8', '100'],
            ['2023-01-04', '10', '11.5', '12', '9', '100'],
          ]
        }
      }
    }, 'sh600900', true);
    expect(rows.map((e) => e.close), [10, 11.5]);
  });

  test('parses Hong Kong day data', () {
    final rows = StockKlineService.parseDaily({
      'code': 0,
      'data': {
        'hk00700': {
          'day': [
            ['2023-01-03', '334', '345.2', '350', '330', '100'],
          ]
        }
      }
    }, 'hk00700', false);
    expect(rows.single.close, 345.2);
  });

  test('requests earlier windows until open date is covered', () async {
    final requested = <String>[];
    String responder(String param) {
      requested.add(param);
      if (param.contains('2023-01-01')) {
        return '{"code":0,"data":{"sh600900":{"qfqday":[["2023-01-03","10","10","10","10","1"]]}}}';
      }
      return '{"code":0,"data":{"sh600900":{"qfqday":[]}}}';
    }

    final service =
        StockKlineService(rawFetcher: (_, param) async => responder(param));
    final rows = await service.fetchDaily(
        stock: stock('sh', '600900'),
        start: DateTime(2023, 1, 1),
        end: DateTime(2023, 1, 10));
    expect(rows.single.close, 10);
    expect(requested, hasLength(1));
  });

  test('rejects unsupported markets without making a request', () async {
    var called = false;
    final service = StockKlineService(rawFetcher: (_, __) async {
      called = true;
      return '{}';
    });
    expect(() => service.fetchDaily(stock: stock('us', 'AAPL'), start: now),
        throwsA(isA<UnsupportedStockMarketException>()));
    expect(called, isFalse);
  });

  test('paginates backwards when the API truncates at 640 rows', () async {
    final requested = <String>[];
    String row(String date, String close) =>
        '["$date","$close","$close","$close","$close","1"]';
    final recentRows = <String>[];
    for (var i = 0; i < 640; i++) {
      final date = DateTime.utc(2023, 1, 4).add(Duration(days: i));
      recentRows.add(row(date.toIso8601String().substring(0, 10), '20'));
    }
    final recent = recentRows.join(',');
    final service = StockKlineService(rawFetcher: (_, param) async {
      requested.add(param);
      if (requested.length == 1) {
        return '{"code":0,"data":{"sh600900":{"qfqday":[$recent]}}}';
      }
      return '{"code":0,"data":{"sh600900":{"qfqday":[["2023-01-03","10","10","10","10","1"]]}}}';
    });
    final rows = await service.fetchDaily(
        stock: stock('sh', '600900'),
        start: DateTime(2023, 1, 1),
        end: DateTime(2024, 10, 4));
    expect(requested, hasLength(2));
    expect(rows.first.close, 10);
  });

  test('uses database market type for prefixed stock codes', () async {
    final service = StockKlineService(
        rawFetcher: (_, param) async =>
            '{"code":0,"data":{"sh600900":{"qfqday":[["2026-01-01","10","10","10","10","1"]]}}}');
    final rows = await service.fetchDaily(
        stock: stock('SH', 'sh600900'), start: DateTime(2026, 1, 1));
    expect(rows.single.close, 10);
  });

  test('drops zero-close suspension rows', () {
    final rows = StockKlineService.parseDaily({
      'code': 0,
      'data': {
        'sh600900': {
          'qfqday': [
            ['2023-01-03', '10', '10', '10', '10', '1'],
            ['2023-01-04', '10', '0', '10', '10', '1'],
          ]
        }
      }
    }, 'sh600900', true);
    expect(rows, hasLength(1));
  });
}
