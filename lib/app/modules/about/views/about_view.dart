import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/comment_style.dart';
import '../../../../generated/assets.dart';
import '../../commonwidget/simple_cell.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TextKey.guanyu.tr),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          kSpaceH(40.h),

          ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image(
                  image: AssetImage(Assets.imagesIcon), width: 80, height: 80)),

          kSpaceH(20.h),

          Container(
            padding: EdgeInsets.all(16.r),
            child: SimpleCell(
              title: TextKey.guanyu.tr,
              radius: 8,
              onPressed: () {
                controller.toGithub();
                // controller.toCustomerService();
              },
            ),
          )
          // Text('version:${controller.version}'),
          // Text('buildNumber:${controller.buildNumber}'),
        ]));
  }
}
