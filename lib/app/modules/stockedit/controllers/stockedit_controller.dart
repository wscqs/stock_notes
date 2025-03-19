import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockeditController extends GetxController {
  final stockNum = "".obs;
  final stockNumController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    stockNumController.addListener(_updateStockNum);
  }

  void _updateStockNum() {
    stockNum.value = stockNumController.text;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    stockNumController.addListener(_updateStockNum);
    stockNumController.dispose();
    super.onClose();
  }

  void save() {}

  void clearStockNum() {
    stockNumController.clear();
  }
}
