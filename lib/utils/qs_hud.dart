import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

// const kSERERROR = "服务端出差了，请稍后重试";
// const kNETERROR = "当前网络不可用，请查看网络设置";

class QsHud {
  QsHud._();

  /// 显示Toast
  /// display几秒，默认2秒
  /// delay延迟几秒
  static void showToast(
    String message, {
    int displaySeconds = 2,
    int delaySeconds = 0,
  }) {
    Duration displayTime = Duration(seconds: displaySeconds);
    if (delaySeconds == 0) {
      SmartDialog.dismiss(status: SmartStatus.toast);
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast(message,
          alignment: Alignment.center, displayTime: displayTime);
    } else {
      Future.delayed(Duration(seconds: delaySeconds), () {
        SmartDialog.dismiss(status: SmartStatus.toast);
        SmartDialog.dismiss(status: SmartStatus.loading);
        SmartDialog.showToast(message,
            alignment: Alignment.center, displayTime: displayTime);
      });
    }
  }

  static void showToastNetError() {
    // showToast(kNETERROR);
    showToast(TextKey.neterror.tr);
  }

  static void showToastSerError() {
    // showToast(kNETERROR);
    showToast(TextKey.sererror.tr);
  }

  static void showToastSerTXError() {
    // showToast(kNETERROR);
    showToast("Tx${TextKey.sererror.tr}");
  }

  /// 显示加载对话框
  static void showLoading({String message = '加载中...', Duration? duration}) {
    // message = 'loading...';
    message = TextKey.jiazai.tr;
    SmartDialog.showLoading(
        msg: message, displayTime: duration ?? const Duration(hours: 1));
  }

  /// 显示成功
  static void showSuccessNotify({String msg = 'success', Duration? duration}) {
    SmartDialog.dismiss(status: SmartStatus.loading);
    SmartDialog.showNotify(msg: msg, notifyType: NotifyType.success);
  }

  /// 显示失败
  static void showErrorNotify({String msg = 'error', Duration? duration}) {
    SmartDialog.dismiss(status: SmartStatus.loading);
    SmartDialog.showNotify(msg: msg, notifyType: NotifyType.error);
  }

  // 隐藏当前显示的对话框或加载器
  static void dismiss() {
    SmartDialog.dismiss();
  }

  // 显示自定义对话框
  static void showDialog(Widget widget) {
    SmartDialog.show(builder: (_) {
      return widget;
    });
  }

  // 显示带有确认和取消按钮的对话框
  static void showConfirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = '确认',
    String cancelText = '取消',
  }) {
    SmartDialog.show(builder: (_) {
      return AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: content.isNotEmpty ? Text(content) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
              dismiss();
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              dismiss();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    });
  }

  // 显示带有确认和取消按钮的对话框
  static void showKnowDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = '知道了',
  }) {
    SmartDialog.show(builder: (_) {
      return AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: content.isNotEmpty ? Text(content) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              dismiss();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    });
  }

// 其他自定义对话框的封装可以根据需要添加
}
