import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/announcement/controllers/announcement_controller.dart';
import 'package:stock_notes/app/modules/announcement/views/announcement_content.dart';
import 'package:stock_notes/app/modules/homenote/controllers/homenote_controller.dart';
import 'package:stock_notes/app/modules/homenote/views/homenote_view.dart';
import 'package:stock_notes/app/modules/homestock/controllers/homestock_controller.dart';
import 'package:stock_notes/app/modules/homestock/views/homestock_view.dart';

import '../../../../common/event_bus.dart';
import '../../../../common/globle_service.dart';
import '../../../../common/langs/text_key.dart';
import '../../../../utils/qs_hud.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_controller.dart';

class TabsController extends GetxController {
  final currentIndex = 0.obs;
  final List<Widget> pages = const [
    HomestockView(),
    HomenoteView(),
  ];
  PageController pageController = PageController(initialPage: 0);

  final EventBusCallback eventBuscallback = (arg) {
    print(arg);
  };
  final EventBusCallback eventBuscallbackB = (arg) {
    print(arg);
  };

  bool _announcementShowing = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    dealWithDeepLink(Get.arguments);
    maybeShowAnnouncement();
  }

  Future<void> maybeShowAnnouncement() async {
    if (_announcementShowing || GlobalService.to.hasShownAnnouncement) return;
    _announcementShowing = true;
    try {
      final announcementController = Get.isRegistered<AnnouncementController>()
          ? Get.find<AnnouncementController>()
          : Get.put(AnnouncementController());
      QsHud.showDialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380, maxHeight: 620),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      TextKey.gonggao.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: AnnouncementContent(
                        compact: true,
                        onSaveImage: announcementController.saveQrCode,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: QsHud.dismiss,
                          child: Text(TextKey.zhidaole.tr),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: QsHud.dismiss,
                    icon: const Icon(Icons.close, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await GlobalService.to.markAnnouncementShown();
    } finally {
      _announcementShowing = false;
    }
  }

  //是否操作状态
  final isOperate = false.obs;

  void pushCreatePage() {
    closeDrawer();

    if (isOperate.value) {
      if (currentIndex.value == 0) {
        Get.find<HomestockController>().clickTabOpBatchDelete();
      } else {
        Get.find<HomenoteController>().clickTabOpBatchDelete();
      }
    } else {
      if (currentIndex.value == 0) {
        // 腾讯 888条，一般用户不超过吧，超过在优化
        // if (Get.find<HomestockController>().items.length >= 500) {
        //   QsHud.showToast(TextKey.gupiaozuiduo500shuliang.tr);
        //   return;
        // }
        Get.toNamed(Routes.STOCKEDIT);
      } else {
        Get.toNamed(Routes.NOTEEDIT);
      }
    }
  }

  //特殊处理closeDrawer
  void closeDrawer() {
    Get.find<HomestockController>().closeDrawer();
  }

  void openDrawer() {
    Get.find<HomestockController>().openDrawer();
  }

  void setCurrentIndex(index) {
    GetView<BaseController> getHideView =
        pages[currentIndex.value] as GetView<BaseController>;
    getHideView.controller.onPause();
    currentIndex.value = index;
    GetView<BaseController> getShowView =
        pages[currentIndex.value] as GetView<BaseController>;
    getShowView.controller.onResume();
  }

  void cancelUIoP() {
    Get.find<HomestockController>().cancelUIoP();
    if (isOperate.value) {
      clickOpTab(2);
    }
  }

  void clickOpTab(int index) {
    if (index == 0) {
      //check
      if (currentIndex.value == 0) {
        Get.find<HomestockController>().clickTabOpAllCheck();
      } else {
        Get.find<HomenoteController>().clickTabOpAllCheck();
      }
    } else {
      //back
      if (currentIndex.value == 0) {
        Get.find<HomestockController>().clickTabOpBack();
      } else {
        Get.find<HomenoteController>().clickTabOpBack();
      }
      isOperate.value = false;
    }
  }

  void clickTab(int index) {
    closeDrawer();

    if (currentIndex.value != index) {
      currentIndex.value = index;
      setCurrentIndex(currentIndex.value);
      pageController.jumpToPage(currentIndex.value);
    } else {
      if (currentIndex.value == 0) {
        Get.find<HomestockController>().clickScrollToTop();
      } else {
        Get.find<HomenoteController>().clickScrollToTop();
      }
    }
  }

  void dealWithDeepLink(Map<String, String?>? parameters) {
    parameters?.forEach((key, value) {
      if (key == 'op') {
        if (value == "saying") {
          openDrawer();
        } else if (value == "meetbs") {
          Get.find<HomestockController>().deeplinkMeetBS();
        } else if (value == "nearbs") {
          Get.find<HomestockController>().deeplinkNearBS();
        } else if (value == "search") {
          Get.find<HomestockController>().deeplinkSearch();
        }
      }
    });
  }
}
