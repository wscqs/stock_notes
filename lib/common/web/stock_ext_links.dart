import 'package:flutter/services.dart' show rootBundle;
import 'package:stock_notes/utils/qs_cache.dart';

/// 股票详情页可配置外链定义
class StockExtLink {
  const StockExtLink({
    required this.id,
    required this.title,
    required this.urlTemplate,
    this.isLocalAsset = false,
    this.useMarketPrefix = false,
  });

  /// 唯一标识，用于勾选存储
  final String id;

  /// 固定中文标题（如 k线百），不走 i18n
  final String title;

  /// URL 模板（含 xxxxxx 占位符）或本地 asset 路径
  final String urlTemplate;

  /// 是否本地 html asset（assets/html/ 下）
  final bool isLocalAsset;

  /// true 时 xxxxxx 替换为「市场大写前缀+6位数字」（如 SZ300848），否则替换为 6 位数字
  final bool useMarketPrefix;
}

class StockExtLinks {
  StockExtLinks._();

  static const _cacheKey = 'stock_ext_link_selection';
  static const _placeholder = 'xxxxxx';

  static const List<StockExtLink> all = [
    StockExtLink(
      id: 'kline_baidu',
      title: 'k线百',
      urlTemplate:
          'https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=xxxxxx',
    ),
    StockExtLink(
      id: 'saolei_ths',
      title: '扫雷同',
      urlTemplate:
          'https://bowerbird.10jqka.com.cn/thslc/editor/view/433f6d9Ac0?code=xxxxxx',
    ),
    StockExtLink(
      id: 'saolei_essence',
      title: '扫雷安',
      urlTemplate:
          'https://static.essence.com.cn/zixun/sweep-car/index.html#/pages/sweepDetails/index?StockCode=xxxxxx',
    ),
    StockExtLink(
      id: 'dashi_em',
      title: '大事东',
      urlTemplate: 'https://emh5.eastmoney.com/html/detail.html?fc=xxxxxx#/gsds',
      useMarketPrefix: true,
    ),
    StockExtLink(
      id: 'gainian_ths',
      title: '概念同',
      urlTemplate: 'assets/html/gainiantong.html',
      isLocalAsset: true,
    ),
    StockExtLink(
      id: 'jiankuan',
      title: '简况',
      urlTemplate: 'assets/html/jiankuan.html',
      isLocalAsset: true,
    ),
  ];

  static const List<String> defaultSelectedIds = ['kline_baidu', 'saolei_ths'];

  /// 读取勾选的链接 id；无缓存或缓存损坏时返回默认勾选。
  /// 返回值按 [all] 定义顺序排列。
  static List<String> selectedIds() {
    final cached = QsCache.get(_cacheKey);
    if (cached is! List) return List.of(defaultSelectedIds);
    final ids = cached.map((e) => e.toString()).toSet();
    return all.map((l) => l.id).where(ids.contains).toList();
  }

  static void saveSelectedIds(List<String> ids) {
    QsCache.set(_cacheKey, ids);
  }

  /// A 股判断：sh/sz 开头且非 sh5xxxxx、sz1xxxxx（基金）
  static bool isAStock(String code) {
    return (code.startsWith('sh') || code.startsWith('sz')) &&
        !code.startsWith('sh5') &&
        !code.startsWith('sz1');
  }

  /// 构建跳转目标：URL 类型返回替换后的 url；本地 asset 返回注入股票代码后的 html 字符串。
  /// 非 A 股返回 null。
  static Future<String?> buildLoadResource(
      StockExtLink link, String stockCode) async {
    if (!isAStock(stockCode)) return null;
    final number = stockCode.substring(2);
    if (link.isLocalAsset) {
      final html = await rootBundle.loadString(link.urlTemplate);
      return _injectStockCode(html, number);
    }
    final replacement = link.useMarketPrefix
        ? '${stockCode.substring(0, 2).toUpperCase()}$number'
        : number;
    return link.urlTemplate.replaceAll(_placeholder, replacement);
  }

  /// 在 `<head>` 后注入 window.APP_STOCK_CODE；无 `<head>` 时前置到文档开头
  static String _injectStockCode(String html, String number) {
    final injected = '<script>window.APP_STOCK_CODE="$number";</script>';
    if (html.contains('<head>')) {
      return html.replaceFirst('<head>', '<head>\n$injected');
    }
    return '$injected\n$html';
  }
}
