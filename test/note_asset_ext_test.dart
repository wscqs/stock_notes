import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  group('NoteAssetExt', () {
    NoteAsset makeAsset({String? buyAmount, String? sellAmount}) {
      return NoteAsset(
        id: 1,
        noteId: 1,
        name: 'Test',
        buyAmount: buyAmount,
        sellAmount: sellAmount,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
      );
    }

    test('profit and rate calculated correctly', () {
      final asset = makeAsset(buyAmount: '1000', sellAmount: '1200');
      expect(asset.profit, 200.0);
      expect(asset.profitRate, 0.2);
      expect(asset.profitRateText, '+20.0%');
    });

    test('only buy amount returns null profit and rate', () {
      final asset = makeAsset(buyAmount: '1000');
      expect(asset.profit, isNull);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('only sell amount returns null profit and rate', () {
      final asset = makeAsset(sellAmount: '1200');
      expect(asset.profit, isNull);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('empty buy and sell amounts return null', () {
      final asset = makeAsset();
      expect(asset.profit, isNull);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('zero buy amount returns null rate', () {
      final asset = makeAsset(buyAmount: '0', sellAmount: '1200');
      expect(asset.profit, 1200.0);
      expect(asset.profitRate, isNull);
      expect(asset.profitRateText, isNull);
    });

    test('negative profit renders minus sign', () {
      final asset = makeAsset(buyAmount: '1000', sellAmount: '800');
      expect(asset.profit, -200.0);
      expect(asset.profitRateText, '-20.0%');
    });
  });
}
