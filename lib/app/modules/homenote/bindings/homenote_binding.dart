import 'package:get/get.dart';

import '../controllers/homenote_controller.dart';

class HomenoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomenoteController>(
      () => HomenoteController(),
    );
  }
}
