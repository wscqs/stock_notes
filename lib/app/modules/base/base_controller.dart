import 'package:get/get.dart';

class BaseController extends GetxController {
  final isShowCurrentView = false.obs;

  void onResume() {
    isShowCurrentView.value = true;
    // 页面从后台返回前台时调用
    // 在这里添加你希望在 A 页面可见时执行的方法
    // userModel = QsAccount.userInfo;
    // isLogin.value = QsAccount.isLogin;
    // print("onresume");
  }

  //VisibilityDetector 好像有点问题，能少用就少用
  void onPause() {
    isShowCurrentView.value = false;
  }

  //一般处理关闭 没有方法判断，VisibilityDetector不行
  // void onWillPauseOrResume() {}
}
