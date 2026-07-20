import 'package:get/get.dart';

import '../common/langs/text_key.dart';
import '../common/web/webview_page.dart';
import '../common/web/webview_widget.dart';
import 'qs_hud.dart';

/// 在应用内 WebView 中打开 http/https 链接。
/// 非 http/https 链接或格式错误时给出提示，不抛出异常。
Future<void> openLinkInAppWebView(String link) async {
  final uri = Uri.tryParse(link.trim());
  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty) {
    QsHud.showToast(TextKey.linkInvalid.tr);
    return;
  }

  final displayTitle = link.length > 40 ? '${link.substring(0, 40)}...' : link;
  Get.to(() => WebViewPage(
        loadResource: link,
        webViewType: WebViewType.URL,
        title: displayTitle,
      ));
}
