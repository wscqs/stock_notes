import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'common/globle_service.dart';
import 'common/langs/translation_library.dart';
import 'common/styles/theme_data.dart';
import 'utils/qs_cache.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await QsCache.preInit();
  await Get.putAsync(() => GlobalService().init());
  // QsRequest.initDio();
  runApp(ScreenUtilInit(
    designSize: const Size(375, 812), //设计稿宽高的px
    minTextAdapt: true, //是否根据宽度/高度中的最小值适配文字
    splitScreenMode: true, //支持分屏尺寸
    builder: (context, child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "股票笔记",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        defaultTransition: Transition.rightToLeft,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        // 主题
        themeMode: GlobalService.to.themeMode,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        //国际化
        locale: GlobalService.to.locale,
        translations: TranslationLibrary(),
        fallbackLocale: TranslationLibrary.fallbackLocale,
        supportedLocales: TranslationLibrary.supportedLocales,
        localizationsDelegates: TranslationLibrary.localizationsDelegates,
      );
    },
  ));
}
