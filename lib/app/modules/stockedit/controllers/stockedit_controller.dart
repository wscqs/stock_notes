import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../common/web/webview_page.dart';

class StockeditController extends GetxController {
  final db = Get.find<DatabaseManager>().db;
  final stockNum = "".obs;
  final stockNumController = TextEditingController();
  final stockNumFocusNode = FocusNode();

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
  final isLocalData = false.obs;

  //针对卖买，计算收益率
  final pPriceYieldRate = 0.0.obs;
  final pMarketCapYieldRate = 0.0.obs;
  final pPeTtmYieldRate = 0.0.obs;
  //对应当前价格，计算点数
  final pPriceBuyPoints = 0.0.obs;
  final pMarketCapBuyPoints = 0.0.obs;
  final pPeTtmBuyPoints = 0.0.obs;
  final pPriceSalePoints = 0.0.obs;
  final pMarketCapSalePoints = 0.0.obs;
  final pPeTtmSalePoints = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    stockNumController.addListener(_updateStockNum);
    pPriceBuyController.addListener(_updateYieldRate);
    pPriceSaleController.addListener(_updateYieldRate);
    pMarketCapBuyController.addListener(_updateYieldRate);
    pMarketCapSaleController.addListener(_updateYieldRate);
    pPeTtmBuyController.addListener(_updateYieldRate);
    pPeTtmSaleController.addListener(_updateYieldRate);

