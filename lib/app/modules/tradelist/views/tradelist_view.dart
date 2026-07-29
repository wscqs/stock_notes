import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/tradelist/controllers/tradelist_controller.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/qs_empty_view.dart';
import 'package:stock_notes/common/widget/stock_trade_item.dart';

class TradelistView extends GetView<TradelistController> {
  const TradelistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.jiaoyi.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: TextKey.refresh.tr,
            onPressed: controller.refreshCurrentPrices,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.trades.isEmpty) {
          return QsEmptyView(message: TextKey.noData.tr);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.trades.length,
          itemBuilder: (context, index) {
            final trade = controller.trades[index];
            final stock = controller.stockMap[trade.stockId];
            return StockTradeItem(
              trade: trade,
              stock: stock,
              currentPrice: stock?.currentPrice,
              onTap: () => controller.openStockDetail(trade),
              onEdit: () => controller.editTrade(trade),
              onDelete: () => controller.deleteTrade(trade),
            );
          },
        );
      }),
    );
  }
}
