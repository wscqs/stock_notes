import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../commonwidget/stock_searchfield.dart';
import '../controllers/stockedit_controller.dart';

class StockeditView extends GetView<StockeditController> {
  const StockeditView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 关闭键盘
      },
      child: Scaffold(
          appBar: AppBar(
            title: Obx(() {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(controller.isLocalData.value
                            ? controller.localStockData.value!.name
                            : TextKey.gupiao.tr),
                        if (controller.localStockData?.value?.opDelete ?? false)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            centerTitle: true,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    controller.save();
                  },
                  child: Text(TextKey.baocun.tr))
            ],
          ),
          body: Obx(() {
            return _visibilityDetectorWithCustomScrollView(context);
          })),
    );
  }

  Widget _visibilityDetectorWithCustomScrollView(BuildContext context) {
    return VisibilityDetector(
        key: Key("StockeditViewVisibilityKey"),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 0) {
            // print('Widget is not visible');
            // controller.onPause();
          } else if (info.visibleFraction == 1) {
            // print('Widget is fully visible');
            controller.onResume();
          } else {
            // print('Widget is partially visible');
          }
        },
        child: buildContentView(context));
  }

  Widget buildContentView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        // spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!controller.isLocalData.value) ...[
            buildCenterSearchFiled(),
            kSpaceH(12),
          ],
          _gupiaoinfo(),
          kSpaceH(24),
          _gupiaojihua(),
          kSpaceH(24),
          _gupiaojilu(),
        ],
      ),
    );
  }

  Center buildCenterSearchFiled() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 280,
        ),
        child: StockSearchField(
          controller: controller.stockNumController,
          onClear: controller.clearStockNum,
          focusNode: controller.stockNumFocusNode,
          onSubmit: () {
            // 提交逻辑
            controller.search();
          },
          hintText: TextKey.shurugupiaotishi.tr,
          stockValue: controller.stockNum,
        ),
      ),
    );
  }

  Widget _gupiaojilu() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextKey.jilu.tr, style: Get.textTheme.titleLarge),
          kSpaceH(16),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextField(
                  controller: controller.rBuyPriceController,
                  decoration:
                      InputDecoration(labelText: TextKey.chiyouchengbenjia.tr),
                  keyboardType: TextInputType.number,
                ),
              ),
              if (controller.rBuyPriceYieldRate.value != 0.00001)
                Text(
                  "${TextKey.shouyilv.tr}: ${(controller.rBuyPriceYieldRate.value * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          kSpaceH(16),
          TextField(
            controller: controller.rAllRemarkController,
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.beizui.tr,
              border: OutlineInputBorder(),
              // alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            // keyboardType: TextInputType.multiline,
          ),
          kSpaceH(16),
          TextField(
            controller: controller.rEventRemarkController,
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.shijian.tr + TextKey.jilu.tr,
              border: OutlineInputBorder(),
              // alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            // keyboardType: TextInputType.multiline,
          ),
        ]);
  }

  Widget _gupiaojihua() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(TextKey.jihua.tr, style: Get.textTheme.titleLarge),
          ],
        ),
        kSpaceH(8),
        Column(
          children: [
            _rowjiage(type: "price"), //市价
            _rowjiage(type: "market_value"), //市值
            if ((controller.serStockData.value.code ?? "").isEmpty ||
                double.parse(controller.serStockData.value.peRatioTtm ?? "0") >
                    0)
              _rowjiage(type: "p_e_ratio"), //市盈率
          ],
        )
      ],
    );
  }

  Widget _rowjiage({required String type}) {
    String titile = "";
    String value = "";
    TextEditingController? buyTextEditingController;
    TextEditingController? saleTextEditingController;
    TextEditingController? remarkTextEditingController;
    double yieldRate = 0.0;
    double buyPoints = 0.0;
    double salePoints = 0.0;
    if (type == "price") {
      titile = TextKey.jige.tr;
      value = controller.serStockData.value.currentPrice ?? "";
      buyTextEditingController = controller.pPriceBuyController;
      saleTextEditingController = controller.pPriceSaleController;
      remarkTextEditingController = controller.pPriceRemarkController;
      yieldRate = controller.pPriceYieldRate.value;
      buyPoints = controller.pPriceBuyPoints.value;
      salePoints = controller.pPriceSalePoints.value;
    } else if (type == "market_value") {
      titile = TextKey.shizhi.tr;
      value = controller.serStockData.value.totalMarketCap ?? "";
      buyTextEditingController = controller.pMarketCapBuyController;
      saleTextEditingController = controller.pMarketCapSaleController;
      remarkTextEditingController = controller.pMarketRemarkController;
      yieldRate = controller.pMarketCapYieldRate.value;
      buyPoints = controller.pMarketCapBuyPoints.value;
      salePoints = controller.pMarketCapSalePoints.value;
    } else if (type == "p_e_ratio") {
      titile = TextKey.shiyin.tr;
      value = controller.serStockData.value.peRatioTtm ?? "";
      buyTextEditingController = controller.pPeTtmBuyController;
      saleTextEditingController = controller.pPeTtmSaleController;
      remarkTextEditingController = controller.pPeTtmRemarkController;
      yieldRate = controller.pPeTtmYieldRate.value;
      buyPoints = controller.pPeTtmBuyPoints.value;
      salePoints = controller.pPeTtmSalePoints.value;
    }
    String buyLabelText = TextKey.buy.tr;
    if (buyPoints != 0.0) {
      buyLabelText =
          "${TextKey.buy.tr}: ${(buyPoints * 100).toStringAsFixed(1)}%";
    }
    String saleLabelText = TextKey.sale.tr;
    if (salePoints != 0.0) {
      saleLabelText =
          "${TextKey.sale.tr}: ${(salePoints * 100).toStringAsFixed(1)}%";
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 50, // 设置基线偏移
          baselineType: TextBaseline.alphabetic,
          child: SizedBox(
            width: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$titile：",
                    style: TextStyle(
                        fontSize: Get.textTheme.titleMedium?.fontSize,
                        fontWeight: FontWeight.bold)),
                Text(value),
              ],
            ),
          ),
        ),
        kSpaceW(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 64,
                    child: TextField(
                      controller: buyTextEditingController,
                      decoration: InputDecoration(labelText: buyLabelText),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  kSpaceW(12),
                  SizedBox(
                    width: 64,
                    child: TextField(
                      controller: saleTextEditingController,
                      decoration: InputDecoration(labelText: saleLabelText),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  kSpaceW(12),
                  if (yieldRate > 0)
                    Text(
                      "${TextKey.shouyilv.tr}: ${(yieldRate * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              kSpaceH(16),
              TextField(
                controller: remarkTextEditingController,
                maxLines: null, // 允许多行输入
                decoration: InputDecoration(
                  labelText: TextKey.liyou.tr,
                  border: OutlineInputBorder(),
                  // alignLabelWithHint: true, // 标签文字与多行输入对齐
                ),
                // keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gupiaoinfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(TextKey.gupiao.tr, style: Get.textTheme.titleLarge),
            if (controller.serStockData.value.code != null ||
                controller.isLocalData.value) ...[
              InkWell(
                  onTap: () {
                    controller.search();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 8, top: 12, bottom: 12),
                    child: Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                  )),
              InkWell(
                onTap: () {
                  controller.clickLookStock();
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
                  child: Icon(
                    Icons.web,
                    size: 20,
                  ),
                ),
              ),
              kSpaceMax(),
              buildActionButtons(),
            ],
          ],
        ),
        kSpaceH(8),
        (controller.serStockData.value.code != null)
            ? Text(controller.serStockData.value.showAllInfo())
            : Text(TextKey.no.tr, style: TextStyle(color: Colors.grey)),
        if ((controller.localStockData.value?.tagList.length ?? 0) > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4, top: 2),
                  child: Icon(
                    RemixIcons.price_tag_3_line,
                    size: 12,
                  ),
                ),
                Expanded(
                  child: Text(
                    controller.localStockData.value?.homeCellShowTagNames() ??
                        "",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildActionButtons() {
    if (controller.localStockData.value?.opDelete == true) {
      return buildEditRestoreRowBtns();
    } else {
      return buildEditRowBtns();
    }
  }

  Widget buildEditRowBtns() {
    return Opacity(
      opacity: (controller.isLocalData.value ? 1.0 : 0.3),
      child: Row(children: [
        InkWell(
          onTap: () {
            controller.clickOpBuy();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
            child: Icon(
              (controller.localStockData.value?.opBuy ?? false)
                  ? Icons.trending_flat
                  : Icons.trending_up,
              size: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.clickPushTag();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
            child: Icon(
              Remix.price_tag_3_line,
              size: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.clickOpCollect();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
            child: Icon(
              (controller.localStockData.value?.opCollect ?? false)
                  ? Icons.star
                  : Icons.star_border_outlined,
              size: 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.clickOpDelete();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
            child: Icon(
              Icons.delete_forever,
              size: 20,
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildEditRestoreRowBtns() {
    return Row(children: [
      InkWell(
        onTap: () {
          controller.clickOpRestore();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
          child: Icon(
            Icons.restore,
            size: 20,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          controller.clickOpDelete();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
          child: Icon(
            Icons.delete_forever,
            size: 20,
          ),
        ),
      ),
    ]);
  }
}
