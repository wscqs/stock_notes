import 'package:get/get.dart';

import '../controllers/datesource_controller.dart';

class DatesourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatesourceController>(
      () => DatesourceController(),
    );
  }
}
