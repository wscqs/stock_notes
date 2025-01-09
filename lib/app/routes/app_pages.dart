import 'package:get/get.dart';

import '../modules/homenote/bindings/homenote_binding.dart';
import '../modules/homenote/views/homenote_view.dart';
import '../modules/homestock/bindings/homestock_binding.dart';
import '../modules/homestock/views/homestock_view.dart';
import '../modules/notedetail/bindings/notedetail_binding.dart';
import '../modules/notedetail/views/notedetail_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/stockdetail/bindings/stockdetail_binding.dart';
import '../modules/stockdetail/views/stockdetail_view.dart';
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
  ];
}
