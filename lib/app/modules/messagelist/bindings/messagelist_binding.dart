import 'package:get/get.dart';
import '../controllers/messagelist_controller.dart';

class MessagelistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagelistController>(() => MessagelistController());
  }
}
