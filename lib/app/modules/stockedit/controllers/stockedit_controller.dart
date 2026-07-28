import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/services/stock_name_service.dart';
import 'package:stock_notes/common/web/stock_ext_links.dart';
import 'package:stock_notes/common/web/webview_widget.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
import 'package:stock_notes/utils/qs_hud.dart';
import 'package:stock_notes/utils/qs_link_opener.dart';
import 'package:stock_notes/utils/share_image_util.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../common/web/webview_page.dart';
import '../../../../utils/stock_link_utils.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_controller.dart';
import '../../tagsedit/views/tagsedit_view.dart';

/// Pure calculation used by [StockeditController.calculateTradeEstimate].
/// Returns the estimated yield rate and, when [openShares] is valid, the profit.
/// [tradeType] 0=buy (买 / long), 1=sell (卖 / short).
/// For long: open is the buy, close is the sell.
/// For short: open is the sell, close is the buy/cover.
/// When [openShares] equals [closeShares] and [closePrice] is valid, profit is
/// realized using the actual close price; otherwise it uses [currentPrice] for
/// unrealized profit.
({double? yieldRate, double? profit}) calculateTradeEstimateFromValues({
  required String? currentPrice,
  required String? openPrice,
  required String? closePrice,
  required String? openShares,
  required String? closeShares,
  required int tradeType,
}) {
  if (currentPrice == null ||
      currentPrice.isEmpty ||
      openPrice == null ||
      openPrice.isEmpty) {
    return (yieldRate: null, profit: null);
  }

  final current = double.tryParse(currentPrice);
  final open = double.tryParse(openPrice);
  if (current == null || open == null || open == 0) {
    return (yieldRate: null, profit: null);
  }

  final isShort = tradeType == 1; // 卖 = 先卖后买
  final yieldRate = isShort ? (open - current) / open : (current - open) / open;

  double? profit;
  final openCount = double.tryParse(openShares ?? '');
  final closeCount = double.tryParse(closeShares ?? '');
  final hasClose = closePrice != null && closePrice.isNotEmpty;
  final close = hasClose ? double.tryParse(closePrice) : null;

  if (openCount != null && openCount > 0) {
    if (closeCount != null &&
        closeCount > 0 &&
        openCount == closeCount &&
        close != null) {
      profit =
          isShort ? (open - close) * openCount : (close - open) * openCount;
    } else {
      profit =
          isShort ? (open - current) * openCount : (current - open) * openCount;
    }
  }

  return (yieldRate: yieldRate, profit: profit);
}

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
  final rHoldSharesController = TextEditingController();

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
  //成本价/持有股数是否有效（决定股数输入框与收益信息展示）
  final rBuyPriceValid = false.obs;
  final rHoldSharesValid = false.obs;
  final rHoldProfit = 0.0.obs; //收益额
  final rHoldMarketValue = 0.0.obs; //持有总市值

  //交易记录
  final stockTrades = <StockTrade>[].obs;
  final openPriceController = TextEditingController();
  final openSharesController = TextEditingController();
  final closePriceController = TextEditingController();
  final closeSharesController = TextEditingController();
  final planBuyPriceController = TextEditingController();
  final planSalePriceController = TextEditingController();
  final tradeRemarkController = TextEditingController();
  final tradeType = 0.obs; // 0=买, 1=卖
  final tradeDate = (() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  })()
      .obs;

  //股票笔记（大备注）预览
  final noteQuillController = QuillController.basic();
  final notePreviewFocusNode = FocusNode();
  final notePreviewScrollController = ScrollController();
  final hasNote = false.obs;

  //外链功能按钮勾选（全局配置）
  final extLinkIds = <String>[].obs;

  var isFirstCome = true;
  var _ignoreNextSuggestionUpdate = false;
  var _wasPaused = false;

  @override
  void onInit() {
    super.onInit();
    noteQuillController.readOnly = true; //笔记预览只读
    extLinkIds.value = StockExtLinks.selectedIds();
    stockNumController.addListener(_updateStockNum);
    stockNumFocusNode.addListener(_onStockNumFocusChange);
    debounce(stockNum, (_) => _updateSearchSuggestions(),
        time: 200.milliseconds);
    pPriceBuyController.addListener(_updateYieldRate);
    pPriceSaleController.addListener(_updateYieldRate);
    pMarketCapBuyController.addListener(_updateYieldRate);
    pMarketCapSaleController.addListener(_updateYieldRate);
    pPeTtmBuyController.addListener(_updateYieldRate);
    pPeTtmSaleController.addListener(_updateYieldRate);
    rBuyPriceController.addListener(_updateBuyPriceYieldRate);
    rHoldSharesController.addListener(_updateBuyPriceYieldRate);

    final args = Get.arguments;
    if (args is StockItem) {
      localStockData.value = args;
    }
    if (localStockData.value != null) {
      isLocalData.value = true;
      _dealHasLocalDataRefreshUI();
      loadTrades();
      // search();
    } else if (args is String && args.isNotEmpty) {
      // 文本分享识别出的股票代码：预填并自动搜索（search 内部会回查本地库）
      stockNum.value = args;
      stockNumController.text = args;
      Future.delayed(300.milliseconds, () {
        search();
      });
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
      rHoldSharesController.text = localStockData.value?.rHoldShares ?? "";
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
      _refreshNotePreview();
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
    // 搜索框未聚焦（如已点搜索/选中建议）时不弹联想，并关掉残留弹窗
    if (keyword.isEmpty || !stockNumFocusNode.hasFocus) {
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
    final priceBuy = double.tryParse(pPriceBuyController.text);
    final priceSale = double.tryParse(pPriceSaleController.text);
    if (priceBuy != null && priceSale != null && priceBuy > 0) {
      pPriceYieldRate.value = (priceSale - priceBuy) / priceBuy;
    } else {
      pPriceYieldRate.value = 0.0;
    }

    final marketCapBuy = double.tryParse(pMarketCapBuyController.text);
    final marketCapSale = double.tryParse(pMarketCapSaleController.text);
    if (marketCapBuy != null && marketCapSale != null && marketCapBuy > 0) {
      pMarketCapYieldRate.value = (marketCapSale - marketCapBuy) / marketCapBuy;
    } else {
      pMarketCapYieldRate.value = 0.0;
    }

    final peTtmBuy = double.tryParse(pPeTtmBuyController.text);
    final peTtmSale = double.tryParse(pPeTtmSaleController.text);
    if (peTtmBuy != null && peTtmSale != null && peTtmBuy > 0) {
      pPeTtmYieldRate.value = (peTtmSale - peTtmBuy) / peTtmBuy;
    } else {
      pPeTtmYieldRate.value = 0.0;
    }

    _updateBuySalePoints();
  }

  void _updateBuyPriceYieldRate() {
    final buyPrice = double.tryParse(rBuyPriceController.text);
    rBuyPriceValid.value = buyPrice != null && buyPrice > 0;
    final shares = double.tryParse(rHoldSharesController.text);
    rHoldSharesValid.value = shares != null && shares > 0;
    rHoldProfit.value = 0.0;
    rHoldMarketValue.value = 0.0;
    if ((serStockData.value.code ?? "").isNotEmpty) {
      final currentPrice =
          double.tryParse(serStockData.value.currentPrice ?? "");

      if (buyPrice != null && buyPrice != 0 && currentPrice != null) {
        rBuyPriceYieldRate.value = (currentPrice - buyPrice) / buyPrice;
      } else {
        rBuyPriceYieldRate.value = 0.00001;
      }
      if (currentPrice != null && rHoldSharesValid.value) {
        rHoldMarketValue.value = currentPrice * shares!;
        if (buyPrice != null) {
          rHoldProfit.value = (currentPrice - buyPrice) * shares;
        }
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
    //点搜索后关闭股票名称/代码匹配提示弹窗
    _dismissAttachPopup();
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
        if (stockItem != null) {
          localStockData.value = stockItem;
          isLocalData.value = true;
          _dealHasLocalDataRefreshUI();
          loadTrades();
        }
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

  //进入别的页面后后退刷新UI（标签与笔记）
  Future<void> refreshTags() async {
    if (isLocalData.value) {
      final db = Get.find<DatabaseManager>().db;
      var stockItem =
          await db.getStockItemWithTagsByCode(localStockData.value!.code!);
      if (stockItem != null) {
        localStockData.value = stockItem;
        _refreshNotePreview();
      }
    }
  }

  //刷新笔记（大备注）预览
  String? _lastNoteContent;
  void _refreshNotePreview() {
    final content = localStockData.value?.rNote;
    if (content != null && content.isNotEmpty) {
      try {
        if (content != _lastNoteContent) {
          _lastNoteContent = content;
          //文档变更会通知只读编辑器，键盘隐藏时它会 requestFocus 抢焦点，
          //用 ignoreFocusOnTextChange 抑制（flutter_quill 自带机制）
          noteQuillController.ignoreFocusOnTextChange = true;
          noteQuillController.document = Document.fromJson(jsonDecode(content));
          noteQuillController.ignoreFocusOnTextChange = false;
        }
        hasNote.value = true;
        return;
      } catch (_) {
        noteQuillController.ignoreFocusOnTextChange = false;
      }
    }
    hasNote.value = false;
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
      rHoldShares: Value(rHoldSharesController.text),
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
      // 新股票保存后如果留在当前页，需要同步本地状态，否则后续操作仍提示保存
      if (!isBack) {
        await firstSaveDbAndRefreshUI();
      }
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

  /// 打开外链（功能按钮或弹窗预览共用）
  Future<void> openExtLink(StockExtLink link) async {
    final code = serStockData.value.code ?? '';
    if (code.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    final String? resource;
    try {
      resource = await StockExtLinks.buildLoadResource(link, code);
    } catch (_) {
      QsHud.showToast(TextKey.jiazashibai.tr);
      return;
    }
    if (resource == null) {
      QsHud.showToast(TextKey.zanshibuzhichi.tr);
      return;
    }
    final loadResource = resource;
    Get.to(() => WebViewPage(
          loadResource: loadResource,
          webViewType:
              link.isLocalAsset ? WebViewType.HTMLTEXT : WebViewType.URL,
          title: link.title,
        ));
  }

  /// 弹窗内预览：不关闭弹窗，返回后勾选状态保留
  void previewExtLink(StockExtLink link) {
    openExtLink(link);
  }

  /// 选择关联链接弹窗：多选 + 预览 + 拖拽排序，确定后写全局缓存并刷新按钮
  void showExtLinkPicker() {
    FocusManager.instance.primaryFocus?.unfocus();
    _wasPaused = true;
    final tempOrder = StockExtLinks.orderedIds().toList();
    final tempSelected = extLinkIds.toSet();
    Get.dialog(StatefulBuilder(
      builder: (context, setState) {
        void toggle(String id, bool checked) {
          setState(() {
            if (checked) {
              tempSelected.remove(id);
            } else {
              tempSelected.add(id);
            }
          });
        }

        Widget buildCell(String id, int index) {
          final link = StockExtLinks.byId(id);
          if (link == null) return SizedBox.shrink(key: ValueKey(id));
          final checked = tempSelected.contains(id);
          return Row(
            key: ValueKey(id),
            children: [
              Checkbox(
                value: checked,
                onChanged: (_) => toggle(id, checked),
              ),
              Icon(link.icon, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => toggle(id, checked),
                  child: Text(link.title),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                tooltip: link.title,
                onPressed: () => previewExtLink(link),
              ),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    RemixIcons.drag_move_2_line,
                    size: 20,
                    color: Get.theme.hintColor,
                  ),
                ),
              ),
            ],
          );
        }

        return AlertDialog(
          title: Text(TextKey.xuanzeguanlianlianjie.tr,
              style: const TextStyle(fontSize: 20)),
          content: SizedBox(
            width: double.maxFinite,
            child: ReorderableListView(
              shrinkWrap: true,
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final id = tempOrder.removeAt(oldIndex);
                  tempOrder.insert(newIndex, id);
                });
              },
              children: [
                for (var i = 0; i < tempOrder.length; i++)
                  buildCell(tempOrder[i], i),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(TextKey.quxiao.tr),
            ),
            TextButton(
              onPressed: () {
                StockExtLinks.saveOrderedIds(tempOrder);
                final ordered = tempOrder.where(tempSelected.contains).toList();
                StockExtLinks.saveSelectedIds(ordered);
                extLinkIds.value = ordered;
                Get.back();
              },
              child: Text(TextKey.queding.tr),
            ),
          ],
        );
      },
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
    rHoldSharesController.removeListener(_updateBuyPriceYieldRate);
    rHoldSharesController.dispose();
    openPriceController.dispose();
    openSharesController.dispose();
    closePriceController.dispose();
    closeSharesController.dispose();
    planBuyPriceController.dispose();
    planSalePriceController.dispose();
    tradeRemarkController.dispose();
    noteQuillController.dispose();
    notePreviewFocusNode.dispose();
    notePreviewScrollController.dispose();
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
    FocusManager.instance.primaryFocus?.unfocus();
    _wasPaused = true;
    TagseditView.show(localStockData.value!);
  }

  //笔记（大备注）：未保存股票时先提示保存
  void clickPushNote() {
    if (!isLocalData.value) {
      _popSaveAlert(
          title: TextKey.biji.tr,
          onConfirm: () {
            clickPushNote();
          });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _wasPaused = true;
    //带上最新价格：实时行情优先，其次本地缓存
    final price = (serStockData.value.currentPrice?.isNotEmpty == true)
        ? serStockData.value.currentPrice
        : localStockData.value?.currentPrice;
    Get.toNamed(Routes.STOCKNOTE,
        arguments: localStockData.value!.copyWith(currentPrice: Value(price)));
  }

  /// 处理笔记预览中链接的点击事件（支持股票链接与应用内 http/https 链接）
  Future<void> handleLinkTap(String link) async {
    final normalizedLink = link.trim().toLowerCase();
    if (normalizedLink.startsWith('http://') ||
        normalizedLink.startsWith('https://')) {
      FocusManager.instance.primaryFocus?.unfocus();
      _wasPaused = true;
      await openLinkInAppWebView(link);
      return;
    }

    final code = StockLinkUtils.parseStockCodeFromLink(link);
    if (code == null) return;

    // 数据库中 code 可能是小写，优先尝试小写查询
    var stockItem = await db.getStockItemWithTagsByCode(code.toLowerCase());
    stockItem ??= await db.getStockItemWithTagsByCode(code);

    if (stockItem != null) {
      Get.toNamed(Routes.STOCKEDIT, arguments: stockItem);
    } else {
      QsHud.showToast('未找到该股票记录');
    }
  }

  @override
  void onResume() {
    super.onResume();
    if (isFirstCome) {
      isFirstCome = false;
    } else if (_wasPaused) {
      _wasPaused = false;
      // 从标签/笔记页返回时，取消可能自动恢复的输入框焦点，避免键盘自动弹出
      FocusManager.instance.primaryFocus?.unfocus();
      refreshTags(); //后退才刷新UI
    }
  }

  @override
  void onPause() {
    super.onPause();
    _wasPaused = true;
  }

  // ========== 交易记录 ==========

  Future<void> loadTrades() async {
    if (localStockData.value != null) {
      final trades = await db.getStockTradesByStockId(localStockData.value!.id);
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
    _showTradeDialog();
  }

  void editTrade(StockTrade trade) {
    _showTradeDialog(existingTrade: trade);
  }

  void _showTradeDialog({StockTrade? existingTrade}) {
    final isEdit = existingTrade != null;
    tradeType.value = isEdit ? existingTrade.tradeType : 0;
    tradeDate.value = isEdit
        ? (existingTrade.tradeDate ??
            (() {
              final now = DateTime.now();
              return DateTime(now.year, now.month, now.day);
            })())
        : (() {
            final now = DateTime.now();
            return DateTime(now.year, now.month, now.day);
          })();
    openPriceController.text =
        existingTrade?.openPrice ?? existingTrade?.price ?? "";
    openSharesController.text =
        existingTrade?.openShares ?? existingTrade?.shares ?? "";
    closePriceController.text = existingTrade?.closePrice ?? "";
    closeSharesController.text = existingTrade?.closeShares ?? "";
    planBuyPriceController.text = existingTrade?.planBuyPrice ?? "";
    planSalePriceController.text = existingTrade?.planSalePrice ?? "";
    tradeRemarkController.text = existingTrade?.remark ?? "";

    final planBuyPoints = 0.0.obs;
    final planSalePoints = 0.0.obs;

    void updatePlanPricePoints() {
      final currentPrice =
          double.tryParse(serStockData.value.currentPrice ?? "");
      final buyPrice = double.tryParse(planBuyPriceController.text);
      final salePrice = double.tryParse(planSalePriceController.text);

      if (buyPrice != null && currentPrice != null && currentPrice != 0) {
        planBuyPoints.value = (buyPrice - currentPrice) / currentPrice;
      } else {
        planBuyPoints.value = 0.0;
      }

      if (salePrice != null && currentPrice != null && currentPrice != 0) {
        planSalePoints.value = (salePrice - currentPrice) / currentPrice;
      } else {
        planSalePoints.value = 0.0;
      }
    }

    updatePlanPricePoints();

    Get.dialog(AlertDialog(
      title: Text(isEdit ? TextKey.xiugai.tr : TextKey.xinzengjiaoyi.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Row(
                children: [
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(TextKey.buy.tr),
                    selected: tradeType.value == 0,
                    onSelected: (selected) {
                      if (selected) tradeType.value = 0;
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(TextKey.sale.tr),
                    selected: tradeType.value == 1,
                    onSelected: (selected) {
                      if (selected) tradeType.value = 1;
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: ValueKey(tradeDate.value),
                      //不要下划线
                      // decoration: InputDecoration(
                      //   border: InputBorder.none,
                      // ),
                      readOnly: true,
                      textAlign: TextAlign.center,
                      initialValue:
                          DateFormat('yyyy-MM-dd').format(tradeDate.value),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: tradeDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          tradeDate.value = picked;
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 4),
            // 开仓
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.kaicang.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: openPriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: openSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 平仓
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.pingcang.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: closePriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: closeSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 计划价格
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${TextKey.jihua.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final labelText = planBuyPoints.value == 0.0
                        ? TextKey.maijia.tr
                        : "${TextKey.maijia.tr}: ${(planBuyPoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planBuyPriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: labelText),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final labelText = planSalePoints.value == 0.0
                        ? TextKey.maijia_s.tr
                        : "${TextKey.maijia_s.tr}: ${(planSalePoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planSalePriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: labelText),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: tradeRemarkController,
              maxLines: 2,
              decoration: InputDecoration(labelText: TextKey.beizui.tr),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(TextKey.quxiao.tr),
        ),
        TextButton(
          onPressed: () {
            if (isEdit) {
              updateTrade(existingTrade);
            } else {
              addTrade();
            }
          },
          child: Text(TextKey.queding.tr),
        ),
      ],
    ));
  }

  Future<void> addTrade() async {
    if (openPriceController.text.isEmpty) {
      QsHud.showToast(
          "${TextKey.qingshuru.tr}${TextKey.kaicang.tr}${TextKey.jiage.tr}");
      return;
    }
    final item = StockTradesCompanion.insert(
      stockId: localStockData.value!.id,
      tradeType: tradeType.value,
      openPrice: Value(openPriceController.text),
      openShares: Value(openSharesController.text),
      closePrice: Value(closePriceController.text),
      closeShares: Value(closeSharesController.text),
      planBuyPrice: Value(planBuyPriceController.text),
      planSalePrice: Value(planSalePriceController.text),
      remark: Value(tradeRemarkController.text),
      tradeDate: Value(tradeDate.value),
    );
    await db.addStockTrade(item);
    Get.back();
    QsHud.showToast(TextKey.success.tr);
    loadTrades();
  }

  Future<void> updateTrade(StockTrade trade) async {
    if (openPriceController.text.isEmpty) {
      QsHud.showToast(
          "${TextKey.qingshuru.tr}${TextKey.kaicang.tr}${TextKey.jiage.tr}");
      return;
    }
    final item = StockTradesCompanion.insert(
      id: Value(trade.id),
      stockId: trade.stockId,
      tradeType: tradeType.value,
      openPrice: Value(openPriceController.text),
      openShares: Value(openSharesController.text),
      closePrice: Value(closePriceController.text),
      closeShares: Value(closeSharesController.text),
      planBuyPrice: Value(planBuyPriceController.text),
      planSalePrice: Value(planSalePriceController.text),
      remark: Value(tradeRemarkController.text),
      tradeDate: Value(tradeDate.value),
    );
    await db.updateStockTrade(item);
    Get.back();
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

  ({double? yieldRate, double? profit}) calculateTradeEstimate(
      StockTrade trade) {
    return calculateTradeEstimateFromValues(
      currentPrice: serStockData.value.currentPrice,
      openPrice: trade.openPrice,
      closePrice: trade.closePrice,
      openShares: trade.openShares,
      closeShares: trade.closeShares,
      tradeType: trade.tradeType,
    );
  }

  void showAllTradesSheet(Widget Function(StockTrade) buildTradeItem) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      TextKey.jiaoyijilu.tr,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (stockTrades.isEmpty) {
                      return Center(
                        child: Text(
                          TextKey.noData.tr,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: stockTrades
                            .map((trade) => buildTradeItem(trade))
                            .toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
