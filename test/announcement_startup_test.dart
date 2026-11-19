import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_notes/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:stock_notes/common/globle_service.dart';
import 'package:stock_notes/common/langs/translation_library.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync(() => GlobalService().init());
  });

  tearDown(() async {
    SmartDialog.dismiss().ignore();
    Get.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      home: const Scaffold(),
    ));
  }

  testWidgets('first startup shows and permanently marks the announcement',
      (tester) async {
    await pumpApp(tester);
    final controller = TabsController();

    await controller.maybeShowAnnouncement();
    await tester.pumpAndSettle();

    expect(find.text('公告'), findsOneWidget);
    expect(find.text('知道了'), findsOneWidget);
    expect(GlobalService.to.hasShownAnnouncement, isTrue);
    expect(
      GlobalService.to.sharedPreferences.getBool('announcementShownV1'),
      isTrue,
    );

    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle();
    expect(find.text('公告'), findsNothing);
  });

  testWidgets('seen announcement does not show again', (tester) async {
    SharedPreferences.setMockInitialValues({'announcementShownV1': true});
    Get.reset();
    await Get.putAsync(() => GlobalService().init());
    await pumpApp(tester);

    await TabsController().maybeShowAnnouncement();
    await tester.pump();
    expect(find.text('公告'), findsNothing);
  });

  testWidgets('reentrant calls only show one dialog', (tester) async {
    await pumpApp(tester);
    final controller = TabsController();

    await Future.wait([
      controller.maybeShowAnnouncement(),
      controller.maybeShowAnnouncement(),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('公告'), findsOneWidget);
  });
}
