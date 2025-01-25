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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: '请输入股票代码',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  // filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
              _gupiaoinfo(context),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TextKey.jihua.tr, style: Get.textTheme.titleLarge),
                  kSpaceH(8),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(TextKey.jige.tr,
                              style: Get.textTheme.titleMedium),
                          Text(":", style: Get.textTheme.titleMedium),
                          kSpaceW(8),
                          Text(TextKey.buy.tr),
                          kSpaceW(2),
                          // TextField(
                          //   decoration: InputDecoration(
                          //     hintText: '',
                          //     prefixIcon: Icon(Icons.search),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //     ),
                          //     // filled: true,
                          //     contentPadding: EdgeInsets.symmetric(
                          //         horizontal: 16.0, vertical: 12.0),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
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
