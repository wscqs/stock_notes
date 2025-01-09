import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/qs_hud.dart';

/// 返回回调
typedef DoublePressBackCallback = bool Function();

/// DoublePressBackWidget
class DoublePressBackWidget extends StatelessWidget {
  final Widget child;
  final String? message;
  final DoublePressBackCallback? backCallback;

  DateTime? _currentBackPressTime;

  DoublePressBackWidget({
    super.key,
    required this.child,
    this.message,
    this.backCallback,
  });

  // 返回键退出
  bool closeOnConfirm() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      QsHud.showToast(message ?? 'Press back again to exit');
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
