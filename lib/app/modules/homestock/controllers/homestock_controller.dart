import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
