import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/announcement/bindings/announcement_binding.dart';
import 'package:stock_notes/app/modules/announcement/views/announcement_content.dart';
import 'package:stock_notes/app/modules/announcement/views/announcement_view.dart';
import 'package:stock_notes/app/routes/app_pages.dart';
import 'package:stock_notes/common/langs/translation_library.dart';

void main() {
  testWidgets('announcement route opens the announcement page',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      initialRoute: Routes.ANNOUNCEMENT,
      getPages: AppPages.routes,
    ));
    final announcementRoute = AppPages.routes.firstWhere(
      (route) => route.name == Routes.ANNOUNCEMENT,
    );
    expect(announcementRoute.name, '/announcement');
    expect(find.text('公告'), findsOneWidget);
  });
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('announcement shows maintenance message and WeChat QR code',
      (tester) async {
    var saveCount = 0;
    await tester.pumpWidget(GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      home: Scaffold(
        body: AnnouncementContent(
          onSaveImage: () async => saveCount++,
        ),
      ),
    ));

    expect(find.textContaining('之前居家办公时'), findsOneWidget);
    expect(find.textContaining('如果股票笔记对你有帮助'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/images/zst.jpg');
    expect(find.text('微信扫一扫，请作者喝杯咖啡'), findsOneWidget);

    await tester.longPress(find.byType(Image));
    expect(saveCount, 1);
  });

  testWidgets('announcement page fits a narrow short viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(GetMaterialApp(
      translations: TranslationLibrary(),
      locale: TranslationLibrary.fallbackLocale,
      fallbackLocale: TranslationLibrary.fallbackLocale,
      initialRoute: '/announcement',
      getPages: [
        GetPage(
          name: '/announcement',
          page: () => const AnnouncementView(),
          binding: AnnouncementBinding(),
        ),
      ],
    ));

    expect(find.text('公告'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
