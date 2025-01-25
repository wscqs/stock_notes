import 'package:get/get.dart';

import '../controllers/stockedit_controller.dart';

class StockeditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockeditController>(
      () => StockeditController(),
    );
  }
}
