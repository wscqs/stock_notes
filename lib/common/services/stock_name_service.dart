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

  /// 内存缓存，避免每次访问都从 Hive 反序列化并复制全量 Map
  static Map<String, String>? _memoryMap;

  /// 从本地缓存读取股票 Map（code -> name）
  static Map<String, String> get cachedStockMap {
    final memoryMap = _memoryMap;
    if (memoryMap != null) return memoryMap;
    final cached = QsCache.get<Map<dynamic, dynamic>>(_cacheKey);
    if (cached == null || cached.isEmpty) return {};
    return _memoryMap = cached.map(
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
      _memoryMap = map;
    }
    return map;
  }

  /// 按名称或 code 从本地缓存搜索股票
  ///
  /// 返回 [{code, name}] 列表，最多 [limit] 条。
  /// 排序优先级：代码前缀 > 名称前缀 > 代码包含 > 名称包含，
  /// 例如输入 300 时 300xxx 排在 920300 前面。
  static List<MapEntry<String, String>> search(String keyword,
      {int limit = 20}) {
    final lowerKeyword = keyword.trim().toLowerCase();
    if (lowerKeyword.isEmpty) return [];

    final map = cachedStockMap;
    if (map.isEmpty) return [];

    // 分桶即完成排序：桶内保持缓存原顺序
    final codePrefix = <MapEntry<String, String>>[];
    final namePrefix = <MapEntry<String, String>>[];
    final codeContains = <MapEntry<String, String>>[];
    final nameContains = <MapEntry<String, String>>[];

    for (final e in map.entries) {
      final code = e.key.toLowerCase();
      final name = e.value.toLowerCase();
      if (code.startsWith(lowerKeyword)) {
        codePrefix.add(e);
      } else if (name.startsWith(lowerKeyword)) {
        namePrefix.add(e);
      } else if (code.contains(lowerKeyword)) {
        codeContains.add(e);
      } else if (name.contains(lowerKeyword)) {
        nameContains.add(e);
      }
    }

    return [...codePrefix, ...namePrefix, ...codeContains, ...nameContains]
        .take(limit)
        .toList();
  }

  /// 从分享文本中识别股票代码
  ///
  /// 识别顺序：
  /// 1. 港股显式标记：HK00700 / hk0700 / 00700.HK（不区分大小写）；
  /// 2. A 股 6 位数字代码（需存在于缓存，缓存为空时按常见前缀兜底）；
  /// 3. 港股括号写法：(00700)（分享文本中港股代码通常补零为 5 位且以 0 开头）；
  /// 4. A 股名称匹配（取最长命中，减少误判）。
  /// 识别不到返回 null。返回纯数字代码即可，行情接口会自动补 hk 等市场前缀。
  static String? detectStockCode(String text) {
    if (text.trim().isEmpty) return null;
    final map = cachedStockMap;

    // 1. 港股显式标记：HK00700 / hk 0700 / 00700.HK
    final hkMarked = RegExp(
            r'(?<![\da-z])hk\s?(\d{4,5})(?!\d)|(?<!\d)(\d{4,5})\s*[.．]\s*hk(?![a-z])',
            caseSensitive: false)
        .firstMatch(text);
    if (hkMarked != null) {
      return hkMarked.group(1) ?? hkMarked.group(2);
    }

    // 2. A 股：独立的 6 位数字（前后不能还是数字，排除手机号等长数字串）
    final codes = RegExp(r'(?<!\d)\d{6}(?!\d)')
        .allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
    if (codes.isNotEmpty) {
      for (final code in codes) {
        if (map.containsKey(code)) return code;
      }
      // 缓存缺失或未命中时的前缀兜底：沪 60/68，深 00/30，北 4/8，场内基金 15/51/56/58
      for (final code in codes) {
        if (RegExp(r'^(60|68|00|30|4|8|15|51|56|58)').hasMatch(code)) {
          return code;
        }
      }
    }

    // 3. 港股括号写法：(00700)
    final hkParen = RegExp(r'[(（]\s*(0\d{4})\s*[)）]').firstMatch(text);
    if (hkParen != null) return hkParen.group(1);

    // 4. 名称匹配：取文本中命中的最长名称
    if (map.isNotEmpty) {
      String? bestCode;
      var bestLen = 0;
      map.forEach((code, name) {
        if (name.length >= 2 &&
            name.length > bestLen &&
            text.contains(name)) {
          bestCode = code;
          bestLen = name.length;
        }
      });
      return bestCode;
    }
    return null;
  }
}
