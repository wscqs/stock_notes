import 'package:get/get.dart';
import '../controllers/tradelist_controller.dart';

class TradelistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradelistController>(() => TradelistController());
  }
}
