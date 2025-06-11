import 'package:get/get.dart';

import '../controllers/famous_controller.dart';

class FamousBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamousController>(
      () => FamousController(),
    );
  }
}
