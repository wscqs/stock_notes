import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/database.dart';
import '../../../../common/widget/qs_empty_view.dart';
import '../controllers/messagelist_controller.dart';

class MessagelistView extends GetView<MessagelistController> {
  const MessagelistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.xiaoxi.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.messages.isEmpty) {
          return QsEmptyView(message: TextKey.noData.tr);
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final msg = controller.messages[index];
            final showDateHeader = index == 0 ||
                !_isSameDay(
                    controller.messages[index - 1].createdAt, msg.createdAt);
            return Column(
              children: [
                if (showDateHeader) _buildDateHeader(msg.createdAt),
                _buildMsgCell(msg),
              ],
            );
          },
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 日期分组头（灰色小胶囊，居中）
  Widget _buildDateHeader(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          date.toDateString(),
          style: TextStyle(
            fontSize: 12,
            color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildMsgCell(MessageItem msg) {
    return Dismissible(
      key: ValueKey(msg.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        controller.deleteMsg(msg);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(top: 4, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 8),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: InkWell(
          onTap: () {
            controller.clickLookDetail(msg);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：名称(代码) 维度值 + 右侧条件标签（价格:满足B）
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            // 名称(代码)
                            TextSpan(
                              text: controller.msgTitleName(msg),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Get.theme.colorScheme.onSurface
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                            // 维度值：最新价X / 市值X / 市盈(MMT)X
                            TextSpan(
                              text: ' ${controller.msgTitleValue(msg)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Get.theme.colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    kSpaceW(8),
                    _buildConditionTag(controller.msgConditionTag(msg)),
                  ],
                ),
                kSpaceH(2),
                Text(
                  msg.createdAt.format(DateFormats.mo_d_h_m),
                  style: TextStyle(
                    fontSize: 11,
                    color: Get.theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
                ),
                kSpaceH(6),
                // 消息文案
                Text(
                  controller.msgContent(msg),
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color:
                        Get.theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                kSpaceH(8),
                Divider(
                  height: 1,
                  color: Get.theme.colorScheme.outlineVariant
                      .withValues(alpha: 0.3),
                ),
                // 查看详情
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          TextKey.chakanxiangqing.tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Get.theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Get.theme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 条件标签（同首页cell）：B 红色、S 蓝色
  Widget _buildConditionTag(String tag) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 11,
          color: Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          height: 1.22,
        ),
        children: tag.split('').map((char) {
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
}
