import 'package:get/get.dart';

class BaseController extends GetxController {
  final isShowCurrentView = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onResume() {
    isShowCurrentView.value = true;
    // 页面从后台返回前台时调用
    // 在这里添加你希望在 A 页面可见时执行的方法
    // userModel = QsAccount.userInfo;
    // isLogin.value = QsAccount.isLogin;
    // print("onresume");
  }

  void onPause() {
    isShowCurrentView.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
