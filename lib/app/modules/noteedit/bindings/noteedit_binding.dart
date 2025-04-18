import 'package:get/get.dart';

import '../controllers/noteedit_controller.dart';

class NoteeditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteeditController>(
      () => NoteeditController(),
    );
  }
}
