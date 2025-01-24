import 'package:get/get.dart';

import '../controllers/simplesel_controller.dart';

class SimpleselBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SimpleselController>(
      () => SimpleselController(),
    );
  }
}
