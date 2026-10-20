import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';
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

  testWidgets('StockTradeDialog defaults prefill open price, shares, remark and buy type',
      (tester) async {
    StockTradesCompanion? captured;
    await tester.pumpWidget(buildTestableWidget(
      Builder(builder: (context) {
        return ElevatedButton(
          onPressed: () => StockTradeDialog.show(
            context: context,
            existingTrade: null,
            currentPrice: '12.50',
            defaultOpenPrice: '10.00',
            defaultOpenShares: '500',
            defaultRemark: '测试备注',
            defaultTradeType: 0,
            onSaved: (companion) => captured = companion,
          ),
          child: const Text('open'),
        );
      }),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // 默认选中“买”
    expect(find.widgetWithText(ChoiceChip, TextKey.buy.tr), findsOneWidget);
    final buyChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, TextKey.buy.tr));
    expect(buyChip.selected, isTrue);

    // 字段已预填
    expect(find.widgetWithText(TextField, '10.00'), findsOneWidget);
    expect(find.widgetWithText(TextField, '500'), findsOneWidget);
    expect(find.widgetWithText(TextField, '测试备注'), findsOneWidget);

    // 点击确定后回调携带默认值
    await tester.tap(find.widgetWithText(TextButton, TextKey.queding.tr));
    await tester.pumpAndSettle();

    expect(captured, isNotNull);
    expect(captured!.openPrice.value, '10.00');
    expect(captured!.openShares.value, '500');
    expect(captured!.remark.value, '测试备注');
    expect(captured!.tradeType.value, 0);
  });
}
