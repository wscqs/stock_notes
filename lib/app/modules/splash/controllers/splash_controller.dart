import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/web/webview_page.dart';
import '../../../../utils/qs_cache.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

class SplashController extends BaseController {

  @override
  void onReady() {
    super.onReady();
    _loadData();
  }


  // 延迟加载数据，显示闪屏页
  _loadData() async {
    // 模拟闪屏页的延时（例如 2 秒）
    await Future.delayed(Duration(seconds: 1));
    // 检查是否已同意隐私政策
    _checkPrivacyPolicyAgreement();
  }

  // 检查隐私政策是否同意
  _checkPrivacyPolicyAgreement() async {
    bool hasAgreed =
        QsCache.getInstance().getSP<bool>("has_agreed_privacy_policy") ?? false;
    // 如果没有同意隐私政策，弹出隐私政策弹窗
    if (!hasAgreed) {
      _showPrivacyPolicyDialog();
    } else {
      _navigateToHomePage();
    }
  }

  _navigateToHomePage() {
    // 否则直接跳转到主界面
    Get.offAllNamed(Routes.TABS);
  }

  // 弹出隐私政策弹窗
  _showPrivacyPolicyDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false, // 禁止点击外部关闭
      builder: (BuildContext context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              SystemNavigator.pop();
            }
          },
          child: AlertDialog(
            title: Text('Privacy Policy'),
            content: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  text:
                      'Thank you for your trust and use of tarot. In accordance with the latest legal requirements, we have updated the 《',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'User Agreement',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _toUserAgreementPage();
                        },
                    ),
                    TextSpan(text: '》And《'),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _toPrivacyPage();
                        },
                    ),
                    TextSpan(
                        text:
                            '》, we are sending this tip to you. Please read carefully and fully understand our principles for handling your personal information.\n\n'),
                    TextSpan(
                        text:
                            'If you click "Agree," it means you have read and agreed to the updated terms and policies. We will strictly use your personal information in accordance with the terms you have agreed to, in order to provide you with better service.'),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Disagree'),
              ),
              TextButton(
                onPressed: () async {
                  QsCache.getInstance()
                      .setSPBool("has_agreed_privacy_policy", true);
                  _navigateToHomePage();
                },
                child: Text('Agree'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toUserAgreementPage() {
    Get.to(() => WebViewPage(
        loadResource:
            "https://www.kezhitong.com.cn/protocol.html?type=app_service",
        title: "User Agreement"));
  }

  void _toPrivacyPage() {
    Get.to(() => WebViewPage(
        loadResource:
            "https://www.kezhitong.com.cn/protocol.html?type=app_service",
        title: "Privacy Policy"));
  }
}
