import 'package:get/get.dart';
import '../controllers/messagesetting_controller.dart';

class MessagesettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesettingController>(() => MessagesettingController());
  }
}
