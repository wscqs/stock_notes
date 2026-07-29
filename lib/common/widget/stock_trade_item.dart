import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockTradeItem extends StatelessWidget {
  final StockTrade trade;
  final StockItem? stock;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? currentPrice;

  const StockTradeItem({
    super.key,
    required this.trade,
    this.stock,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.currentPrice,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.tradeType == 0;
    final estimate = calculateTradeEstimateFromValues(
      currentPrice: currentPrice,
      openPrice: trade.openPrice,
      closePrice: trade.closePrice,
      openShares: trade.openShares,
      closeShares: trade.closeShares,
      tradeType: trade.tradeType,
    );
    final meetStatus = trade.meetStatus(currentPrice);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTypeChip(isBuy),
                        const SizedBox(width: 8),
                        if (stock != null)
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${stock!.name} (${stock!.code})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w600,
                                      color: Get.theme.colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (currentPrice?.isNotEmpty == true) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    currentPrice!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Get.theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        else
                          const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      label: TextKey.kaicang.tr,
                      price: trade.openPrice,
                      shares: trade.openShares,
                    ),
                    if (trade.closePrice != null &&
                        trade.closePrice!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        label: TextKey.pingcang.tr,
                        price: trade.closePrice,
                        shares: trade.closeShares,
                      ),
                    ],
                    if (trade.planBuyPrice?.isNotEmpty == true ||
                        trade.planSalePrice?.isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      _buildPlanPriceChips(isBuy),
                    ],
                    if (trade.remark != null && trade.remark!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "${TextKey.beizui.tr}: ${trade.remark}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        (trade.tradeDate ?? trade.createdAt).toDateString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onEdit,
                        child: const Icon(Icons.edit,
                            size: 18, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Icon(Icons.delete_outline,
                            size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (meetStatus != TradeMeetStatus.none) ...[
                    const SizedBox(height: 6),
                    _buildMeetStatusTag(meetStatus),
                  ],
                  const SizedBox(height: 8),
                  _buildTradeEstimate(estimate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(bool isBuy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? price,
    String? shares,
  }) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(
          price ?? '-',
          style: TextStyle(
            fontSize: 14,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        if (shares != null && shares.isNotEmpty) ...[
          const SizedBox(width: 12),
          Text(
            "${TextKey.gushu.tr}: $shares",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildPlanPriceChips(bool isBuy) {
    final buyLabel =
        isBuy ? TextKey.zhisunjia.tr : TextKey.zhiyingjia_maihui.tr;
    final saleLabel = isBuy ? TextKey.zhiyingjia.tr : TextKey.zhisunjia.tr;

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (trade.planBuyPrice?.isNotEmpty == true)
          _buildPlanChip(
            label: buyLabel,
            value: trade.planBuyPrice!,
            valueColor: isBuy ? Colors.green : Colors.red,
          ),
        if (trade.planSalePrice?.isNotEmpty == true)
          _buildPlanChip(
            label: saleLabel,
            value: trade.planSalePrice!,
            valueColor: isBuy ? Colors.red : Colors.green,
          ),
      ],
    );
  }

  Widget _buildPlanChip({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: Get.theme.colorScheme.onSurfaceVariant,
          ),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetStatusTag(TradeMeetStatus status) {
    String label;
    switch (status) {
      case TradeMeetStatus.b:
        label = '${TextKey.mangzu.tr}B';
        break;
      case TradeMeetStatus.s:
        label = '${TextKey.mangzu.tr}S';
        break;
      case TradeMeetStatus.bs:
        label = '${TextKey.mangzu.tr}BS';
        break;
      case TradeMeetStatus.none:
        return const SizedBox.shrink();
    }

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 11,
          color: Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
        ),
        children: label.split('').map((char) {
          if (char == 'B') {
            return TextSpan(
              text: char,
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w700,
              ),
            );
          } else if (char == 'S') {
            return TextSpan(
              text: char,
              style: TextStyle(
                color: Colors.blue.shade400,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          return TextSpan(text: char);
        }).toList(),
      ),
    );
  }

  Widget _buildTradeEstimate(({double? yieldRate, double? profit}) estimate) {
    final yieldRate = estimate.yieldRate;
    final valueColor = yieldRate == null
        ? Colors.grey
        : (yieldRate > 0
            ? Colors.red
            : (yieldRate < 0 ? Colors.green : Colors.grey));
    const labelStyle = TextStyle(color: Colors.grey, fontSize: 11);
    final valueStyle = TextStyle(color: valueColor, fontSize: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: "${TextKey.shouyilv.tr}: ", style: labelStyle),
          TextSpan(
            text: yieldRate == null
                ? "-"
                : "${(yieldRate * 100).toStringAsFixed(1)}%",
            style: valueStyle,
          ),
        ])),
        if (estimate.profit != null)
          Text.rich(TextSpan(children: [
            TextSpan(text: "${TextKey.shouyie.tr}: ", style: labelStyle),
            TextSpan(
                text: estimate.profit!.toStringAsFixed(2), style: valueStyle),
          ])),
      ],
    );
  }
}
