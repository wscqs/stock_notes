import 'package:get/get.dart';

import '../../somewidget/homedrawer_page/vc.dart';

class AnnouncementController extends GetxController {
  late final HomedrawerVC _drawerVC = Get.isRegistered<HomedrawerVC>()
      ? Get.find<HomedrawerVC>()
      : Get.put(HomedrawerVC());

  Future<void> saveQrCode() => _drawerVC.saveZstImage();
}
