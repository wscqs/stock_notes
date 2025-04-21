import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/noteedit_controller.dart';

class NoteeditView extends GetView<NoteeditController> {
  const NoteeditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(TextKey.biji.tr),
          actions: [
            ElevatedButton(
                onPressed: controller.save, child: Text(TextKey.baocun.tr))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: TextField(
                  controller: controller.titleController,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: TextKey.biaoti.tr,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // if (!controller.isEditing.value) {
                    //   FocusScope.of(context).requestFocus(FocusNode());
                    // }
                  },
                  child: QuillEditor(
                    focusNode: controller.editorFocusNode,
                    scrollController: controller.editorScrollController,
                    controller: controller.quillController,
                    config: QuillEditorConfig(
                      placeholder: '',
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      // embedBuilders: [
                      // ...FlutterQuillEmbeds.editorBuilders(
                      //   imageEmbedConfig: QuillEditorImageEmbedConfig(
                      //     imageProviderBuilder: (context, imageUrl) {
                      //       // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                      //       if (imageUrl.startsWith('assets/')) {
                      //         return AssetImage(imageUrl);
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // videoEmbedConfig: QuillEditorVideoEmbedConfig(
                      //   customVideoBuilder: (videoUrl, readOnly) {
                      //     // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
                      //     return null;
                      //   },
                      // ),
                      // ),
                      // TimeStampEmbedBuilder(),
                      // ],
                    ),
                  ),
                ),
              ),
              if (controller.isEditing.value) buildQuillSimpleToolbar(),
            ],
          ),
        ),
      );
    });
  }

  QuillSimpleToolbar buildQuillSimpleToolbar() {
    return QuillSimpleToolbar(
      controller: controller.quillController,
      config: QuillSimpleToolbarConfig(
        // embedButtons: FlutterQuillEmbeds.toolbarButtons(), //等以后有服务器再添
        // multiRowsDisplay: false,
        showFontFamily: false,
        showFontSize: false,
        // showBoldButton: false,
        showItalicButton: false,
        showSmallButton: false,
        showUnderLineButton: false,
        showStrikeThrough: false,
        showInlineCode: false,
        // showColorButton: false,
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
        // showDividers: false,
        // customButtons: [
        //   QuillToolbarCustomButtonOptions(
        //     icon: const Icon(Icons.add_alarm_rounded),
        //     onPressed: () {
        //       _controller.document.insert(
        //         _controller.selection.extentOffset,
        //         TimeStampEmbed(
        //           DateTime.now().toString(),
        //         ),
        //       );
        //
        //       _controller.updateSelection(
        //         TextSelection.collapsed(
        //           offset: _controller.selection.extentOffset + 1,
        //         ),
        //         ChangeSource.local,
        //       );
        //     },
        //   ),
        // ],
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
