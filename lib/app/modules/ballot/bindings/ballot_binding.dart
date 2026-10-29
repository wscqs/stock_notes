import 'package:get/get.dart';

import '../controllers/ballot_controller.dart';

class BallotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BallotController>(
      () => BallotController(),
    );
  }
}
