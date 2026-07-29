import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
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
                        const SizedBox(width: 8),
                        Text(
                          (trade.tradeDate ?? trade.createdAt).toDateString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        if (meetStatus != TradeMeetStatus.none) ...[
                          const SizedBox(width: 8),
                          _buildMeetStatusTag(meetStatus),
                        ],
                      ],
                    ),
                    if (stock != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${stock!.name} (${stock!.code})',
                            style: TextStyle(
                              fontSize: 13,
                              color: Get.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (currentPrice?.isNotEmpty == true) ...[
                            const SizedBox(width: 8),
                            Text(
                              currentPrice!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Get.theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${TextKey.kaicang.tr}: ${trade.openPrice ?? '-'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        if (trade.openShares != null &&
                            trade.openShares!.isNotEmpty) ...[
                          const SizedBox(width: 16),
                          Text(
                            "${TextKey.gushu.tr}: ${trade.openShares}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                    if (trade.closePrice != null &&
                        trade.closePrice!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${TextKey.pingcang.tr}: ${trade.closePrice}",
                            style: TextStyle(fontSize: 14),
                          ),
                          if (trade.closeShares != null &&
                              trade.closeShares!.isNotEmpty) ...[
                            const SizedBox(width: 16),
                            Text(
                              "${TextKey.gushu.tr}: ${trade.closeShares}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (trade.planBuyPrice?.isNotEmpty == true ||
                        trade.planSalePrice?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 12,
                        children: [
                          if (trade.planBuyPrice?.isNotEmpty == true)
                            Text(
                              "${isBuy ? TextKey.zhisunjia.tr : TextKey.zhiyingjia_maihui.tr}: ${trade.planBuyPrice}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Get.theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          if (trade.planSalePrice?.isNotEmpty == true)
                            Text(
                              "${isBuy ? TextKey.zhiyingjia.tr : TextKey.zhisunjia.tr}: ${trade.planSalePrice}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Get.theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (trade.remark != null && trade.remark!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "${TextKey.beizui.tr}: ${trade.remark}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Icon(Icons.edit, size: 18, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline,
                            size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildTradeEstimate(estimate),
                ],
              ),
            ],
          ),
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
    final labelStyle = TextStyle(color: Colors.grey, fontSize: 12);
    final valueStyle = TextStyle(color: valueColor, fontSize: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
