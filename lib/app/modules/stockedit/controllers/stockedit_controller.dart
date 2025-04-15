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

  final serStockData = StockTxModel().obs;
  final localStockData = Rxn<StockItem>();

  @override
  void onInit() {
    super.onInit();
    stockNumController.addListener(_updateStockNum);
    localStockData.value = Get.arguments;
    if (localStockData.value != null) {
      stockNum.value = localStockData.value?.code ?? "";
      stockNumController.text = stockNum.value;
      search();
      pPriceBuyController.text = localStockData.value?.pPriceBuy ?? "";
      pPriceSaleController.text = localStockData.value?.pPriceSale ?? "";
      pPriceRemarkController.text = localStockData.value?.pPriceRemark ?? "";
      pMarketCapBuyController.text = localStockData.value?.pMarketCapBuy ?? "";
      pMarketCapSaleController.text =
          localStockData.value?.pMarketCapSale ?? "";
      pMarketRemarkController.text = localStockData.value?.pMarketRemark ?? "";
      pPeTtmBuyController.text = localStockData.value?.pPeTtmBuy ?? "";
      pPeTtmSaleController.text = localStockData.value?.pPeTtmSale ?? "";
      pPeTtmRemarkController.text = localStockData.value?.pPeTtmRemark ?? "";
      pAllRemarkController.text = localStockData.value?.pAllRemark ?? "";
      pEventRemarkController.text = localStockData.value?.pEventRemark ?? "";

      // pMarketCapBuyController.text = localStockData.value!
    }
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
    serStockData.value = testQTRequest?.first ?? StockTxModel();
    print(serStockData.value.code);
    // print(testQTRequest.toString());
  }

  Future<void> save() async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (serStockData.value.code == null || serStockData.value.code!.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    final db = AppDatabase();
    StockItemsCompanion itemCompanion = StockItemsCompanion.insert(
      marketType: serStockData.value.marketType!,
      code: serStockData.value.code!,
      name: serStockData.value.name!,
      currentPrice: Value(serStockData.value.currentPrice),
      totalMarketCap: Value(serStockData.value.totalMarketCap),
      peRatioTtm: Value(serStockData.value.peRatioTtm),
      pPriceBuy: Value(pPriceBuyController.text),
      pPriceSale: Value(pPriceSaleController.text),
      pPriceRemark: Value(pPriceRemarkController.text),
      pMarketCapBuy: Value(pMarketCapBuyController.text),
      pMarketCapSale: Value(pMarketCapSaleController.text),
      pMarketRemark: Value(pMarketRemarkController.text),
      pPeTtmBuy: Value(pPeTtmBuyController.text),
      pPeTtmSale: Value(pPeTtmSaleController.text),
      pPeTtmRemark: Value(pPeTtmRemarkController.text),
      pAllRemark: Value(pAllRemarkController.text),
      pEventRemark: Value(pEventRemarkController.text),
    );
    if (localStockData.value != null) {
      //localStockData 更新
      StockItemsCompanion itemUpdate = itemCompanion.copyWith(
        id: Value(localStockData.value!.id),
      );
      db.addStockOnConflictUpdate(itemUpdate);
    } else {
      db.addStock(itemCompanion);
    }
    QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
  }

  void clearStockNum() {
    stockNumController.clear();
  }
}
