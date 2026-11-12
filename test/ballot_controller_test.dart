import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/app/modules/ballot/controllers/ballot_controller.dart';

void main() {
  test('market overview is the first ballot item and opens a local HTML asset',
      () {
    final controller = BallotController();

    final marketOverview = controller.items.first;
    expect(marketOverview.title, '市场概况');
    expect(marketOverview.url, 'assets/html/market_overview.html');
    expect(marketOverview.isLocalAsset, isTrue);
  });

  test('latest theme is immediately above what is trending today', () {
    final controller = BallotController();
    final titles = controller.items.map((item) => item.title).toList();
    final latestThemeIndex = titles.indexOf('最新主题');

    expect(latestThemeIndex, greaterThanOrEqualTo(0));
    expect(titles[latestThemeIndex + 1], '今天炒什么');
    expect(
      controller.items[latestThemeIndex].url,
      'https://latest-theme.app.workbuddy.host/?sharecode=M25PNRLUQH',
    );
    expect(controller.items[latestThemeIndex].isLocalAsset, isFalse);
  });
}
