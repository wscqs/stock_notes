import 'package:get/get.dart';

import '../controllers/notedetail_controller.dart';

class NotedetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotedetailController>(
      () => NotedetailController(),
    );
  }
}
