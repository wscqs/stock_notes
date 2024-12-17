import 'package:get/get.dart';

import '../controllers/stockdetail_controller.dart';

class StockdetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockdetailController>(
      () => StockdetailController(),
    );
  }
}
