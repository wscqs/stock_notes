import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockTradeDialog {
  static void show({
    required BuildContext context,
    required StockTrade? existingTrade,
    required String currentPrice,
    required void Function(StockTradesCompanion companion) onSaved,
  }) {
    final tradeType = (existingTrade?.tradeType ?? 0).obs;
    final tradeDate = (existingTrade?.tradeDate ?? DateTime.now()).obs;
    final openPriceController = TextEditingController(
      text: existingTrade?.openPrice ?? existingTrade?.price ?? '',
    );
    final openSharesController = TextEditingController(
      text: existingTrade?.openShares ?? existingTrade?.shares ?? '',
    );
    final closePriceController = TextEditingController(
      text: existingTrade?.closePrice ?? '',
    );
    final closeSharesController = TextEditingController(
      text: existingTrade?.closeShares ?? '',
    );
    final planBuyPriceController = TextEditingController(
      text: existingTrade?.planBuyPrice ?? '',
    );
    final planSalePriceController = TextEditingController(
      text: existingTrade?.planSalePrice ?? '',
    );
    final tradeRemarkController = TextEditingController(
      text: existingTrade?.remark ?? '',
    );

    final planBuyPoints = 0.0.obs;
    final planSalePoints = 0.0.obs;

    void updatePlanPricePoints() {
      final current = double.tryParse(currentPrice);
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

    updatePlanPricePoints();

    Get.dialog(AlertDialog(
      title: Text(existingTrade != null
          ? TextKey.xiugai.tr
          : TextKey.xinzengjiaoyi.tr),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${TextKey.jihua.tr}: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final label = planBuyPoints.value == 0.0
                        ? TextKey.maijia.tr
                        : "${TextKey.maijia.tr}: ${(planBuyPoints.value * 100).toStringAsFixed(1)}%";
                    return TextField(
                      controller: planBuyPriceController,
                      onChanged: (_) => updatePlanPricePoints(),
                      decoration: InputDecoration(labelText: label),
                      keyboardType: TextInputType.number,
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final label = planSalePoints.value == 0.0
                        ? TextKey.maijia_s.tr
                        : "${TextKey.maijia_s.tr}: ${(planSalePoints.value * 100).toStringAsFixed(1)}%";
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
          onPressed: () {
            var companion = StockTradesCompanion.insert(
              stockId: existingTrade?.stockId ?? 0,
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
            if (existingTrade != null) {
              companion = companion.copyWith(id: Value(existingTrade.id));
            }
            onSaved(companion);
          },
          child: Text(TextKey.queding.tr),
        ),
      ],
    ));
  }
}
