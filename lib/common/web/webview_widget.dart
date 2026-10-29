import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import '../../utils/qs_hud.dart';

///需要加载的内容类型
enum WebViewType {
  // html文本
  HTMLTEXT,
  // 链接
  URL
}

///定义js通信回调方法
typedef JsChannelCallback = dynamic Function(List<dynamic> arguments);

///封装的WebView组件
class WebViewWidget extends StatefulWidget {
  const WebViewWidget(
      {super.key,
      required this.webViewType,
      required this.loadResource,
      this.jsChannelMap,
      this.onWebViewCreated,
      this.userScripts,
      this.onLoadStop,
      this.onUpdateVisitedHistory,
      this.shouldOverrideUrlLoading,
      this.clearCache});

  // 需要加载的内容类型
  final WebViewType webViewType;

  // 给webview加载的数据，可以是url，也可以是html文本
  final String loadResource;

  // 是否清除缓存后再加载
  final bool? clearCache;

  // 与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  // 文档加载前注入的脚本（如给页面注入原生桥对象）
  final List<UserScript>? userScripts;

  // WebView创建时的回调
  final Function(InAppWebViewController controller)? onWebViewCreated;

  // 导航/历史更新回调（用于拦截自定义 scheme 等）
  final void Function(InAppWebViewController controller, Uri? url)?
      onUpdateVisitedHistory;

  // 页面加载完成回调
  final void Function(InAppWebViewController controller, Uri? url)? onLoadStop;

  // 导航拦截回调，返回 false 表示阻止加载
  final bool Function(InAppWebViewController controller, Uri url)?
      shouldOverrideUrlLoading;

  @override
  State<StatefulWidget> createState() {
    return _WebViewWidgetState();
  }
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (widget.clearCache == true) {
      InAppWebViewController.clearAllCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 夜间模式下避免网页加载前的白屏闪烁：
    // WebView 设为透明背景，底层用主题的 Scaffold 背景色兜底
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          transparentBackground: true,
          // 带宿主标记，让页面能识别"跑在 App WebView 里"
          // （会触发对方按 App 模式隐藏安全区留白等）
          userAgent:
              'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36 StockNotesApp',
        ),
        initialUserScripts: widget.userScripts == null
            ? UnmodifiableListView(const [])
            : UnmodifiableListView(widget.userScripts!),
        initialUrlRequest: widget.webViewType == WebViewType.HTMLTEXT
            ? URLRequest(
                url: WebUri(Uri.dataFromString(
                widget.loadResource,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ).toString()))
            : URLRequest(url: WebUri(widget.loadResource)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          // 调用创建回调
          if (widget.onWebViewCreated != null) {
            widget.onWebViewCreated!(controller);
          }

          // 设置 JS 通信
          if (widget.jsChannelMap != null) {
            widget.jsChannelMap!.forEach((channel, callback) {
              _webViewController.addJavaScriptHandler(
                  handlerName: channel, callback: callback);
            });
          }
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          setState(() {
            QsHud.showLoading(duration: const Duration(seconds: 45));
          });
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          QsHud.dismiss();
          widget.onLoadStop?.call(controller, url);
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          // 可以根据 progress 更新加载进度条
        },
        onConsoleMessage:
            (InAppWebViewController controller, ConsoleMessage message) {
          print(message.message); // 输出控制台信息
        },
        onUpdateVisitedHistory: (InAppWebViewController controller, WebUri? url,
            bool? androidIsReload) {
          widget.onUpdateVisitedHistory?.call(controller, url);
        },
        shouldOverrideUrlLoading:
            (InAppWebViewController controller, NavigationAction action) async {
          final uri = action.request.url;
          if (uri == null) return NavigationActionPolicy.ALLOW;
          if (widget.shouldOverrideUrlLoading != null) {
            final allow = widget.shouldOverrideUrlLoading!(controller, uri);
            if (!allow) return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }

  @override
  void dispose() {
    // 清理 WebView
    _webViewController.dispose();
    super.dispose();
  }
}
