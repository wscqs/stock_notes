import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/langs/text_key.dart';

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
              return Text(controller.isLocalData.value
                  ? controller.localStockData.value!.name
                  : TextKey.gupiao.tr);
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
            return buildContentView(context);
          })),
    );
  }

  Widget buildContentView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!controller.isLocalData.value) buildCenterSearchFiled(),
          _gupiaoinfo(),
          _gupiaojihua(),
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
          kSpaceH(12),
          TextField(
            controller: controller.pAllRemarkController,
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
            controller: controller.pEventRemarkController,
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
        Text(TextKey.jihua.tr, style: Get.textTheme.titleLarge),
        kSpaceH(8),
        Column(
          children: [
            _rowjiage(type: "price"), //市价
            _rowjiage(type: "market_value"), //市值
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
    if (type == "price") {
      titile = TextKey.jige.tr;
      value = controller.serStockData.value.currentPrice ?? "";
      buyTextEditingController = controller.pPriceBuyController;
      saleTextEditingController = controller.pPriceSaleController;
      remarkTextEditingController = controller.pPriceRemarkController;
      yieldRate = controller.pPriceYieldRate.value;
    } else if (type == "market_value") {
      titile = TextKey.shizhi.tr;
      value = controller.serStockData.value.totalMarketCap ?? "";
      buyTextEditingController = controller.pMarketCapBuyController;
      saleTextEditingController = controller.pMarketCapSaleController;
      remarkTextEditingController = controller.pMarketRemarkController;
      yieldRate = controller.pMarketCapYieldRate.value;
    } else if (type == "p_e_ratio") {
      titile = TextKey.shiyin.tr;
      value = controller.serStockData.value.peRatioTtm ?? "";
      buyTextEditingController = controller.pPeTtmBuyController;
      saleTextEditingController = controller.pPeTtmSaleController;
      remarkTextEditingController = controller.pPeTtmRemarkController;
      yieldRate = controller.pPeTtmYieldRate.value;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 50, // 设置基线偏移
          baselineType: TextBaseline.alphabetic,
          child: SizedBox(
            width: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titile + "：",
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
                    width: 60,
                    child: TextField(
                      controller: buyTextEditingController,
                      decoration: InputDecoration(labelText: TextKey.buy.tr),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  kSpaceW(12),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: saleTextEditingController,
                      decoration: InputDecoration(labelText: TextKey.sale.tr),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  kSpaceW(12),
                  if (yieldRate > 0)
                    Text(
                      TextKey.shouyilv.tr +
                          " ${(yieldRate * 100).toStringAsFixed(1)}%",
                      style: Get.textTheme.titleMedium,
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
            (controller.serStockData.value.code != null)
                ? TextButton(
                    onPressed: () {
                      controller.clickLookStock();
                    },
                    child: Text(
                      TextKey.look.tr,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      controller.search();
                    },
                    child: Text(
                      TextKey.refresh.tr,
                    ),
                  ),
          ],
        ),
        kSpaceH(8),
        (controller.serStockData.value.code != null)
            ? Text(controller.serStockData.value.showAllInfo())
            : Text(TextKey.no.tr, style: TextStyle(color: Colors.grey)),

        // RichText(
        //   text: TextSpan(
        //     text: controller.stockData.value.name ?? "",
        //     // style: DefaultTextStyle.of(context).style,
        //     children: <TextSpan>[
        //       TextSpan(
        //         text: controller.stockData.value.code ?? "",
        //       ),
        //       TextSpan(
        //         text: '股价：16.00',
        //       ),
        //       TextSpan(
        //         text: '市值：16.00',
        //       ),
        //       TextSpan(
        //         text: '市盈（TTM）：16.00',
        //       ),
        //       TextSpan(
        //         text: '市净：16.00',
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
