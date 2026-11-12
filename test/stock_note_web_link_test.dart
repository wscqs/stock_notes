import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/web/stock_note_web_link.dart';

void main() {
  group('StockNoteWebLink.stockEditCode', () {
    test('preserves the stock code from an in-app stock edit link', () {
      final uri = Uri.parse(
        'stocknote://stocknote.com/#/stockedit?code=000001',
      );

      expect(StockNoteWebLink.stockEditCode(uri), '000001');
    });

    test('recognizes a request for a blank stock edit page', () {
      final uri = Uri.parse('stocknote://stocknote.com/#/stockedit');

      expect(StockNoteWebLink.stockEditCode(uri), isEmpty);
    });

    test('rejects links for other app routes', () {
      final uri = Uri.parse('stocknote://stocknote.com/#/noteedit');

      expect(StockNoteWebLink.stockEditCode(uri), isNull);
    });

    test('does not interpret an HTTPS link as a native stock edit request', () {
      final uri = Uri.parse(
        'https://stocknote.com/#/stockedit?code=000001',
      );

      expect(StockNoteWebLink.stockEditCode(uri), isNull);
    });
  });
}
