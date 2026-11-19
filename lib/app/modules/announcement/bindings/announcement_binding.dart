import 'package:get/get.dart';

import '../controllers/announcement_controller.dart';

class AnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnnouncementController>(AnnouncementController.new);
  }
}
