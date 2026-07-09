import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/model/stock_tx_model.dart';
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
        }),
        bottomNavigationBar: buildBottomBar(),
      ),
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
      child: RepaintBoundary(
        key: controller.contentKey,
        child: Container(
          color: Get.theme.scaffoldBackgroundColor,
          child: Padding(
            // 为分享图片保留左右/底部边距
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              // spacing: 16,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!controller.isLocalData.value) ...[
                  buildCenterSearchField(),
                  kSpaceH(12),
                ],
                _gupiaoinfo(),
                kSpaceH(24),
                _gupiaojihua(),
                kSpaceH(24),
                _gupiaojilu(),
                kSpaceH(24),
                _jiaoyijilu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCenterSearchField() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 280,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StockSearchField(
              key: controller.searchFieldKey,
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
          ],
        ),
      ),
    );
  }

  Widget _gupiaojilu() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(TextKey.jilu.tr, style: Get.textTheme.titleLarge),
            ],
          ),
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
            minLines: 3,
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.beizui.tr,
              border: OutlineInputBorder(),
              alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            keyboardType: TextInputType.multiline,
          ),
          kSpaceH(16),
          TextField(
            controller: controller.rEventRemarkController,
            minLines: 3,
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.shijian.tr + TextKey.jilu.tr,
              border: OutlineInputBorder(),
              alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            keyboardType: TextInputType.multiline,
          ),
        ]);
  }

  Widget _jiaoyijilu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(TextKey.jiaoyijilu.tr, style: Get.textTheme.titleLarge),
            TextButton.icon(
              onPressed: controller.showAddTradeDialog,
              icon: const Icon(Icons.add, size: 18),
              label: Text(TextKey.xinzengjiaoyi.tr),
            ),
          ],
        ),
        kSpaceH(8),
        Obx(() {
          if (controller.stockTrades.isEmpty) {
            return Text(
              TextKey.noData.tr,
              style: TextStyle(color: Colors.grey),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.stockTrades.length,
            itemBuilder: (context, index) {
              final trade = controller.stockTrades[index];
              return _buildTradeItem(trade);
            },
          );
        }),
      ],
    );
  }

  Widget _buildTradeItem(StockTrade trade) {
    final isBuy = trade.tradeType == 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isBuy
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isBuy ? TextKey.buy.tr : TextKey.sale.tr,
                    style: TextStyle(
                      color: isBuy ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  trade.createdAt.toDateString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.deleteTrade(trade),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            kSpaceH(8),
            Row(
              children: [
                Text(
                  "${TextKey.jiage.tr}: ${trade.price ?? '-'}",
                  style: TextStyle(fontSize: 14),
                ),
                if (trade.shares != null && trade.shares!.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Text(
                    "${TextKey.gushu.tr}: ${trade.shares}",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
            if (trade.remark != null && trade.remark!.isNotEmpty) ...[
              kSpaceH(4),
              Text(
                "${TextKey.beizui.tr}: ${trade.remark}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _gupiaojihua() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(TextKey.jihua.tr, style: Get.textTheme.titleLarge),
            kSpaceMax(),
            SizedBox(
              width: 76,
              child: Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 10), // 默认样式
                  children:
                      (controller.serStockData.value?.showCellConditionInfo() ??
                              "")
                          .split('')
                          .map((char) {
                    if (char == 'B') {
                      return TextSpan(
                          text: char,
                          style: TextStyle(color: Colors.red, fontSize: 11));
                    } else if (char == 'S') {
                      return TextSpan(
                          text: char,
                          style: TextStyle(color: Colors.blue, fontSize: 11));
                    } else {
                      return TextSpan(text: char); // 默认样式
                    }
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        kSpaceH(8),
        Column(
          children: [
            _rowjiage(type: "price"), //市价
            _rowjiage(type: "market_value"), //市值
            if ((controller.serStockData.value.code ?? "").isEmpty ||
                (controller.serStockData.value.peRatioTtm != null &&
                    double.tryParse(
                            controller.serStockData.value.peRatioTtm!) !=
                        null &&
                    double.parse(controller.serStockData.value.peRatioTtm!) >
                        0))
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
                minLines: 1,
                maxLines: null, // 允许多行输入
                decoration: InputDecoration(
                  labelText: TextKey.liyou.tr,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // 标签文字与多行输入对齐
                ),
                keyboardType: TextInputType.multiline,
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
              buildMinesweeperButton(),
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

  Widget buildMinesweeperButton() {
    final code = controller.serStockData.value.code ?? '';
    final isAStock = (code.startsWith("sh") || code.startsWith("sz")) &&
        !code.startsWith("sh5") &&
        !code.startsWith("sz1");

    if (!isAStock) return SizedBox.shrink(); // 占位不显示

    return InkWell(
      onTap: () {
        controller.clickLookMinesweeper();
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
        child: Icon(
          RemixIcons.alarm_warning_line,
          size: 20,
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Obx(() {
      final isDeleted = controller.localStockData.value?.opDelete == true;
      return Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Get.theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: isDeleted
                ? _buildDeletedBottomActions()
                : _buildNormalBottomActions(),
          ),
        ),
      );
    });
  }

  Widget _buildNormalBottomActions() {
    final canOperate = controller.isLocalData.value;
    final local = controller.localStockData.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomActionItem(
          icon: Icons.share_outlined,
          label: TextKey.share.tr,
          onTap: controller.clickShare,
        ),
        _buildBottomActionItem(
          icon: Icons.trending_up,
          label: TextKey.chiyou.tr,
          color: (local?.opBuy ?? false) ? Colors.red : null,
          onTap: canOperate ? controller.clickOpBuy : null,
        ),
        _buildBottomActionItem(
          icon: ((controller.localStockData.value?.tagList.length ?? 0) > 0)
              ? Remix.price_tag_3_fill
              : Remix.price_tag_3_line,
          label: TextKey.biaoqian.tr,
          color: ((controller.localStockData.value?.tagList.length ?? 0) > 0)
              ? Colors.blue
              : null,
          onTap: canOperate ? controller.clickPushTag : null,
        ),
        _buildBottomActionItem(
          icon: (local?.opCollect ?? false)
              ? Icons.star
              : Icons.star_border_outlined,
          label: TextKey.collect.tr,
          color: (local?.opCollect ?? false) ? Colors.amber : null,
          onTap: canOperate ? controller.clickOpCollect : null,
        ),
        _buildBottomActionItem(
          icon: Icons.delete_forever,
          label: TextKey.delete.tr,
          onTap: canOperate ? controller.clickOpDelete : null,
        ),
      ],
    );
  }

  Widget _buildDeletedBottomActions() {
    final theme = Get.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomActionItem(
          icon: Icons.restore,
          label: TextKey.huifu.tr,
          color: Colors.green,
          onTap: controller.clickOpRestore,
        ),
        _buildBottomActionItem(
          icon: Icons.delete_forever,
          label: TextKey.delete.tr,
          color: theme.colorScheme.error,
          onTap: controller.clickOpDelete,
        ),
      ],
    );
  }

  Widget _buildBottomActionItem({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    final theme = Get.theme;
    final enabled = onTap != null;
    final effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: InkWell(
          onTap: onTap,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: effectiveColor,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: effectiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
