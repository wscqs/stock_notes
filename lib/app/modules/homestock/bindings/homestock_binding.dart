import 'package:get/get.dart';

import '../controllers/homestock_controller.dart';

class HomestockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomestockController>(
      () => HomestockController(),
    );
  }
}
