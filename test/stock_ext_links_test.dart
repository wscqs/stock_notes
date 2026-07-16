import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/web/stock_ext_links.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isAStock', () {
    test('A股返回true', () {
      expect(StockExtLinks.isAStock('sz300848'), isTrue);
      expect(StockExtLinks.isAStock('sh600519'), isTrue);
    });
    test('基金/港股/美股/空串返回false', () {
      expect(StockExtLinks.isAStock('sh510300'), isFalse);
      expect(StockExtLinks.isAStock('sz159915'), isFalse);
      expect(StockExtLinks.isAStock('hk00700'), isFalse);
      expect(StockExtLinks.isAStock('usAAPL'), isFalse);
      expect(StockExtLinks.isAStock(''), isFalse);
    });
  });

  group('buildLoadResource', () {
    test('URL类型替换6位数字代码', () async {
      final kline = StockExtLinks.all.firstWhere((l) => l.id == 'kline_baidu');
      final url = await StockExtLinks.buildLoadResource(kline, 'sz300848');
      expect(url,
          'https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=300848');
    });

    test('大事东使用市场大写前缀+代码', () async {
      final dashi = StockExtLinks.all.firstWhere((l) => l.id == 'dashi_em');
      expect(await StockExtLinks.buildLoadResource(dashi, 'sz300848'),
          contains('fc=SZ300848'));
      expect(await StockExtLinks.buildLoadResource(dashi, 'sh600519'),
          contains('fc=SH600519'));
    });

    test('扫雷安替换StockCode参数', () async {
      final link = StockExtLinks.all.firstWhere((l) => l.id == 'saolei_essence');
      final url = await StockExtLinks.buildLoadResource(link, 'sz300848');
      expect(url, contains('StockCode=300848'));
    });

    test('非A股返回null', () async {
      final kline = StockExtLinks.all.firstWhere((l) => l.id == 'kline_baidu');
      expect(await StockExtLinks.buildLoadResource(kline, 'hk00700'), isNull);
    });

    test('本地asset注入APP_STOCK_CODE', () async {
      final link = StockExtLinks.all.firstWhere((l) => l.id == 'gainian_ths');
      final html = await StockExtLinks.buildLoadResource(link, 'sz300848');
      expect(html, isNotNull);
      expect(html, contains('window.APP_STOCK_CODE="300848"'));
      expect(html, contains('fetchStockConcepts'));
    });
  });

  group('selectedIds', () {
    test('无缓存时返回默认勾选', () {
      // 测试环境 Hive box 未初始化，QsCache.get 返回 null → 默认值
      expect(StockExtLinks.selectedIds(), ['kline_baidu', 'saolei_ths']);
    });
    test('默认值按 all 顺序', () {
      final defaults = StockExtLinks.selectedIds();
      final order = StockExtLinks.all.map((l) => l.id).toList();
      expect(defaults, orderedEquals(order.where(defaults.contains)));
    });
  });

  group('all', () {
    test('包含6个链接且id唯一', () {
      expect(StockExtLinks.all.length, 6);
      final ids = StockExtLinks.all.map((l) => l.id).toSet();
      expect(ids.length, 6);
    });
    test('顺序为k线百/扫雷同/扫雷安/大事东/概念同/简况', () {
      expect(
          StockExtLinks.all.map((l) => l.id).toList(),
          [
            'kline_baidu',
            'saolei_ths',
            'saolei_essence',
            'dashi_em',
            'gainian_ths',
            'jiankuan',
          ]);
    });
  });
}
