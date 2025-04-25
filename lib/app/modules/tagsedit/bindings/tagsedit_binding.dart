import 'package:get/get.dart';

import '../controllers/tagsedit_controller.dart';

class TagseditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TagseditController>(
      () => TagseditController(),
    );
  }
}
