import 'package:flutter/cupertino.dart';
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
        return Column(
          children: [
            buildSearchBar(),
            buildFilterRow(context),
            Expanded(
              child: controller.filteredTrades.isEmpty
                  ? QsEmptyView(message: TextKey.noData.tr)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredTrades.length,
                      itemBuilder: (context, index) {
                        final trade = controller.filteredTrades[index];
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
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildSearchBar() {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, minHeight: 40),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 8),
            child: Icon(Icons.search, size: 20),
          ),
          hintText: "${TextKey.search.tr} ...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: controller.query.value.isNotEmpty
              ? SizedBox(
                  width: 44,
                  height: 44,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.applyFilters();
                    },
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget buildFilterRow(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        children: [
          Obx(() => _buildConditionChip()),
          Obx(() {
            if (!controller.isMeetConditionEnabled.value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildSegmentedControl(),
            );
          }),
          const Spacer(),
          _buildStockFilterButton(context),
          Obx(() {
            final hasFilter = controller.query.value.isNotEmpty ||
                controller.isMeetConditionEnabled.value ||
                controller.selectedStock.value != null;
            if (!hasFilter) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildClearButton(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConditionChip() {
    final isSelected = controller.isMeetConditionEnabled.value;
    return InkWell(
      onTap: controller.toggleMeetCondition,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          TextKey.mangzumaimai.tr,
          style: TextStyle(
            color: isSelected
                ? Colors.red
                : Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    final segments = <String, String>{
      'all': TextKey.all.tr,
      'bug': TextKey.buy.tr,
      'sale': TextKey.sale.tr,
    };
    return CupertinoSegmentedControl<String>(
      selectedColor: Colors.grey.withValues(alpha: 0.15),
      disabledColor: Colors.white,
      unselectedColor: Colors.grey.withValues(alpha: 0.15),
      borderColor: Colors.grey.withValues(alpha: 0.15),
      onValueChanged: controller.onSegmentChanged,
      padding: EdgeInsets.zero,
      groupValue: controller.selectedSegment.value,
      children: {
        for (var entry in segments.entries)
          entry.key: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Text(
              entry.value,
              style: TextStyle(
                color: controller.selectedSegment.value == entry.key
                    ? Colors.red
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          )
      },
    );
  }

  Widget _buildStockFilterButton(BuildContext context) {
    return InkWell(
      onTap: () => _showStockFilterSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_outlined,
              size: 18,
              color: controller.selectedStock.value != null
                  ? Colors.red
                  : Get.theme.colorScheme.onSurface,
            ),
            if (controller.selectedStock.value != null) ...[
              const SizedBox(width: 4),
              Text(
                controller.selectedStock.value!.name,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return InkWell(
      onTap: controller.clearFilters,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Icon(
          Icons.filter_list_off_outlined,
          size: 18,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  void _showStockFilterSheet(BuildContext context) {
    final stocks = controller.stockMap.values.toList();
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextKey.gupiao.tr,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(TextKey.all.tr),
                            selected: controller.selectedStock.value == null,
                            selectedTileColor:
                                Colors.red.withValues(alpha: 0.1),
                            onTap: () {
                              controller.selectStock(null);
                              Get.back();
                            },
                          ),
                          ...stocks.map((stock) => ListTile(
                                title: Text('${stock.name} (${stock.code})'),
                                selected: controller.selectedStock.value?.id ==
                                    stock.id,
                                selectedTileColor:
                                    Colors.red.withValues(alpha: 0.1),
                                onTap: () {
                                  controller.selectStock(stock);
                                  Get.back();
                                },
                              )),
                        ],
                      );
                    },
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
