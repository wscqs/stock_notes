import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
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

part 'app_routes.dart';

class AppPages {
  AppPages._();

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
  ];
}
