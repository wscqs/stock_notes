import 'package:get/get.dart';

import '../controllers/stocknote_controller.dart';

class StocknoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StocknoteController>(
      () => StocknoteController(),
    );
  }
}
