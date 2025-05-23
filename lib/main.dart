import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'common/database/database.dart';
import 'common/globle_service.dart';
import 'common/langs/translation_library.dart';
import 'common/styles/theme_data.dart';
import 'utils/qs_cache.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Future.wait([
    QsCache.preInit(),
    Get.putAsync(() => GlobalService().init()),
    Get.putAsync(() async => AppDatabase()),
  ]);
  // Get.put(DatabaseManager());

  Future.microtask(() async {
    final AppLinks appLinks = AppLinks();
    // // 处理冷启动链接
    // Uri? initialUri = await appLinks.getInitialLink();
    // if (initialUri != null) {
    //   AppPages.handleDeepLink(initialUri);
    // }
    // 监听应用运行时的链接
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) AppPages.handleDeepLink(uri);
    });
  });

  // QsRequest.initDio();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "股票笔记",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            return FlutterSmartDialog.init()(context, child);
          },
        );
      },
      themeMode: GlobalService.to.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: GlobalService.to.locale,
      translations: TranslationLibrary(),
      fallbackLocale: TranslationLibrary.fallbackLocale,
      supportedLocales: TranslationLibrary.supportedLocales,
      localizationsDelegates: TranslationLibrary.localizationsDelegates,
    );
  }
}
