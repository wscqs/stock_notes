import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/langs/text_key.dart';

void main() {
  test('usage guide documents stock trade display setting', () {
    expect(
      zh[TextKey.shiyongshuomingall],
      contains('设置 → 股票 → 交易模块展示'),
    );
    expect(
      zh[TextKey.shiyongshuomingall],
      contains('全部、交易中或历史'),
    );
    expect(
      en[TextKey.shiyongshuomingall],
      contains('Settings - Stocks - Trade list display'),
    );
    expect(
      en[TextKey.shiyongshuomingall],
      contains('All, Trades, or History'),
    );
  });
}
