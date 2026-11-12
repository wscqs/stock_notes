import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../base/base_controller.dart';

class BallotController extends BaseController {
  /// 选票清单项
  final items = <BallotItem>[
    BallotItem(
      title: '市场概况',
      icon: Remix.line_chart_line,
      url: 'assets/html/market_overview.html',
      isLocalAsset: true,
    ),
    BallotItem(
      title: '龙头挖掘',
      icon: Remix.search_eye_line,
      url: 'https://longtou-waji.app.workbuddy.host/?sharecode=DI5VYRA25N',
    ),
    BallotItem(
      title: '涨停复盘',
      icon: Remix.stock_line,
      url: 'assets/html/limit_up_review.html',
      isLocalAsset: true,
    ),
    BallotItem(
      title: '最新主题',
      icon: Remix.fire_line,
      url: 'https://latest-theme.app.workbuddy.host/?sharecode=M25PNRLUQH',
    ),
    BallotItem(
      title: '今天炒什么',
      icon: Remix.calendar_event_line,
      url: 'https://ths-today.app.workbuddy.host/?sharecode=NOF5SC6TMB',
    ),
  ].obs;
}

class BallotItem {
  final String title;
  final String url;
  final IconData icon;
  final bool isLocalAsset;

  BallotItem(
      {required this.title,
      required this.url,
      required this.icon,
      this.isLocalAsset = false});
}
