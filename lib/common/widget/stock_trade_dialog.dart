import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockTradeDialog {
  static void show({
    required BuildContext context,
    required StockTrade? existingTrade,
    required String currentPrice,
    required void Function(StockTradesCompanion companion) onSaved,
  }) {
    Get.dialog(_StockTradeDialogContent(
      existingTrade: existingTrade,
      currentPrice: currentPrice,
      onSaved: onSaved,
    ));
  }
}

class _StockTradeDialogContent extends StatefulWidget {
  final StockTrade? existingTrade;
  final String currentPrice;
  final void Function(StockTradesCompanion companion) onSaved;

  const _StockTradeDialogContent({
    required this.existingTrade,
    required this.currentPrice,
    required this.onSaved,
  });

  @override
  State<_StockTradeDialogContent> createState() =>
      _StockTradeDialogContentState();
}

class _StockTradeDialogContentState extends State<_StockTradeDialogContent> {
  late final RxInt tradeType;
  late final Rx<DateTime> tradeDate;
  late final TextEditingController openPriceController;
  late final TextEditingController openSharesController;
  late final TextEditingController closePriceController;
  late final TextEditingController closeSharesController;
  late final TextEditingController planBuyPriceController;
  late final TextEditingController planSalePriceController;
  late final TextEditingController tradeRemarkController;
  late final RxDouble planBuyPoints;
  late final RxDouble planSalePoints;

  @override
  void initState() {
    super.initState();
    tradeType = (widget.existingTrade?.tradeType ?? 0).obs;
    tradeDate = (widget.existingTrade?.tradeDate ?? DateTime.now()).obs;
    openPriceController = TextEditingController(
      text:
          widget.existingTrade?.openPrice ?? widget.existingTrade?.price ?? '',
    );
    openSharesController = TextEditingController(
      text: widget.existingTrade?.openShares ??
          widget.existingTrade?.shares ??
          '',
    );
    closePriceController = TextEditingController(
      text: widget.existingTrade?.closePrice ?? '',
    );
    closeSharesController = TextEditingController(
      text: widget.existingTrade?.closeShares ?? '',
    );
    planBuyPriceController = TextEditingController(
      text: widget.existingTrade?.planBuyPrice ?? '',
    );
    planSalePriceController = TextEditingController(
      text: widget.existingTrade?.planSalePrice ?? '',
    );
    tradeRemarkController = TextEditingController(
      text: widget.existingTrade?.remark ?? '',
    );
    planBuyPoints = 0.0.obs;
    planSalePoints = 0.0.obs;
    updatePlanPricePoints();
  }

  @override
  void dispose() {
    tradeType.close();
    tradeDate.close();
    openPriceController.dispose();
    openSharesController.dispose();
    closePriceController.dispose();
    closeSharesController.dispose();
    planBuyPriceController.dispose();
    planSalePriceController.dispose();
    tradeRemarkController.dispose();
    planBuyPoints.close();
    planSalePoints.close();
    super.dispose();
  }

  void updatePlanPricePoints() {
    final current = double.tryParse(widget.currentPrice);
    final buyPrice = double.tryParse(planBuyPriceController.text);
    final salePrice = double.tryParse(planSalePriceController.text);
    planBuyPoints.value = (current != null && current != 0 && buyPrice != null)
        ? (buyPrice - current) / current
        : 0.0;
    planSalePoints.value =
        (current != null && current != 0 && salePrice != null)
            ? (salePrice - current) / current
            : 0.0;
  }

  void _handleSaved() {
    var companion = StockTradesCompanion.insert(
      stockId: widget.existingTrade?.stockId ?? 0,
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
    if (widget.existingTrade != null) {
      companion = companion.copyWith(id: Value(widget.existingTrade!.id));
    }
    widget.onSaved(companion);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //可以设置宽度吗
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.only(left: 20, top: 20),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
      title: Text(
        widget.existingTrade != null
            ? TextKey.xiugai.tr
            : TextKey.xinzengjiaoyi.tr,
        style: const TextStyle(fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
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
                        readOnly: true,
                        textAlign: TextAlign.center,
                        initialValue:
                            DateFormat('yyyy-MM-dd').format(tradeDate.value),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: tradeDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) tradeDate.value = picked;
                        },
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${TextKey.kaicang.tr}: '),
                const SizedBox(width: 8),
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: openPriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: openSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${TextKey.pingcang.tr}: '),
                const SizedBox(width: 8),
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: closePriceController,
                    decoration: InputDecoration(labelText: TextKey.jiage.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: closeSharesController,
                    decoration: InputDecoration(labelText: TextKey.gushu.tr),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${TextKey.jihua.tr}: '),
                const SizedBox(width: 8),
                Flexible(
                  flex: 5,
                  child: Obx(() {
                    final isBuy = tradeType.value == 0;
                    final baseLabel = isBuy
                        ? TextKey.zhisunjia.tr
                        : TextKey.zhiyingjia_maihui.tr;
                    final label = planBuyPoints.value == 0.0
                        ? baseLabel
                        : "$baseLabel: ${(planBuyPoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planBuyPriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: label),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 4,
                  child: Obx(() {
                    final isBuy = tradeType.value == 0;
                    final baseLabel =
                        isBuy ? TextKey.zhiyingjia.tr : TextKey.zhisunjia.tr;
                    final label = planSalePoints.value == 0.0
                        ? baseLabel
                        : "$baseLabel: ${(planSalePoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planSalePriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: label),
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
        TextButton(onPressed: Get.back, child: Text(TextKey.quxiao.tr)),
        TextButton(
          onPressed: _handleSaved,
          child: Text(TextKey.queding.tr),
        ),
      ],
    );
  }
}
