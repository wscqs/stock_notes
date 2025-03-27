import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/model/stock_list_xq_model.dart';

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

  void save() {
    QsApi.stocksList(
        stocks: "SZ000001",
        decodeType: StockListXqModel(),
        completionHandler: (model, error) {
          if (error == null) {
            print(model);
          } else {
            print(error);
          }
        });
  }

  void clearStockNum() {
    stockNumController.clear();
  }
}
