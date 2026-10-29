import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_notes/common/web/webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import '../../utils/qs_hud.dart';

///显示网页资源的页面
class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.loadResource,
    this.webViewType = WebViewType.URL,
    this.showTitle = true,
    this.title,
    this.jsChannelMap,
    this.userScripts,
    this.onWebViewCreated,
    this.onLoadStop,
    this.onUpdateVisitedHistory,
    this.shouldOverrideUrlLoading,
  });

  //是否显示标题
  final bool? showTitle;

  //标题内容
  final String? title;

  //需要加载的内容类型
  final WebViewType webViewType;

  //给webview加载的数据,可以是url，也可以是html文本
  final String loadResource;

  //与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  // 文档加载前注入的脚本（如给页面注入原生桥对象）
  final List<UserScript>? userScripts;

  // WebView创建回调（仅本页使用；addJavaScriptHandler 需在此时机注册）
  final Function(InAppWebViewController controller)? onWebViewCreated;

  // 导航/历史更新回调（用于拦截自定义 scheme）
  final void Function(InAppWebViewController controller, Uri? url)?
      onUpdateVisitedHistory;

  // 页面加载完成回调（DOM 已就绪，适合注入 CSS/JS）
  final void Function(InAppWebViewController controller, Uri? url)? onLoadStop;

  // 导航拦截回调，返回 false 表示阻止加载
  final bool Function(InAppWebViewController controller, Uri url)?
      shouldOverrideUrlLoading;

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.showTitle ?? false)
          ? AppBar(
              title: _buildAppBarTitle(widget.showTitle, widget.title),
              centerTitle: true,
              // leading: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.arrow_back_ios_new),
              //       onPressed: () {
              //         if (_webViewController.canGoBack()) {
              //           _webViewController.goBack();
              //         } else {
              //           Navigator.pop(context);
              //         }
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(
              //         Icons.home_outlined,
              //         size: 30,
              //       ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ],
              // ),
              // leadingWidth: 100,

              // actions: <Widget>[
              //   if (widget.webViewType == WebViewType.URL) ...[
              //     IconButton(
              //       icon: const Icon(Icons.copy),
              //       onPressed: _copyUrlToClipboard,
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.open_in_browser),
              //       onPressed: _openBrowser,
              //     ),
              //   ],
              // ],
            )
          : null,
      body: SafeArea(
        child: WebViewWidget(
          webViewType: widget.webViewType,
          loadResource: widget.loadResource,
          jsChannelMap: widget.jsChannelMap,
          userScripts: widget.userScripts,
          onWebViewCreated: widget.onWebViewCreated,
          onLoadStop: widget.onLoadStop,
          onUpdateVisitedHistory: widget.onUpdateVisitedHistory,
          shouldOverrideUrlLoading: widget.shouldOverrideUrlLoading,
        ),
      ),
    );
  }

  void _copyUrlToClipboard() {
    // 设置数据到剪切板
    Clipboard.setData(ClipboardData(text: widget.loadResource));
    QsHud.showToast("Copy successful");
  }

  void _openBrowser() async {
    Uri uri = Uri.parse(widget.loadResource);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget _buildAppBarTitle(bool? showTitle, String? title) {
    var show = showTitle ?? false;
    return show
        ? Text(
            title ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        : const SizedBox.shrink();
  }

  String limitsStr(String? content, {int limit = 15}) {
    if (content == null || content.isEmpty == true) {
      return "";
    }
    if (content.length > 15) {
      return content.substring(0, 15);
    } else {
      return content;
    }
  }
}