    localStockData.value = Get.arguments;
    if (localStockData.value != null) {
      isLocalData.value = true;
      _dealHasLocalDataRefreshUI();
      // search();
    } else {
      Future.delayed(500.milliseconds, () {
        stockNumFocusNode.requestFocus();
      });
    }
  }

  //根据有没有本地数据，刷新页面
  void _dealHasLocalDataRefreshUI() {
    if (localStockData.value != null) {
      stockNum.value = localStockData.value?.code ?? "";
      stockNumController.text = stockNum.value;
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

      if ((serStockData.value.code ?? "").isEmpty) {
        serStockData.value = StockTxModel(
          marketType: localStockData.value?.marketType ?? "",
          name: localStockData.value?.name ?? "",
          code: localStockData.value?.code ?? "",
          currentPrice: localStockData.value?.currentPrice ?? "",
          peRatioTtm: localStockData.value?.peRatioTtm ?? "",
          totalMarketCap: localStockData.value?.totalMarketCap ?? "",
          pbRatio: localStockData.value?.pbRatio ?? "",
        );
      }
      _updateBuySalePoints();
    } else {
      // isLocalData.value = false;
      // stockNum.value ="";
      stockNumController.text = stockNum.value;
      pPriceBuyController.text = "";
      pPriceSaleController.text = "";
      pPriceRemarkController.text = "";
      pMarketCapBuyController.text = "";
      pMarketCapSaleController.text = "";
      pMarketRemarkController.text = "";
      pPeTtmBuyController.text = "";
      pPeTtmSaleController.text = "";
      pPeTtmRemarkController.text = "";
      pAllRemarkController.text = "";
      pEventRemarkController.text = "";
    }
  }

  void _updateStockNum() {
    stockNum.value = stockNumController.text;
  }

  void _updateYieldRate() {
    if (pPriceBuyController.text.isNotEmpty &&
        pPriceSaleController.text.isNotEmpty &&
        (double.tryParse(pPriceBuyController.text) ?? 0.0) >= 0) {
      pPriceYieldRate.value = (double.parse(pPriceSaleController.text) -
              double.parse(pPriceBuyController.text)) /
          double.parse(pPriceBuyController.text);
    }
    if (pMarketCapBuyController.text.isNotEmpty &&
        pMarketCapSaleController.text.isNotEmpty &&
        (double.tryParse(pMarketCapBuyController.text) ?? 0.0) >= 0) {
      pMarketCapYieldRate.value = (double.parse(pMarketCapSaleController.text) -
              double.parse(pMarketCapBuyController.text)) /
          double.parse(pMarketCapBuyController.text);
    }
    if (pPeTtmBuyController.text.isNotEmpty &&
        pPeTtmSaleController.text.isNotEmpty &&
        (double.tryParse(pPeTtmBuyController.text) ?? 0.0) >= 0) {
      pPeTtmYieldRate.value = (double.parse(pPeTtmSaleController.text) -
              double.parse(pPeTtmBuyController.text)) /
          double.parse(pPeTtmBuyController.text);
    }
    _updateBuySalePoints();
  }

  void _updateBuySalePoints() {
    if ((serStockData.value.code ?? "").isNotEmpty) {
      if (pPriceBuyController.text.isNotEmpty &&
          serStockData.value.currentPrice!.isNotEmpty) {
        pPriceBuyPoints.value = (double.parse(pPriceBuyController.text) -
                double.parse(serStockData.value.currentPrice!)) /
            double.parse(serStockData.value.currentPrice!);
      } else {
        pPriceBuyPoints.value = 0.0;
      }
      if (pMarketCapBuyController.text.isNotEmpty &&
          serStockData.value.totalMarketCap!.isNotEmpty) {
        pMarketCapBuyPoints.value =
            (double.parse(pMarketCapBuyController.text) -
                    double.parse(serStockData.value.totalMarketCap!)) /
                double.parse(serStockData.value.totalMarketCap!);
      } else {
        pMarketCapBuyPoints.value = 0.0;
      }
      if (pPeTtmBuyController.text.isNotEmpty &&
          serStockData.value.peRatioTtm!.isNotEmpty) {
        pPeTtmBuyPoints.value =
            ((double.tryParse(pPeTtmBuyController.text) ?? 0.0) -
                    double.parse(serStockData.value.peRatioTtm!)) /
                double.parse(serStockData.value.peRatioTtm!);
      } else {
        pPeTtmBuyPoints.value = 0.0;
      }
      if (pPriceSaleController.text.isNotEmpty &&
          serStockData.value.currentPrice!.isNotEmpty) {
        pPriceSalePoints.value = (double.parse(pPriceSaleController.text) -
                double.parse(serStockData.value.currentPrice!)) /
            double.parse(serStockData.value.currentPrice!);
      } else {
        pPriceSalePoints.value = 0.0;
      }
      if (pMarketCapSaleController.text.isNotEmpty &&
          serStockData.value.totalMarketCap!.isNotEmpty) {
        pMarketCapSalePoints.value =
            (double.parse(pMarketCapSaleController.text) -
                    double.parse(serStockData.value.totalMarketCap!)) /
                double.parse(serStockData.value.totalMarketCap!);
      } else {
        pMarketCapSalePoints.value = 0.0;
      }
      if (pPeTtmSaleController.text.isNotEmpty &&
          serStockData.value.peRatioTtm!.isNotEmpty) {
        pPeTtmSalePoints.value =
            ((double.tryParse(pPeTtmSaleController.text) ?? 0.0) -
                    double.parse(serStockData.value.peRatioTtm!)) /
                double.parse(serStockData.value.peRatioTtm!);
      } else {
        pPeTtmSalePoints.value = 0.0;
      }
    }
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
    // print(serStockData.value.code);

    if (serStockData.value.code != null) {
      //本地看看有没有，有就直接变修改本地数据
      if (!isLocalData.value) {
        final db = Get.find<DatabaseManager>().db;
        var stockItem = await db.getStockItem(serStockData.value.code!);
        localStockData.value = stockItem;
        _dealHasLocalDataRefreshUI();
      } else {
        //本地数据有值
        _updateBuySalePoints(); //更新买卖点数
        //数据库更新基本信息
        _updateDbStockBasicInfo();
      }
    }
  }

  void _updateDbStockBasicInfo() {
    StockItemsCompanion itemUpdate = StockItemsCompanion.insert(
      id: Value(localStockData.value!.id),
      marketType: serStockData.value.marketType!,
      code: serStockData.value.code!,
      name: serStockData.value.name!,
      currentPrice: Value(serStockData.value.currentPrice),
      totalMarketCap: Value(serStockData.value.totalMarketCap),
      peRatioTtm: Value(serStockData.value.peRatioTtm),
    );
    db.addStockOnConflictUpdateWithNoUpdateTime(itemUpdate);
  }

  Future<void> save() async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (serStockData.value.code == null || serStockData.value.code!.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
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
    Get.back();
  }

  void clearStockNum() {
    stockNumController.clear();
  }

  void clickLookStock() {
    String code = serStockData.value.code ?? ""; // 也可能是 sh000001、sz002415 等
    String prefix = code.substring(0, 2); // hs / sh / sz
    String number = code.substring(2); // 000506
    String stockCode = '${prefix}_$number';
    Get.to(() => WebViewPage(
          loadResource: "https://m.10jqka.com.cn/stockpage/$stockCode",
        ));
  }

  @override
  void onClose() {
    stockNumController.removeListener(_updateStockNum);
    stockNumController.dispose();
    pPriceBuyController.removeListener(_updateYieldRate);
    pPriceBuyController.dispose();
    pPriceSaleController.removeListener(_updateYieldRate);
    pPriceSaleController.dispose();
    pMarketCapBuyController.removeListener(_updateYieldRate);
    pMarketCapBuyController.dispose();
    pMarketCapSaleController.removeListener(_updateYieldRate);
    pMarketCapSaleController.dispose();
    pPeTtmBuyController.removeListener(_updateYieldRate);
    pPeTtmBuyController.dispose();
    pPeTtmSaleController.removeListener(_updateYieldRate);
    pPeTtmSaleController.dispose();
    super.onClose();
  }
}
