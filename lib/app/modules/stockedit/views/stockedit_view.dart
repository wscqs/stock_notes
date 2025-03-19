import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/stockedit_controller.dart';

class StockeditView extends GetView<StockeditController> {
  const StockeditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TextKey.gupiao.tr),
          centerTitle: true,
          actions: [
            ElevatedButton(
                onPressed: () {
                  controller.save();
                },
                child: Text(TextKey.baocun.tr))
          ],
        ),
        body: Obx(() {
          return buildContentView(context);
        }));
  }

  Widget buildContentView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.stockNumController,
            decoration: InputDecoration(
              hintText: TextKey.shurugupiaotishi.tr,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),

              // filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.stockNum.value.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        controller.clearStockNum();
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.blue),
                    onPressed: () {
                      // 处理确认操作
                      // print("股票代码: ${_controller.text}");
                    },
                  ),
                ],
              ),
            ),
          ),
          _gupiaoinfo(context),
          _gupiaojihua(),
          _gupiaojilu(),
        ],
      ),
    );
  }

  Widget _gupiaojilu() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TextKey.jilu.tr, style: Get.textTheme.titleLarge),
          kSpaceH(12),
          TextField(
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.beizui.tr,
              border: OutlineInputBorder(),
              // alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            // keyboardType: TextInputType.multiline,
          ),
          kSpaceH(16),
          TextField(
            maxLines: null, // 允许多行输入
            decoration: InputDecoration(
              labelText: TextKey.shijian.tr + TextKey.jilu.tr,
              border: OutlineInputBorder(),
              // alignLabelWithHint: true, // 标签文字与多行输入对齐
            ),
            // keyboardType: TextInputType.multiline,
          ),
        ]);
  }

  Widget _gupiaojihua() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TextKey.jihua.tr, style: Get.textTheme.titleLarge),
        kSpaceH(8),
        Column(
          children: [
            _rowjiage(type: "price"), //市价
            _rowjiage(type: "market_value"), //市值
            _rowjiage(type: "p_e_ratio"), //市盈率
          ],
        )
      ],
    );
  }

  Widget _rowjiage({required String type}) {
    String titile = "";
    if (type == "price") {
      titile = TextKey.jige.tr;
    } else if (type == "market_value") {
      titile = TextKey.shizhi.tr;
    } else if (type == "p_e_ratio") {
      titile = TextKey.shiyin.tr;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 50, // 设置基线偏移
          baselineType: TextBaseline.alphabetic,
          child: Text(titile + "：",
              style: TextStyle(
                  fontSize: Get.textTheme.titleMedium?.fontSize,
                  fontWeight: FontWeight.bold)),
        ),
        kSpaceW(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                      decoration: InputDecoration(labelText: TextKey.buy.tr),
                    ),
                  ),
                  kSpaceW(12),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      decoration: InputDecoration(labelText: TextKey.sale.tr),
                    ),
                  ),
                  kSpaceW(12),
                  Text(
                    "收益率:%100",
                    style: Get.textTheme.titleMedium,
                  ),
                ],
              ),
              kSpaceH(16),
              TextField(
                maxLines: null, // 允许多行输入
                decoration: InputDecoration(
                  labelText: TextKey.liyou.tr,
                  border: OutlineInputBorder(),
                  // alignLabelWithHint: true, // 标签文字与多行输入对齐
                ),
                // keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gupiaoinfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TextKey.gupiao.tr, style: Get.textTheme.titleLarge),
        kSpaceH(8),
        RichText(
          text: TextSpan(
            text: '春秋航空',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: ' sz601021',
              ),
              TextSpan(
                text: '股价：16.00',
              ),
              TextSpan(
                text: '市值：16.00',
              ),
              TextSpan(
                text: '市盈（TTM）：16.00',
              ),
              TextSpan(
                text: '市净：16.00',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
