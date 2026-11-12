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
}
