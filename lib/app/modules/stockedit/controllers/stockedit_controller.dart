import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';

class StockeditController extends GetxController {
  final stockNum = "".obs;
  final stockNumController = TextEditingController();
  final stockData = StockTxModel().obs;

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

  Future<void> search() async {
    if (stockNum.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    if (stockNum.value.length != 6 && stockNum.value.length != 8) {
      QsHud.showToast(TextKey.shurugupiaotishinumerror.tr);
      return;
    }
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    QsHud.showLoading();
    var testQTRequest = await QsApi.instance()
        .requestStockData(stockCodes: [stockNum.toString()]);
    QsHud.dismiss();
    stockData.value = testQTRequest?.first ?? StockTxModel();
    print(stockData.value.code);
    // print(testQTRequest.toString());
  }

  Future<void> save() async {
    // QsApi.stocksList(
    //     stocks: "SZ000001",
    //     decodeType: StockListXqModel(),
    //     completionHandler: (model, error) {
    //       if (error == null) {
    //         print(model);
    //       } else {
    //         print(error);
    //       }
    //     });
    if (stockNum.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    if (stockNum.value.length != 6 && stockNum.value.length != 8) {
      QsHud.showToast(TextKey.shurugupiaotishinumerror.tr);
      return;
    }
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    QsHud.showLoading();
    var testQTRequest = await QsApi.instance()
        .requestStockData(stockCodes: [stockNum.toString()]);
    QsHud.dismiss();
    stockData.value = testQTRequest?.first ?? StockTxModel();
    print(stockData.value.code);
    // print(testQTRequest.toString());
  }

  void clearStockNum() {
    stockNumController.clear();
  }
}
