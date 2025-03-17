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

  // final database = AppDatabase(); //web 是支持的，后续研究
  //
  // List<TodoItem> allItems = await database.todoItems.all().get();
  // // database.todoItems.
  // // List<TodoItem> allItems = await (database.select(database.todoItems)
  // //       ..where((u) => u.title.like('%finish%')))
  // //     .get();
  //
  // // await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
  // //       title: 'do: finish drift setup',
  // //       content: 'We can now write queries and define our own tables.',
  // //     ));
  // // List<TodoItem> allItems = await database.select(database.todoItems).get();
  // print('items in database: $allItems');

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
