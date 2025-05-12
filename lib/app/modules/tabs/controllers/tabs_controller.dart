import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/homenote/controllers/homenote_controller.dart';
import 'package:stock_notes/app/modules/homenote/views/homenote_view.dart';
import 'package:stock_notes/app/modules/homestock/controllers/homestock_controller.dart';
import 'package:stock_notes/app/modules/homestock/views/homestock_view.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/event_bus.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
        if (Get.find<HomestockController>().items.length >= 500) {
          QsHud.showToast(TextKey.gupiaozuiduo500shuliang.tr);
          return;
        }
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
    print(parameters);
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
