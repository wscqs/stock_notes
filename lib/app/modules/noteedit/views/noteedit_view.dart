import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
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
            // title: Text(TextKey.biji.tr),
            actions: [
              if (controller.isEditing.value)
                IconButton(
                  onPressed: controller.toggleEditMode,
                  icon: const Icon(Icons.visibility),
                  tooltip: '预览',
                ),
              if (!controller.isEditing.value)
                IconButton(
                  onPressed: controller.isLocalData.value
                      ? controller.clickShare
                      : null,
                  icon: const Icon(Icons.share_outlined),
                  tooltip: '分享',
                ),
              IconButton(
                onPressed: controller.isLocalData.value
                    ? controller.clickPushTag
                    : null,
                icon: Icon(
                  (controller.localData.value?.tagList.length ?? 0) > 0
                      ? Remix.price_tag_3_fill
                      : Remix.price_tag_3_line,
                  color: (controller.localData.value?.tagList.length ?? 0) > 0
                      ? Colors.blue
                      : null,
                ),
                tooltip: TextKey.biaoqian.tr,
              ),
              IconButton(
                onPressed: controller.isLocalData.value
                    ? controller.clickOpCollect
                    : null,
                icon: Icon(
                  (controller.localData.value?.opCollect ?? false)
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: (controller.localData.value?.opCollect ?? false)
                      ? Colors.amber
                      : null,
                ),
                tooltip: TextKey.collect.tr,
              ),
              IconButton(
                onPressed: controller.isLocalData.value
                    ? controller.clickOpDelete
                    : null,
                icon: const Icon(Icons.delete_forever),
                tooltip: TextKey.delete.tr,
              ),
              ElevatedButton(
                  onPressed: controller.save, child: Text(TextKey.baocun.tr))
            ],
          ),
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
                                    padding:
                                        const EdgeInsets.only(bottom: 32),
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
                                                left: 16,
                                                right: 16,
                                                bottom: 4),
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
                                              top: 4,
                                              bottom: 12),
                                          child: Divider(
                                              thickness: 0.5,
                                              color: Colors.grey.withValues(
                                                  alpha: 0.5)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              bottom: 16),
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: TextField(
        controller: controller.titleController,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
