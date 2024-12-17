import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/qs_hud.dart';

/// 返回回调
typedef DoublePressBackCallback = bool Function();

/// DoublePressBackWidget
// ignore: must_be_immutable
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
      QsHud.showToast(message ?? '再次按回以退出');
      return false;
    }
    _currentBackPressTime = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
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
