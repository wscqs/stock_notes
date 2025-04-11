import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/database.dart';

class StockeditController extends GetxController {
  final stockNum = "".obs;
  final stockNumController = TextEditingController();

  final pPriceBuyController = TextEditingController();
  final pPriceSaleController = TextEditingController();
  final pPriceRemarkController = TextEditingController();
  final pMarketCapBuyController = TextEditingController();
  final pMarketCapSaleController = TextEditingController();
  final pMarketRemarkController = TextEditingController();
  final pPeTtmBuyController = TextEditingController();
  final pPeTtmSaleController = TextEditingController();
  final pPeTtmRemarkController = TextEditingController();
  final pAllRemarkController = TextEditingController();
  final pEventRemarkController = TextEditingController();

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
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (stockData.value.code == null || stockData.value.code!.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    final db = AppDatabase();
    StockItemsCompanion item = StockItemsCompanion.insert(
      marketType: stockData.value.marketType!,
      code: stockData.value.code!,
      name: stockData.value.name!,
      currentPrice: Value(stockData.value.currentPrice),
      totalMarketCap: Value(stockData.value.totalMarketCap),
      peRatioTtm: Value(stockData.value.peRatioTtm),
      pPriceBuy: Value(pPriceBuyController.text),
      pPriceSale: Value(pPriceSaleController.text),
    );
    db.addStock(item);
    QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
  }

  void clearStockNum() {
    stockNumController.clear();
  }
}
