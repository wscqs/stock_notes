import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_notes/app/modules/setting/bindings/setting_binding.dart';
import 'package:stock_notes/app/modules/setting/views/setting_view.dart';
import 'package:stock_notes/app/modules/simplesel/bindings/simplesel_binding.dart';
import 'package:stock_notes/app/modules/simplesel/views/simplesel_view.dart';
import 'package:stock_notes/app/routes/app_pages.dart';
import 'package:stock_notes/common/globle_service.dart';
import 'package:stock_notes/common/langs/translation_library.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync(() => GlobalService().init());
  });

  tearDown(Get.reset);

  testWidgets('setting changes and persists the stock edit trade display',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      initialRoute: Routes.SETTING,
      getPages: [
        GetPage(
          name: Routes.SETTING,
          page: () => const SettingView(),
          binding: SettingBinding(),
        ),
        GetPage(
          name: Routes.SIMPLESEL,
          page: () => const SimpleselView(),
          binding: SimpleselBinding(),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('交易模块展示'), findsOneWidget);
    expect(find.text('交易中'), findsOneWidget);

    await tester.tap(find.text('交易模块展示'));
    await tester.pumpAndSettle();
    expect(find.text('全部'), findsOneWidget);
    expect(find.text('交易中'), findsOneWidget);
    expect(find.text('历史'), findsOneWidget);

    await tester.tap(find.text('历史'));
    await tester.pumpAndSettle();
    expect(GlobalService.to.rxStockeditTradeFilter.value, 'history');
    expect(GlobalService.to.sharedPreferences.getString('stockeditTradeFilter'),
        'history');
    expect(find.text('历史'), findsOneWidget);
  });
}
