import 'package:get/get.dart';

import '../../base/base_controller.dart';

class BallotController extends BaseController {
  /// 选票清单项（占位数据，后续接入真实的想买股票筛选功能）
  final items = <BallotItem>[
    BallotItem(
      title: '龙头挖掘',
      url: 'https://longtou-waji.app.workbuddy.host/?sharecode=DI5VYRA25N',
    ),
  ].obs;
}

class BallotItem {
  final String title;
  final String url;

  BallotItem({required this.title, required this.url});
}
