import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../utils/qs_cache.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/datesource/bindings/datesource_binding.dart';
import '../modules/datesource/views/datesource_view.dart';
import '../modules/homenote/bindings/homenote_binding.dart';
import '../modules/homenote/views/homenote_view.dart';
import '../modules/homestock/bindings/homestock_binding.dart';
import '../modules/homestock/views/homestock_view.dart';
import '../modules/notedetail/bindings/notedetail_binding.dart';
import '../modules/notedetail/views/notedetail_view.dart';
import '../modules/noteedit/bindings/noteedit_binding.dart';
import '../modules/noteedit/views/noteedit_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/simplesel/bindings/simplesel_binding.dart';
import '../modules/simplesel/views/simplesel_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/stockdetail/bindings/stockdetail_binding.dart';
import '../modules/stockdetail/views/stockdetail_view.dart';
import '../modules/stockedit/bindings/stockedit_binding.dart';
import '../modules/stockedit/views/stockedit_view.dart';
import '../modules/tabs/bindings/tabs_binding.dart';
import '../modules/tabs/views/tabs_view.dart';
import '../modules/tagsedit/bindings/tagsedit_binding.dart';
import '../modules/tagsedit/views/tagsedit_view.dart';
import '../modules/use/bindings/use_binding.dart';
import '../modules/use/views/use_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static void handleDeepLink(Uri uri) {
    // content://com.tencent.mm.external.fileprovider/attachment/stocknotes_abc.db
    if (uri.scheme == 'content' && uri.path.endsWith('db')) {
      //文件
      if (!uri.path.contains("stocknotes")) {
        QsHud.showToast(TextKey.errorwjmbhsn.tr);
        return;
      }
      //打开数据源页面，并导入数据库
      var selectedDateSource =
          QsCache.get<String>("selectedDateSourceKey") ?? "";
      if (selectedDateSource.isEmpty) {
        QsHud.showToast(TextKey.errortishixianchushihuasjy.tr,
            displaySeconds: 4);
      } else {
        // Get.offAllNamed(
        //   Routes.TABS,
        //   arguments: null,
        // );
        Get.toNamed(Routes.DATESOURCE, arguments: uri);
      }
      return;
    }
    final fragment = uri.fragment;
    Uri trueUri = Uri.parse(fragment);
    String path = trueUri.path;
    Map<String, String> params = trueUri.queryParameters;
    if (fragment == '/stockedit') {
      Get.toNamed(Routes.STOCKEDIT);
    } else if (fragment == '/noteedit') {
      Get.toNamed(Routes.NOTEEDIT);
    } else if (fragment.startsWith('/tabs')) {
      // Get.offAllNamed(fragment);//后面研究下 parameters 为啥无法取到值
      Get.offAllNamed(Routes.TABS, arguments: params);
    } else if (fragment == '/use') {
      Get.toNamed(Routes.USE);
    } else if (fragment == '/splash') {
      Get.toNamed(Routes.SPLASH);
    } else if (fragment == '/setting') {
      Get.toNamed(Routes.SETTING);
    } else if (fragment == '/about') {}
  }

  static const INITIAL = Routes.TABS;

  static final routes = [
    GetPage(
      name: _Paths.TABS,
      page: () => const TabsView(),
      binding: TabsBinding(),
    ),
    GetPage(
      name: _Paths.HOMESTOCK,
      page: () => const HomestockView(),
      binding: HomestockBinding(),
    ),
    GetPage(
      name: _Paths.HOMENOTE,
      page: () => const HomenoteView(),
      binding: HomenoteBinding(),
    ),
    GetPage(
      name: _Paths.STOCKDETAIL,
      page: () => const StockdetailView(),
      binding: StockdetailBinding(),
    ),
    GetPage(
      name: _Paths.NOTEDETAIL,
      page: () => const NotedetailView(),
      binding: NotedetailBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.SIMPLESEL,
      page: () => const SimpleselView(),
      binding: SimpleselBinding(),
    ),
    GetPage(
      name: _Paths.STOCKEDIT,
      page: () => const StockeditView(),
      binding: StockeditBinding(),
    ),
    GetPage(
      name: _Paths.NOTEEDIT,
      page: () => const NoteeditView(),
      binding: NoteeditBinding(),
    ),
    GetPage(
      name: _Paths.TAGSEDIT,
      page: () => const TagseditView(),
      binding: TagseditBinding(),
    ),
    GetPage(
      name: _Paths.USE,
      page: () => const UseView(),
      binding: UseBinding(),
    ),
    GetPage(
      name: _Paths.DATESOURCE,
      page: () => const DatesourceView(),
      binding: DatesourceBinding(),
    ),
  ];
}
