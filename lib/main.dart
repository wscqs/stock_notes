import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'app/routes/app_pages.dart';
import 'common/comment_style.dart';
import 'utils/qs_cache.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await QsCache.preInit();
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
        theme: ThemeData(
            scaffoldBackgroundColor: kColorGg,
            //highlightColor与splashColor 底部 tab 不要效果，highlightColor水波纹也没效果
            highlightColor: const Color(0x00000000),
            splashColor: const Color(0x00000000),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: kColorGg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        16.0)), // Optional: round the top corners
              ),
            ),
            appBarTheme: AppBarTheme(
              color: kColorGg,
              // 如果你不想使用阴影，可以将elevation设置为0
              // elevation: 0,
              scrolledUnderElevation: 0, //滚动不变色
              // backgroundColor: kColorGg,
            )),
      );
    },
  ));
}
