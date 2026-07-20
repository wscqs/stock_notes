import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/noteedit_controller.dart';

class NoteeditView extends GetView<NoteeditController> {
  const NoteeditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: controller.canPop, // 动态控制返回手势是否生效
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // 已处理弹出则直接返回
          final allowed = await controller.handlePop();
          if (allowed) {
            //不保存也后退
            Get.back(); // 手动触发返回
          }
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: TextKey.baocun.tr,
                onPressed: controller.saveOnly,
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: TextKey.wancheng.tr,
                onPressed: controller.complete,
              ),
            ],
          ),
          bottomNavigationBar: buildBottomBar(),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      controller: controller.editorScrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (!controller.isEditing.value) {
                                    controller.focusEditorAtEnd();
                                  }
                                },
                                child: Container(
                                  color: Get.theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RepaintBoundary(
                                  key: controller.contentKey,
                                  child: Padding(
                                    // 为分享图片保留底部边距
                                    padding: const EdgeInsets.only(bottom: 32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildTitleTextField(),
                                        if ((controller.localData.value?.tagList
                                                    .length ??
                                                0) >
                                            0)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16, bottom: 4),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4, top: 2),
                                                  child: Icon(
                                                    RemixIcons.price_tag_3_line,
                                                    size: 12,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.localData.value
                                                            ?.homeCellShowTagNames() ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 0,
                                              bottom: 8),
                                          child: Divider(
                                              thickness: 0.5,
                                              color: Colors.grey
                                                  .withValues(alpha: 0.4)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, bottom: 16),
                                          child: buildQuillEditor(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (controller.isEditing.value)
                                  const SizedBox(height: 52),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isEditing.value)
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: buildQuillSimpleToolbar()),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Padding buildTitleTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
      child: TextField(
        controller: controller.titleController,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        minLines: 1,
        maxLines: null,
        decoration: InputDecoration(
          hintText: TextKey.biaoti.tr,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
          counterText: '',
        ),
        maxLength: 50,
      ),
    );
  }

  QuillEditor buildQuillEditor() {
    return QuillEditor(
      focusNode: controller.editorFocusNode,
      // 与外层 SingleChildScrollView 共用同一 ScrollController，
      // 否则 flutter_quill 的 _showCaretOnScreen 因 hasClients=false 不滚动
      scrollController: controller.editorScrollController,
      controller: controller.quillController,
      config: QuillEditorConfig(
        scrollable: false,
        placeholder: '',
        scrollBottomInset: 40,
        onLaunchUrl: (link) {
          controller.handleLinkTap(link);
        },
        customLinkPrefixes: const ['stocknotes://'],
        onTapUp: (details, getPositionForOffset) {
          // 编辑状态下不拦截，允许正常移动光标和编辑文本
          if (controller.isEditing.value) return false;

          final position = getPositionForOffset(details.globalPosition);

          final result = controller.quillController.document
              .querySegmentLeafNode(position.offset);
          final leaf = result.leaf;
          if (leaf != null) {
            final linkAttr = leaf.style.attributes[Attribute.link.key];
            if (linkAttr != null) {
              final link = linkAttr.value as String;
              if (link.startsWith('stocknotes://')) {
                controller.handleLinkTap(link);
                return true; // 阻止默认行为（包括获取焦点）
              }
            }
          }
          return false;
        },
        // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        embedBuilders: [
          ...FlutterQuillEmbeds.editorBuilders(
            imageEmbedConfig: QuillEditorImageEmbedConfig(
              imageProviderBuilder: (context, imageUrl) {
                // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                if (imageUrl.startsWith('assets/')) {
                  return AssetImage(imageUrl);
                }
                return null;
              },
            ),
          ),
          TimeStampEmbedBuilder(),
        ],
      ),
    );
  }

  Widget buildQuillSimpleToolbar() {
    return Container(
      width: double.infinity,
      color: Get.theme.colorScheme.surface,
      child: QuillSimpleToolbar(
        controller: controller.quillController,
        config: QuillSimpleToolbarConfig(
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
              videoButtonOptions: null), //启用图片插入功能
          // multiRowsDisplay: false,
          showFontFamily: false,
          showFontSize: false,
          // showBoldButton: false,
          // showItalicButton: false,
          showSmallButton: false,
          showUnderLineButton: false,
          showStrikeThrough: false,
          showInlineCode: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          // showClearFormat: false,
          showCodeBlock: false,
          showListNumbers: false,
          showListBullets: false,
          showIndent: false,
          showSubscript: false,
          showSuperscript: false,
          showQuote: false,
          showSearchButton: false,
          showHeaderStyle: false,
          showLineHeightButton: false,
          showListCheck: false,
          showDividers: false,
          showLink: false,
          customButtons: [
            //颜色选择
            QuillToolbarCustomButtonOptions(
                icon: Icon(
                  Icons.color_lens_rounded,
                  color: controller.currentTextColor.value,
                ),
                onPressed: () {
                  controller.showColorPicker();
                }),
            // QuillToolbarCustomButtonOptions(
            //   icon: const Icon(Icons.add_alarm_rounded),
            //   onPressed: () {
            //     _controller.document.insert(
            //       _controller.selection.extentOffset,
            //       TimeStampEmbed(
            //         DateTime.now().toString(),
            //       ),
            //     );
            //
            //     _controller.updateSelection(
            //       TextSelection.collapsed(
            //         offset: _controller.selection.extentOffset + 1,
            //       ),
            //       ChangeSource.local,
            //     );
            //   },
            // ),
          ],
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: () {
                final isDesktop = {
                  TargetPlatform.linux,
                  TargetPlatform.windows,
                  TargetPlatform.macOS
                }.contains(defaultTargetPlatform);
                if (isDesktop) {
                  controller.editorFocusNode.requestFocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? buildBottomBar() {
    if (controller.isEditing.value) return null;

    return Obx(() {
      final isDeleted = controller.localData.value?.opDelete == true;
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
    final local = controller.localData.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomActionItem(
          icon: Icons.share_outlined,
          label: TextKey.share.tr,
          onTap: canOperate ? controller.clickShare : null,
        ),
        _buildBottomActionItem(
          icon: (local?.tagList.length ?? 0) > 0
              ? Remix.price_tag_3_fill
              : Remix.price_tag_3_line,
          label: TextKey.biaoqian.tr,
          color: (local?.tagList.length ?? 0) > 0 ? Colors.blue : null,
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
    final canOperate = controller.isLocalData.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBottomActionItem(
          icon: Icons.restore,
          label: TextKey.huifu.tr,
          color: Colors.green,
          onTap: canOperate ? controller.clickRestore : null,
        ),
        _buildBottomActionItem(
          icon: Icons.delete_forever,
          label: TextKey.delete.tr,
          color: theme.colorScheme.error,
          onTap: canOperate ? controller.clickOpDelete : null,
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
                Icon(icon, size: 22, color: effectiveColor),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: effectiveColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
    String value,
  ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
