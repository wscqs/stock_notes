import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_notes/utils/qs_cache.dart';

/// 新浪财经 A 股全量股票代码/名称缓存服务
///
/// 通过分页接口拉取所有 A 股（含北交所）的 code 与 name，
/// 以 {code: name} 的形式缓存到本地 Hive，供搜索时做名称联想。
abstract final class StockNameService {
  StockNameService._();

  static const String _cacheKey = 'all_ashare_stock_map';
  static const String _lastUpdateKey = 'all_ashare_stock_last_update';
  static const int _defaultMaxPages = 100;
  static const Duration _timeout = Duration(seconds: 15);

  /// 从本地缓存读取股票 Map（code -> name）
  static Map<String, String> get cachedStockMap {
    final cached = QsCache.get<Map<dynamic, dynamic>>(_cacheKey);
    if (cached == null || cached.isEmpty) return {};
    return cached.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }

  /// 本地缓存最后更新时间
  static DateTime? get lastUpdateTime {
    final value = QsCache.get<String>(_lastUpdateKey);
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// 分页拉取全部 A 股 code/name
  ///
  /// [pageSize] 每页条数，接口默认最大可设 100。
  /// [maxPages] 最大拉取页数，防止接口异常导致无限循环，默认 100。
  /// [onProgress] 每完成一页回调一次（page, 已加载总数）。
  static Future<Map<String, String>> fetchAllAShareStocks({
    int pageSize = 100,
    int maxPages = _defaultMaxPages,
    void Function(int page, int total)? onProgress,
  }) async {
    final result = <String, String>{};
    int page = 1;
    final dio = Dio(BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
    ));

    while (page <= maxPages) {
      final url =
          'https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/'
          'Market_Center.getHQNodeData?page=$page&num=$pageSize&sort=symbol&asc=1&node=hs_a&_s_r_a=page';

      try {
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.plain),
        );

        final List<dynamic> list;
        if (response.data is String) {
          final raw = response.data as String;
          if (raw.trim().isEmpty) break;
          list = jsonDecode(raw) as List<dynamic>? ?? [];
        } else if (response.data is List) {
          list = response.data as List<dynamic>;
        } else {
          break;
        }

        if (list.isEmpty) break;

        for (final item in list) {
          if (item is! Map) continue;
          final code = item['code']?.toString();
          final name = item['name']?.toString();
          if (code != null &&
              name != null &&
              code.isNotEmpty &&
              name.isNotEmpty) {
            result[code] = name;
          }
        }

        onProgress?.call(page, result.length);

        if (list.length < pageSize) break;
        page++;
      } catch (e) {
        // 单页失败即终止，保留已拉取数据
        if (kDebugMode) {
          log('StockNameService fetch error on page $page: $e');
        }
        break;
      }
    }

    dio.close();
    return result;
  }

  /// 拉取并写入本地缓存
  static Future<Map<String, String>> refreshStockMap({
    void Function(int page, int total)? onProgress,
  }) async {
    final map = await fetchAllAShareStocks(onProgress: onProgress);
    if (map.isNotEmpty) {
      QsCache.set(_cacheKey, map);
      QsCache.set(_lastUpdateKey, DateTime.now().toIso8601String());
    }
    return map;
  }

  /// 按名称或 code 从本地缓存搜索股票
  ///
  /// 返回 [{code, name}] 列表，最多 [limit] 条。
  static List<MapEntry<String, String>> search(String keyword,
      {int limit = 20}) {
    if (keyword.trim().isEmpty) return [];

    final map = cachedStockMap;
    if (map.isEmpty) return [];

    final lowerKeyword = keyword.toLowerCase();
    return map.entries
        .where((e) =>
            e.value.toLowerCase().contains(lowerKeyword) ||
            e.key.toLowerCase().contains(lowerKeyword))
        .take(limit)
        .toList();
  }
}
