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
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

class StockeditController extends BaseController {
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
  final rAllRemarkController = TextEditingController();
  final rEventRemarkController = TextEditingController();
  final rBuyPriceController = TextEditingController();

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
  final rBuyPriceYieldRate = 0.00001.obs;

  var isFirstCome = true;

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
    rBuyPriceController.addListener(_updateBuyPriceYieldRate);

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
      rBuyPriceController.text = localStockData.value?.rBuyPrice ?? "";
      rAllRemarkController.text = localStockData.value?.rAllRemark ?? "";
      rEventRemarkController.text = localStockData.value?.rEventRemark ?? "";

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
      rAllRemarkController.text = "";
      rEventRemarkController.text = "";
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

  void _updateBuyPriceYieldRate() {
    if ((serStockData.value.code ?? "").isNotEmpty) {
      final buyPriceText = rBuyPriceController.text;
      final currentPriceText = serStockData.value.currentPrice;

      final buyPrice = double.tryParse(buyPriceText);
      final currentPrice = double.tryParse(currentPriceText ?? "");

      if (buyPrice != null && buyPrice != 0 && currentPrice != null) {
        rBuyPriceYieldRate.value = (currentPrice - buyPrice) / buyPrice;
      } else {
        rBuyPriceYieldRate.value = 0.00001;
      }
    }
  }

  void _updateBuySalePoints() {
    if ((serStockData.value.code ?? "").isNotEmpty) {
      _updateBuyPriceYieldRate();
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

  Future<void> firstSaveDbAndRefreshUI() async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (serStockData.value.code != null) {
      //本地看看有没有，有就直接变修改本地数据
      if (!isLocalData.value) {
        final db = Get.find<DatabaseManager>().db;
        var stockItem = await db.getStockItem(serStockData.value.code!);
        localStockData.value = stockItem;
        isLocalData.value = true;
        _dealHasLocalDataRefreshUI();
      }
    }
  }

  //进入别的页面后后退刷新UI(现在只改变了标签）
  Future<void> _dbSomeDataRefreshUI() async {
    if (isLocalData.value) {
      final db = Get.find<DatabaseManager>().db;
      var stockItem =
          await db.getStockItemWithTagsByCode(localStockData.value!.code!);
      localStockData.value!.tagList = stockItem!.tagList;
      localStockData.refresh();
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
      rBuyPrice: Value(rBuyPriceController.text),
      rAllRemark: Value(rAllRemarkController.text),
      rEventRemark: Value(rEventRemarkController.text),
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
    if (!isLocalData.value) {
      firstSaveDbAndRefreshUI();
    } else {
      Get.back();
    }
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
    rBuyPriceController.removeListener(_updateBuyPriceYieldRate);
    rBuyPriceController.dispose();
    super.onClose();
  }

  void clickOpCollect() {
    // db.updateStockWithOp(item.copyWith(opCollect: !item.opCollect));
    // getDatas();
  }

  void clickOpBuy() {
    // db.updateStockWithOp(item.copyWith(opBuy: !item.opBuy));
    // getDatas();
  }

  void clickOpRestore() {
    // db.updateStockWithOp(item.copyWith(opDelete: false));
    // getDatas();
  }

  void clickOpDelete() {
    // if (isCurrentDeleteList()) {
    //   //删除列表真正删除
    //   db.deleteStock(item);
    // } else {
    //   db.updateStockWithOp(item.copyWith(opDelete: true));
    // }
    // getDatas();
  }

  //本地删除
  void clickDbDelete() {
    // db.deleteStock(item);
    // getDatas();
  }

  void clickPushTag() {
    if (!isLocalData.value) {
      QsHud.showToast("请先保存到数据库");
      return;
    }
    Get.toNamed(Routes.TAGSEDIT, arguments: localStockData.value);
  }

  @override
  void onResume() {
    super.onResume();
    if (isFirstCome) {
      isFirstCome = false;
    } else {
      _dbSomeDataRefreshUI(); //后退才刷新UI
    }
  }

  @override
  void onPause() {
    super.onPause();
  }
}
