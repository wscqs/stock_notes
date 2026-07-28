import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/translation_library.dart';
import 'package:stock_notes/common/widget/stock_trade_dialog.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(body: child),
    );
  }

  testWidgets('shows dialog with open price field', (tester) async {
    await tester.pumpWidget(buildTestableWidget(
      Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
            context: context,
            existingTrade: null,
            currentPrice: '10',
            onSaved: (companion) {},
          ),
          child: const Text('open'),
        );
      }),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.widgetWithText(TextField, '价格'), findsWidgets);
  });
}
