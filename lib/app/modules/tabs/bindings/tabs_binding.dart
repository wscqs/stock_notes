import 'package:get/get.dart';
import 'package:stock_notes/app/modules/homenote/controllers/homenote_controller.dart';
import 'package:stock_notes/app/modules/homestock/controllers/homestock_controller.dart';

import '../controllers/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<HomestockController>(
      () => HomestockController(),
    );
    Get.lazyPut<HomenoteController>(
      () => HomenoteController(),
    );
  }
}
