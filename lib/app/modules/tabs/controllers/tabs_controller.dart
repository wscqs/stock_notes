import 'package:dio/dio.dart';
import 'package:fl_charset/fl_charset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/homenote/views/homenote_view.dart';
import 'package:stock_notes/app/modules/homestock/views/homestock_view.dart';

import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

class TabsController extends GetxController {
  final currentIndex = 0.obs;
  final List<Widget> pages = const [
    HomestockView(),
    HomenoteView(),
  ];
  PageController pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    super.onInit();

    pageController.addListener(() {
      // 当页面切换时，尝试关闭当前页面中的 Slidable
      Slidable.of(Get.context!)?.close();
    });
    // setSystemNavigationBarColor(Colors.black, Brightness.light);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void pushCreatePage() {
    if (currentIndex.value == 0) {
      Get.toNamed(Routes.STOCKEDIT);
    } else {
      Get.toNamed(Routes.NOTEDETAIL);
    }
    // testRequest();
  }

  void setCurrentIndex(index) {
    GetView<BaseController> getHideView =
        pages[currentIndex.value] as GetView<BaseController>;
    getHideView.controller.onPause();
    currentIndex.value = index;
    GetView<BaseController> getShowView =
        pages[currentIndex.value] as GetView<BaseController>;
    getShowView.controller.onResume();
  }

  void clickTab(int index) {
    currentIndex.value = index;
    setCurrentIndex(currentIndex.value);
    pageController.jumpToPage(currentIndex.value);
  }
}

//数据
void testRequest() async {
  final url = "https://qt.gtimg.cn/q=sh600103,sh600104,sh600105";
  try {
    // 发起请求
    final response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes), // 确保获取的是原始字节数据
    );
    String rawData = gbk.decode(response.data);
    // 转换为 JSON 格式
    final jsonData = parseTencentStockData(rawData);

    // 打印结果
    print(jsonData);
  } catch (e) {
    print("Error: $e");
  }
}

//https://blog.csdn.net/com_ma/article/details/80670428
// 数据解析函数
List<Map<String, dynamic>> parseTencentStockData(String rawData) {
  // 按分号分割每个股票的数据
  final lines = rawData.split(';');
  final List<Map<String, dynamic>> result = [];

  for (var line in lines) {
    // 跳过空行
    if (line.trim().isEmpty) continue;

    // 提取每条数据的主体部分 (去掉 v_ 和引号)
    final startIndex = line.indexOf('="');
    if (startIndex == -1) continue; // 无效数据
    final key = line.substring(2, startIndex); // 股票代码
    final rawContent = line.substring(startIndex + 2, line.length - 1);

    // 将主体部分按 ~ 分割
    final parts = rawContent.split('~');

    result.add({
      "market_type": parts[0], // 市场类型
      "name": parts[1], // 股票名称
      "code": key, // 股票代码
      "current_price": parts[3], // 当前价格
      // "previous_close": parts[4], // 昨收价
      // "open_price": parts[5], // 开盘价
      // "volume": parts[6], // 成交量（手）
      // "outer_volume": parts[7], // 外盘
      // "inner_volume": parts[8], // 内盘
      // "buy_prices": [
      //   {"price": parts[9], "volume": parts[10]},
      //   {"price": parts[11], "volume": parts[12]},
      //   {"price": parts[13], "volume": parts[14]},
      //   {"price": parts[15], "volume": parts[16]},
      //   {"price": parts[17], "volume": parts[18]},
      // ], // 买五档
      // "sell_prices": [
      //   {"price": parts[19], "volume": parts[20]},
      //   {"price": parts[21], "volume": parts[22]},
      //   {"price": parts[23], "volume": parts[24]},
      //   {"price": parts[25], "volume": parts[26]},
      //   {"price": parts[27], "volume": parts[28]},
      // ], // 卖五档
      // "latest_trade": parts[29], // 最近逐笔成交
      // "date": parts[30], // 日期
      // "price_change": parts[31], // 涨跌
      // "price_change_percent": parts[32], // 涨跌幅
      // "high_price": parts[33], // 最高价
      // "low_price": parts[34], // 最低价
      // "price_volume_turnover": parts[35], // 价格/成交量/成交额
      // "turnover_volume": parts[36], // 成交量（手）
      // "turnover_amount": parts[37], // 成交额（万）
      // "turnover_rate": parts[38], // 换手率%
      "pe_ratio_ttm": parts[39], // 市盈率（TTM）
      // "amplitude": parts[40], // 振幅
      // "circulating_market_cap": parts[41], // 流通市值（亿）
      "total_market_cap": parts[45], // 总市值（亿）
      "pb_ratio": parts[46], // 市净率
      // "limit_up_price": parts[44], // 涨停价
      // "limit_down_price": parts[45], // 跌停价
      // "volume_ratio": parts[46], // 量比
      // "order_diff": parts[47], // 委差
      // "pe_dynamic": parts[48], // 市盈率（动态）
      // "pe_static": parts[49], // 市盈率（静态）
      // "unknown_1": parts[50], // 未知字段 1
      // "unknown_2": parts[51], // 未知字段 2
      // "unknown_3": parts[52], // 未知字段 3
    });
  }
  return result;
}
