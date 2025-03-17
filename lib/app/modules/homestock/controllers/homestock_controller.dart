import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

class HomestockController extends BaseController {
  final TextEditingController searchController = TextEditingController();
  final items = [
    "Apple",
    "Banana",
    "Orange",
    "Grapes",
    "Mango",
    "Pineapple",
    "Strawberry",
    "Blueberry"
  ].obs;
  final filteredItems = [].obs;

  @override
  void onInit() {
    super.onInit();
    filteredItems.value = items; // 默认显示所有项目
    // 初始化回调，在这里绑定 refreshAppui 方法
    // eventBuscallbackrefreshAppui = (arg) {
    //   refreshAppui();
    // };
  }

  void refreshAppui() {
    filteredItems.value = items;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clickMore() {}

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.value = items;
    } else {
      filteredItems.value = items
          .where((item) =>
              item.toLowerCase().contains(query.toLowerCase())) // 搜索逻辑
          .toList();
    }
  }

  void pushDetailPage() {
    Get.toNamed(Routes.NOTEDETAIL);
  }
}
