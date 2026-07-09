import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/services/stock_name_service.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';
import 'package:stock_notes/utils/share_image_util.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../common/web/webview_page.dart';
import '../../base/base_controller.dart';
import '../../tagsedit/views/tagsedit_view.dart';

class StockeditController extends BaseController {
  final db = Get.find<DatabaseManager>().db;
  final stockNum = "".obs;
  final stockNumController = TextEditingController();
  final stockNumFocusNode = FocusNode();
  final searchFieldKey = GlobalKey();
  final contentKey = GlobalKey(); // 用于截图滚动全部内容
  static const _attachTag = 'stock_search_suggestions';

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
  final searchSuggestions = <MapEntry<String, String>>[].obs;

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

  //交易记录
  final stockTrades = <StockTrade>[].obs;
  final tradePriceController = TextEditingController();
  final tradeSharesController = TextEditingController();
  final tradeRemarkController = TextEditingController();
  final tradeType = 0.obs; // 0=买, 1=卖

  var isFirstCome = true;
  var _ignoreNextSuggestionUpdate = false;

  @override
  void onInit() {
    super.onInit();
    stockNumController.addListener(_updateStockNum);
    stockNumFocusNode.addListener(_onStockNumFocusChange);
    debounce(stockNum, (_) => _updateSearchSuggestions(), time: 200.milliseconds);
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
      loadTrades();
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

  /// 搜索框焦点变化监听：获得焦点时尝试弹出联想，失去焦点时关闭弹窗
  void _onStockNumFocusChange() {
    if (stockNumFocusNode.hasFocus) {
      _updateSearchSuggestions();
    } else {
      _dismissAttachPopup();
    }
  }

  /// 根据输入文本从本地 A 股 code/name 缓存联想
  void _updateSearchSuggestions() {
    if (_ignoreNextSuggestionUpdate) {
      _ignoreNextSuggestionUpdate = false;
      _dismissAttachPopup();
      return;
    }
    final keyword = stockNumController.text.trim();
    if (keyword.isEmpty) {
      searchSuggestions.clear();
      _dismissAttachPopup();
      return;
    }
    searchSuggestions.value = StockNameService.search(keyword);
    if (searchSuggestions.isNotEmpty) {
      _showAttachPopup();
    } else {
      _dismissAttachPopup();
    }
  }

  /// 点击搜索建议：填充 code 并触发搜索
  void selectSearchSuggestion(MapEntry<String, String> entry) {
    _ignoreNextSuggestionUpdate = true;
    stockNumController.text = entry.key;
    stockNum.value = entry.key;
    searchSuggestions.clear();
    _dismissAttachPopup();
    search();
  }

  /// 显示搜索建议弹窗（锚定在搜索框下方）
  void _showAttachPopup() {
    if (SmartDialog.checkExist(tag: _attachTag)) return;
    if (searchFieldKey.currentContext == null) return;
    SmartDialog.showAttach(
      tag: _attachTag,
      targetContext: searchFieldKey.currentContext,
      alignment: Alignment.bottomCenter,
      maskColor: Colors.transparent,
      clickMaskDismiss: false,
      usePenetrate: true,
      keepSingle: true,
      builder: (_) => _buildSuggestionsPopup(),
    );
  }

  /// 关闭搜索建议弹窗
  void _dismissAttachPopup() {
    SmartDialog.dismiss(tag: _attachTag);
  }

  /// 弹窗内容：Obx 监听 searchSuggestions，实时刷新
  Widget _buildSuggestionsPopup() {
    return Obx(() {
      final suggestions = searchSuggestions.toList();
      if (suggestions.isEmpty) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _dismissAttachPopup());
        return const SizedBox.shrink();
      }
      final theme = Get.theme;
      final textTheme = Get.textTheme;
      return Container(
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: const BoxConstraints(maxHeight: 220, maxWidth: 280),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final entry = suggestions[index];
            return InkWell(
              key: ValueKey(entry.key),
              onTap: () {
                selectSearchSuggestion(entry);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: index != suggestions.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.5),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.value,
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
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
    //更新满足或临近买卖
    serStockData.value.setConditions(
      pPriceBuy: pPriceBuyController.text,
      pPriceSale: pPriceSaleController.text,
      pMarketCapBuy: pMarketCapBuyController.text,
      pMarketCapSale: pMarketCapSaleController.text,
      pPeTtmBuy: pPeTtmBuyController.text,
      pPeTtmSale: pPeTtmSaleController.text,
    );
  }

  Future<void> search() async {
    if (stockNum.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    // if (stockNum.value.length != 6 && stockNum.value.length != 8) {
    //   QsHud.showToast(TextKey.shurugupiaotishinumerror.tr);
    //   return;
    // }
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
  Future<void> refreshTags() async {
    if (isLocalData.value) {
      final db = Get.find<DatabaseManager>().db;
      var stockItem =
          await db.getStockItemWithTagsByCode(localStockData.value!.code!);
      localStockData.value!.tagList = stockItem!.tagList;
      localStockData.refresh();
    }
  }

  //恢复功能现在有用这
  Future<void> _dbAllDataRefreshUI() async {
    if (isLocalData.value) {
      final db = Get.find<DatabaseManager>().db;
      var stockItem =
          await db.getStockItemWithTagsByCode(localStockData.value!.code!);
      localStockData.value = stockItem;
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

  Future<void> save({bool isBack = true}) async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (serStockData.value.code == null || serStockData.value.code!.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }

    // 主要更新cMeetUpdateAt与cNearUpdateAt,其实也可以做提醒（就时间排序就好）
    StockTxModel tempItem = serStockData.value!;
    DateTime cMeetUpdateAt = DateTime.now();
    DateTime cNearUpdateAt = DateTime.now();
    if (isLocalData.value) {
      cMeetUpdateAt = localStockData.value!.cMeetUpdateAt;
      cNearUpdateAt = localStockData.value!.cNearUpdateAt;
      StockItem item = localStockData.value!;
      if (tempItem.priceCondition.isNear && !item.cPriceCondition.isNear ||
          tempItem.marketCapCondition.isNear &&
              !item.cMarketCapCondition.isNear ||
          tempItem.peTtmCondition.isNear && !item.cPeTtmCondition.isNear) {
        cNearUpdateAt = DateTime.now();
      }
      if (tempItem.priceCondition.isTarget && !item.cPriceCondition.isTarget ||
          tempItem.marketCapCondition.isTarget &&
              !item.cMarketCapCondition.isTarget ||
          tempItem.peTtmCondition.isTarget && !item.cPeTtmCondition.isTarget) {
        cMeetUpdateAt = DateTime.now();
      }
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
      cMeetUpdateAt: Value(cMeetUpdateAt),
      cNearUpdateAt: Value(cNearUpdateAt),
      cMarketCapCondition: Value(tempItem.marketCapCondition),
      cPriceCondition: Value(tempItem.priceCondition),
      cPeTtmCondition: Value(tempItem.peTtmCondition),
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
    if (isBack) {
      Get.back();
    }
  }

  void _popSaveAlert({String title = "", VoidCallback? onConfirm}) {
    QsHud.showConfirmDialog(
        title: title,
        content: TextKey.cicaozuoxubaocun.tr,
        confirmText: TextKey.baocunbingcaozu.tr,
        onConfirm: () async {
          if (!isLocalData.value) {
            save(isBack: false);
            await firstSaveDbAndRefreshUI();
          }
          onConfirm?.call();
        });
  }

  void clearStockNum() {
    stockNumController.clear();
    searchSuggestions.clear();
    _dismissAttachPopup();
  }

  void clickLookStock() {
    String code = serStockData.value.code ?? ""; // 也可能是 sh000001、sz002415 等
    String prefix = code.substring(0, 2); // hs / sh / sz
    String number = code.substring(2); // 000506
    String stockCode = '${prefix}_$number';
    String loadResource = "https://m.10jqka.com.cn/stockpage/$stockCode"; //同花顺
    loadResource =
        "https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=$number"; //百度
    if (prefix == "sh" || prefix == "sz") {
      if (number.startsWith("5") || number.startsWith("1")) {
        //基金
        loadResource = "https://m.10jqka.com.cn/stockpage/hs_$number";
      }
    }
    // loadResource = "https://xueqiu.com/S/sh601126/";
    Get.to(() => WebViewPage(
          loadResource: loadResource,
        ));
  }

  //扫雷宝
  void clickLookMinesweeper() {
    String code = serStockData.value.code ?? ""; // 也可能是 sh000001、sz002415 等
    String prefix = code.substring(0, 2); // hs / sh / sz
    String number = code.substring(2); // 000506
    String stockCode = '${prefix}_$number';
    Get.to(() => WebViewPage(
          loadResource:
              "https://bowerbird.10jqka.com.cn/thslc/editor/view/433f6d9Ac0?code=$number",
        ));
  }

  @override
  void onClose() {
    _dismissAttachPopup();
    stockNumController.removeListener(_updateStockNum);
    stockNumFocusNode.removeListener(_onStockNumFocusChange);
    stockNumController.dispose();
    stockNumFocusNode.dispose();
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
    tradePriceController.dispose();
    tradeSharesController.dispose();
    tradeRemarkController.dispose();
    super.onClose();
  }

  Future<void> clickShare() async {
    if (isClosed) return;
    final subject = (serStockData.value.name ?? "").isNotEmpty
        ? '${serStockData.value.name} (${serStockData.value.code ?? ""})'
        : TextKey.gupiao.tr;
    if (isClosed) return;
    await ShareImageUtil.share(
      key: contentKey,
      subject: subject,
      filePrefix: 'stock_share_${stockNum.value}',
    );
  }

  void clickOpCollect() {
    if (!isLocalData.value) {
      _popSaveAlert(
          title: TextKey.collect.tr,
          onConfirm: () {
            clickOpCollect();
          });
      return;
    }
    db.updateStockWithOp(localStockData.value!
        .copyWith(opCollect: !localStockData.value!.opCollect));
    _dbAllDataRefreshUI();
  }

  void clickOpBuy() {
    if (!isLocalData.value) {
      _popSaveAlert(
          title: TextKey.chiyou.tr,
          onConfirm: () {
            clickOpBuy();
          });
      return;
    }
    db.updateStockWithOp(
        localStockData.value!.copyWith(opBuy: !localStockData.value!.opBuy));
    _dbAllDataRefreshUI();
  }

  void clickOpRestore() {
    db.updateStockWithOp(localStockData.value!.copyWith(opDelete: false));
    isLocalData.value = true;
    _dbAllDataRefreshUI();
  }

  void clickOpDelete() {
    if (!isLocalData.value) {
      // _popSaveAlert(() {
      //   clickOpDelete();
      // });
      return;
    }
    if (localStockData.value?.opDelete ?? false) {
      db.deleteStock(localStockData.value!);
      QsHud.showToast(TextKey.delete.tr + TextKey.success.tr);
      Get.back();
    } else {
      db.updateStockWithOp(localStockData.value!.copyWith(opDelete: true));
      QsHud.showToast(TextKey.yidaoshanchuliebiao.tr);
      Get.back();
    }
  }

  void clickPushTag() {
    if (!isLocalData.value) {
      _popSaveAlert(
          title: TextKey.biaoqian.tr,
          onConfirm: () {
            clickPushTag();
          });
      return;
    }
    TagseditView.show(localStockData.value!);
  }

  @override
  void onResume() {
    super.onResume();
    if (isFirstCome) {
      isFirstCome = false;
    } else {
      refreshTags(); //后退才刷新UI
    }
  }

  @override
  void onPause() {
    super.onPause();
  }

  // ========== 交易记录 ==========

  Future<void> loadTrades() async {
    if (localStockData.value != null) {
      final trades =
          await db.getStockTradesByStockId(localStockData.value!.id);
      stockTrades.value = trades;
    }
  }

  void showAddTradeDialog() {
    if (!isLocalData.value) {
      _popSaveAlert(
          title: TextKey.jiaoyi.tr,
          onConfirm: () {
            showAddTradeDialog();
          });
      return;
    }
    tradeType.value = 0;
    tradePriceController.clear();
    tradeSharesController.clear();
    tradeRemarkController.clear();

    QsHud.showDialog(AlertDialog(
      title: Text(TextKey.xinzengjiaoyi.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Row(
              children: [
                ChoiceChip(
                  label: Text(TextKey.buy.tr),
                  selected: tradeType.value == 0,
                  onSelected: (selected) {
                    if (selected) tradeType.value = 0;
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: Text(TextKey.sale.tr),
                  selected: tradeType.value == 1,
                  onSelected: (selected) {
                    if (selected) tradeType.value = 1;
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
          TextField(
            controller: tradePriceController,
            decoration: InputDecoration(labelText: TextKey.jiage.tr),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tradeSharesController,
            decoration: InputDecoration(labelText: TextKey.gushu.tr),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tradeRemarkController,
            maxLines: 2,
            decoration: InputDecoration(labelText: TextKey.beizui.tr),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            QsHud.dismiss();
          },
          child: Text(TextKey.quxiao.tr),
        ),
        TextButton(
          onPressed: () {
            addTrade();
          },
          child: Text(TextKey.queding.tr),
        ),
      ],
    ));
  }

  Future<void> addTrade() async {
    if (tradePriceController.text.isEmpty) {
      QsHud.showToast("${TextKey.qingshuru.tr}${TextKey.jiage.tr}");
      return;
    }
    final item = StockTradesCompanion.insert(
      stockId: localStockData.value!.id,
      tradeType: tradeType.value,
      price: Value(tradePriceController.text),
      shares: Value(tradeSharesController.text),
      remark: Value(tradeRemarkController.text),
    );
    await db.addStockTrade(item);
    QsHud.dismiss();
    QsHud.showToast(TextKey.success.tr);
    loadTrades();
  }

  void deleteTrade(StockTrade trade) {
    QsHud.showConfirmDialog(
      title: TextKey.querengdelete.tr,
      content: "",
      onConfirm: () async {
        await db.deleteStockTrade(trade);
        loadTrades();
      },
    );
  }
}
