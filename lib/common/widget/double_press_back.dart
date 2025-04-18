import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../utils/qs_hud.dart';

/// 返回回调
typedef DoublePressBackCallback = bool Function();

/// DoublePressBackWidget
class DoublePressBackWidget extends StatelessWidget {
  final Widget child;
  final String? message;
  final DoublePressBackCallback? backCallback;
  final DoublePressBackCallback?
      oneBackCallback; //页面操作模式下，一次回调可以处理后退操作. 操作给 true，没操作要 false

  DateTime? _currentBackPressTime;

  DoublePressBackWidget({
    super.key,
    required this.child,
    this.message,
    this.backCallback,
    this.oneBackCallback,
  });

  // 返回键退出
  bool closeOnConfirm() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      QsHud.showToast(message ?? TextKey.ercihoutui.tr);
      return false;
    }
    _currentBackPressTime = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (oneBackCallback?.call() ?? false) {
          return;
        }
        if (closeOnConfirm()) {
          if (backCallback?.call() ?? true) {
            SystemNavigator.pop();
          }
        }
      },
      child: child,
    );
  }
}
