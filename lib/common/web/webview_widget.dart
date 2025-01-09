import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/qs_hud.dart';

///需要加载的内容类型
enum WebViewType {
  //html文本
  HTMLTEXT,
  //链接
  URL
}

///定义js通信回调方法
typedef dynamic JsChannelCallback(List<dynamic> arguments);

///封装的WebView组件
class WebViewWidget extends StatefulWidget {
  const WebViewWidget(
      {super.key,
      required this.webViewType,
      required this.loadResource,
      this.jsChannelMap,
      this.onWebViewCreated,
      this.clearCache});

  //需要加载的内容类型
  final WebViewType webViewType;

  //给webview加载的数据,可以是url，也可以是html文本
  final String loadResource;

  //是否清除缓存后再加载
  final bool? clearCache;

  //与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<StatefulWidget> createState() {
    return _WebViewWidgetState();
  }
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.loadResource)),
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        setState(() {
          QsHud.showLoading(duration: const Duration(seconds: 45));
        });
      },
      // 页面停止加载时的回调
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        setState(() {
          QsHud.dismiss(); //面停止加载，更新状态为 false
        });
      },
    );
  }
}
