import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/https/qs_api.dart';

class StockDailyClose {
  final DateTime date;
  final double close;
  const StockDailyClose(this.date, this.close);
}

class UnsupportedStockMarketException implements Exception {
  const UnsupportedStockMarketException();
}

typedef StockKlineRawFetcher = Future<String> Function(
    String baseUrl, String param);

class StockKlineService {
  static void clearMemoryCacheForTest() => _memoryCache.clear();

  static const baseUrl = 'https://web.ifzq.gtimg.cn/appstock/app/fqkline/get';
  final StockKlineRawFetcher _rawFetcher;
  static final Map<String, List<StockDailyClose>> _memoryCache = {};

  StockKlineService({StockKlineRawFetcher? rawFetcher})
      : _rawFetcher = rawFetcher ?? _fetchRaw;

  static Future<String> _fetchRaw(String url, String param) async {
    final response = await Dio().get<String>(url,
        queryParameters: {'param': param},
        options: Options(responseType: ResponseType.plain));
    return response.data ?? '';
  }

  static bool isSupported(StockItem stock) {
    final market = stock.marketType.toLowerCase();
    return market == 'sh' || market == 'sz' || market == 'hk';
  }

  Future<List<StockDailyClose>> fetchDaily({
    required StockItem stock,
    required DateTime start,
    DateTime? end,
  }) async {
    final market = stock.marketType.toLowerCase();
    final code = QsApi.formatStockCode(stock.code);
    final adjusted = market == 'sh' || market == 'sz';
    if (!adjusted && market != 'hk') {
      throw const UnsupportedStockMarketException();
    }
    final firstDay = DateTime(start.year, start.month, start.day);
    var lastDay =
        end == null ? DateTime.now() : DateTime(end.year, end.month, end.day);
    if (lastDay.isBefore(firstDay)) return [];
    final cacheKey =
        '$code|${adjusted ? 'qfq' : 'day'}|${_date(firstDay)}|${_date(lastDay)}';
    final cached = _memoryCache[cacheKey];
    if (cached != null) {
      final covered =
          cached.isEmpty || cached.first.date.difference(firstDay).inDays <= 7;
      if (covered) return cached;
      _memoryCache.remove(cacheKey);
    }

    final byDate = <String, StockDailyClose>{};
    var windowEnd = lastDay;
    for (var page = 0; page < 32; page++) {
      final param =
          '$code,day,${_date(firstDay)},${_date(windowEnd)},640,${adjusted ? 'qfq' : ''}';
      final payload = jsonDecode(await _rawFetcher(baseUrl, param));
      if (payload is! Map<String, dynamic>)
        throw const FormatException('Invalid K-line response');
      final rows = parseDaily(payload, code, adjusted);
      for (final row in rows) {
        if (!row.date.isBefore(firstDay) && !row.date.isAfter(lastDay)) {
          byDate[_date(row.date)] = row;
        }
      }
      if (rows.length < 640 ||
          rows.first.date.isBefore(firstDay) ||
          rows.first.date.isAtSameMomentAs(firstDay)) break;
      final nextEnd = rows.first.date.subtract(const Duration(days: 1));
      if (!nextEnd.isBefore(windowEnd)) break;
      windowEnd = nextEnd;
    }
    final result = byDate.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    _memoryCache[cacheKey] = result;
    return result;
  }

  static List<StockDailyClose> parseDaily(
      Map<String, dynamic> payload, String code, bool adjusted) {
    if (payload['code'] != 0)
      throw FormatException(payload['msg']?.toString() ?? 'K-line error');
    final stock = payload['data']?[code];
    if (stock is! Map) return [];
    final rawRows = stock[adjusted ? 'qfqday' : 'day'];
    if (rawRows is! List) return [];
    final rows = <String, StockDailyClose>{};
    for (final raw in rawRows) {
      if (raw is! List || raw.length < 3) continue;
      final date = DateTime.tryParse(raw[0].toString());
      final close = double.tryParse(raw[2].toString());
      if (date != null && close != null && close.isFinite && close > 0) {
        rows[raw[0].toString()] = StockDailyClose(date, close);
      }
    }
    return rows.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
