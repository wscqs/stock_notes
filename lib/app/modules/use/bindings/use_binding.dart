import 'package:get/get.dart';

import '../controllers/use_controller.dart';

class UseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UseController>(
      () => UseController(),
    );
  }
}
