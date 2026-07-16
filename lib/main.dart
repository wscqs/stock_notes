import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/famous/controllers/famous_data_help.dart';
import 'package:stock_notes/common/services/stock_name_service.dart';

import 'app/routes/app_pages.dart';
import 'common/database/DatabaseManager.dart';
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
    // Get.putAsync(() async => AppDatabase()),
  ]);
  final dbManager = DatabaseManager();
  await dbManager.init(); // or provide path
  Get.put(dbManager);
  FamousDataHelp().loadFamous();
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

  // checkOpenedFile();
  // QsRequest.initDio();
  runApp(MyApp());

  // 首帧渲染完成后再预热本地 A 股 code/name 缓存（约几千条，反序列化较耗时），
  // 避免与首帧争抢主线程；若本地无缓存则后台异步拉取，不阻塞启动
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        if (StockNameService.cachedStockMap.isEmpty) {
          await StockNameService.refreshStockMap();
        }
      } catch (e) {
        if (kDebugMode) {
          print('StockNameService init error: $e');
        }
      }
    });
  });
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
