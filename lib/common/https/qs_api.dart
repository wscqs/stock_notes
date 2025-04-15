import 'package:dio/dio.dart';
import 'package:fl_charset/fl_charset.dart';
import 'package:stock_notes/common/https/qs_account.dart';
import 'package:stock_notes/common/https/qs_request.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../model/comment/token_model.dart';
import '../../model/stock_tx_model.dart';

int kPageNum = 10;

class QsApi {
  static QsApi? _instance;

  QsApi._();

  static QsApi instance() {
    return _instance ??= QsApi._();
  }

  //https://xueqiu.com 下面地址需要 cookie 才能访问，后续再用吧（比腾讯多股息率）,用腾讯
  //https://stock.xueqiu.com/v5/stock/quote.json?symbol=SZ000001&extend=detail
  //https://stock.xueqiu.com/v5/stock/batch/quote.json?symbol=SZ000001,SZ399001&extend=detail
  static void stocksList<T>(
      {required String stocks,
      T? decodeType,
      required FinishedCallback<T> completionHandler}) {
    Map<String, dynamic> map = {
      "extend": "detail",
      "symbol": stocks,
    };
    // CachePolicy cache =
    //     page > 1 ? CachePolicy.Default : CachePolicy.ReturnCache_DidLoad;
    QsRequest.go(
        url: "https://stock.xueqiu.com/v5/stock/batch/quote.json",
        params: map,
        // cache: cache,
        decodeType: decodeType,
        // showHUD: true,
        completionHandler: completionHandler);
  }

  //数据
  Future<List<StockTxModel>?> requestStockData(
      {required List<String> stockCodes}) async {
    final url = buildStockUrl(stockCodes);
    print(url);
    List<StockTxModel>? datas;
    try {
      // 发起请求
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes), // 确保获取的是原始字节数据
      );
      String rawData = gbk.decode(response.data);
      // 转换为 JSON 格式
      final jsonData = parseTencentStockData(rawData);
      datas = [];
      for (var item in jsonData) {
        datas?.add(StockTxModel.fromJson(item));
        // print(item);
      }
      // String a = jsonData.toString();
      // String aa = jsonEncode(jsonData);
      // // 打印结果
      // print(jsonData);
    } catch (e) {
      // print("Error: $e");
      QsHud.showToastSerTXError();
    }

    return datas;
  }

  String buildStockUrl(List<String> stockCodes) {
    List<String> formattedCodes = stockCodes.map((code) {
      if (code.startsWith('6')) {
        return 'sh$code'; // 兼容 688 科创板
      } else if (code.startsWith('0') || code.startsWith('3')) {
        return 'sz$code';
      } else {
        return code;
      }
    }).toList();

    return "https://qt.gtimg.cn/q=${formattedCodes.join(',')}";
  }

// https://stock.xueqiu.com/v5/stock/batch/quote.json?symbol=SZ000001,SZ399001&extend=detail
// https://stock.xueqiu.com/v5/stock/quote.json?symbol=SZ000001&extend=detail
// 雪球数据都有（多股息），先用雪球

//https://blog.csdn.net/com_ma/article/details/80670428
//https://blog.csdn.net/afgasdg/article/details/84064421
// 数据解析函数  价格，市值，市盈率 （没股息）
  static List<Map<String, dynamic>> parseTencentStockData(String rawData) {
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

  static void refreshToken(
      {required FinishedCallback<bool> completionHandler}) {
    Map<String, dynamic> map = {
      "refresh_token": QsAccount.loginToken,
    };
    QsRequest.goSafe(
        url: "api/customer/get_accesstoken",
        params: map,
        decodeType: TokenModel(),
        completionHandler: (model, error) {
          if (model != null) {
            TokenModel tempModel = model as TokenModel;
            tempModel.refreshToken = QsAccount.loginToken;
            QsAccount.saveTokenModel(tempModel);
            completionHandler(true, null);
          } else {
            completionHandler(false, null);
          }
        });
  }
  //
  // static void register<T>(
  //     {required String email,
  //     required String password,
  //     required String nickname,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "email": email,
  //     "password": password,
  //     "nickname": nickname,
  //   };
  //   QsRequest.go(
  //       url: "api/customer/register",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // //登录成功判断，model 不为空（model是 tokenModel）
  // static void login<T>(
  //     {required String email,
  //     required String password,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "email": email,
  //     "password": password,
  //   };
  //   if (decodeType == null) {
  //     decodeType = TokenModel() as T?;
  //   }
  //   QsRequest.go(
  //       url: "api/customer/pass_login",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: (model, error) {
  //         if (model != null) {
  //           QsAccount.saveTokenModel(model as TokenModel);
  //           get_userinfo(completionHandler: (model1, error) {
  //             var array = QsCache.get("cache_mess");
  //             if (array != null) {
  //               customer_save_mes(
  //                   cache_mes: array,
  //                   completionHandler: (result, error) {
  //                     if (error == null) {
  //                       QsCache.remove("cache_mess");
  //                     }
  //                     completionHandler(model, error);
  //                   });
  //             } else {
  //               completionHandler(model, error);
  //             }
  //           });
  //         }
  //         if (error != null) {
  //           completionHandler(null, error);
  //         }
  //       });
  // }
  //
  // //登录成功判断，model 不为空（model是 tokenModel）
  // static void loginWithGuest<T>(
  //     {required String deviceid,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "deviceid": deviceid,
  //   };
  //   if (decodeType == null) {
  //     decodeType = TokenModel() as T?;
  //   }
  //   QsRequest.go(
  //       url: "api/tourist/loginByAppleDevice",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: (model, error) {
  //         if (model != null) {
  //           QsAccount.saveTokenModel(model as TokenModel);
  //           get_userinfo(completionHandler: (model1, error) {
  //             var array = QsCache.get("cache_mess");
  //             if (array != null) {
  //               customer_save_mes(
  //                   cache_mes: array,
  //                   completionHandler: (result, error) {
  //                     if (error == null) {
  //                       QsCache.remove("cache_mess");
  //                     }
  //                     completionHandler(model, error);
  //                   });
  //             } else {
  //               completionHandler(model, error);
  //             }
  //           });
  //         }
  //         if (error != null) {
  //           completionHandler(null, error);
  //         }
  //       });
  // }
  //
  // static void guestBindUser<T>(
  //     {required String email,
  //     required String password,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "email": email,
  //     "password": password,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/tourist/bind_email",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void get_userinfo<T>(
  //     {T? decodeType, required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {};
  //   if (decodeType == null) {
  //     decodeType = UserModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/get_userinfo",
  //       params: map,
  //       decodeType: decodeType,
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       // showHUD: true,
  //       completionHandler: (model, error) {
  //         if (model != null) {
  //           UserModel? userModel = model as UserModel;
  //           if (userModel != null) {
  //             QsAccount.saveUserModel(userModel!);
  //           }
  //         }
  //         completionHandler(model, error);
  //       });
  // }
  //
  // static void forget_password<T>(
  //     {required String email,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "email": email,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.go(
  //       url: "api/customer/forget_password",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void update_password<T>(
  //     {required String password,
  //     required String new_password,
  //     required String confirm_password,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "password": password,
  //     "confirm_password": confirm_password,
  //     "new_password": new_password,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/update_password",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void update_nickname<T>(
  //     {required String nickname,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "nickname": nickname,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/update_nickname",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void update_birth_time<T>(
  //     {required String birth_time,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "birth_time": birth_time,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/update_birthday",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void customer_save_mes<T>(
  //     {required List<dynamic> cache_mes,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "cache_mes": cache_mes.join(","),
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/save_mes",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // //占卜
  // static void reading_check<T>(
  //     {T? decodeType, required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {};
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/reading_check",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void get_chat_messagelist<T>(
  //     {T? decodeType, required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "business": "home",
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/get_chat_messagelist",
  //       params: map,
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void get_chat_message<T>(
  //     {required String message_id,
  //     String? sign,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "message_id": message_id,
  //   };
  //   if (sign != null) {
  //     map["sign"] = sign;
  //   }
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/get_chat_message",
  //       params: map,
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void col_chatgpt_message<T>(
  //     {required String message_id,
  //     required String status,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "message_id": message_id,
  //     "status": status,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/col_chatgpt_message",
  //       params: map,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void del_chatgpt_message<T>(
  //     {required String message_id,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "message_id": message_id,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/del_chatgpt_message",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void testvip_edit<T>(
  //     {required String is_vip,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "is_vip": is_vip,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/vip_edit",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void verify_purchase<T>(
  //     {required String package_name,
  //     required String product_id,
  //     required String purchase_token,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) async {
  //   String package_name = await QsDevicePackageInfo.getPackageName();
  //   Map<String, dynamic> map = {
  //     "package_name": package_name,
  //     "product_id": product_id,
  //     "purchase_token": purchase_token,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/verify_subscription",
  //       method: "POST",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void ios_verify_purchase<T>(
  //     {required String receipt_data,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) async {
  //   Map<String, dynamic> map = {
  //     "receipt_data": receipt_data,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/customer/ios_verify_purchase",
  //       method: "POST",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void jubao<T>(
  //     {required String content,
  //     required String reason,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "content": content,
  //     "reason": reason,
  //   };
  //   if (decodeType == null) {
  //     decodeType = EmptyModel() as T?;
  //   }
  //   QsRequest.go(
  //       url: "api/common/jubao",
  //       params: map,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsList<T>(
  //     {required String type, //不选显示全部 read:塔罗占卜 chat:闲聊闲聊
  //     required String order, //不填按照时间排序 hot：按照热度排序 new：按照时间排序
  //     required int page,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "type": type,
  //     "order": order,
  //     "page": page,
  //     "num": kPageNum,
  //   };
  //   CachePolicy cache =
  //       page > 1 ? CachePolicy.Default : CachePolicy.ReturnCache_DidLoad;
  //   QsRequest.goSafe(
  //       url: "api/posts/list",
  //       params: map,
  //       cache: cache,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsMyList<T>(
  //     {required String type, //不选显示全部 post:发帖 replie:评论
  //     required int page,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "type": type,
  //     "page": page,
  //     "num": kPageNum,
  //   };
  //   QsRequest.goSafe(
  //       url: "api/posts/my_list",
  //       params: map,
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsDetails<T>(
  //     {required String post_id,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {"post_id": post_id};
  //   QsRequest.goSafe(
  //       url: "api/posts/detail",
  //       params: map,
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsCommentsList<T>(
  //     {required String post_id, //不选显示全部 read:塔罗占卜 chat:闲聊闲聊
  //     String? post_comments_id,
  //     required int page,
  //     int? num,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     "post_id": post_id,
  //     "post_comments_id": post_comments_id ?? "",
  //     "page": page,
  //     "num": num ?? kPageNum,
  //   };
  //   QsRequest.goSafe(
  //       url: "api/posts/comments_list",
  //       params: map,
  //       cache: CachePolicy.Default,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsSend<T>(
  //     {required String content,
  //     String? message_id,
  //     // String type,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   var type = "chat";
  //   Map<String, dynamic> map = {"content": content};
  //   if (message_id != null && message_id.isNotEmpty) {
  //     type = "read";
  //     map["message_id"] = message_id!;
  //   }
  //   // map["type"] = type!;
  //   QsRequest.goSafe(
  //       url: "api/posts/send_post",
  //       method: "POST",
  //       params: map,
  //       cache: CachePolicy.Default,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void readingList<T>(
  //     {required int page,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {
  //     // "type": type,
  //     "page": page,
  //     "num": kPageNum,
  //   };
  //   QsRequest.goSafe(
  //       url: "api/posts/reading_list",
  //       params: map,
  //       cache: CachePolicy.Default,
  //       decodeType: decodeType,
  //       // showHUD: true,
  //       completionHandler: completionHandler);
  // }
  //
  // static void postsSendComment<T>(
  //     {required String post_id,
  //     required String content,
  //     String? post_comments_id,
  //     String? post_comments_reply_id,
  //     T? decodeType,
  //     required FinishedCallback<T> completionHandler}) {
  //   Map<String, dynamic> map = {"post_id": post_id, "content": content};
  //   if (post_comments_id != null) {
  //     map["post_comments_id"] = post_comments_id!;
  //   }
  //   if (post_comments_reply_id != null) {
  //     map["post_comments_reply_id"] = post_comments_reply_id!;
  //   }
  //   QsRequest.goSafe(
  //       url: "api/posts/send_comments",
  //       method: "POST",
  //       params: map,
  //       cache: CachePolicy.Default,
  //       decodeType: decodeType,
  //       showHUD: true,
  //       completionHandler: completionHandler);
  // }

  // static void register(
  //     {required String email,
  //     required String password,
  //     required String smtp_code}) {
  //   Map<String, dynamic> map = {
  //     "email": email,
  //     "password": password,
  //     "smtp_code": smtp_code,
  //   };
  //   QsRequest.go(
  //       url: "api/customer/register",
  //       params: map,
  //       decodeType: SimpleModel(),
  //       completionHandler: (model, error) {
  //         if (model != null) {
  //           debugPrint("成功返回$model");
  //         }
  //         if (error != null) {
  //           debugPrint("失败了：msg=${error.message}");
  //         }
  //       });
  // }

  // static DioInstance request = DioInstance.instance();

  // Future<TestHomeList> homeList() async {
  //   // Map<String, dynamic> map = {
  //   //   "mobile": mobile,
  //   //   "area_code": "86",
  //   //   "code": code,
  //   // };
  //   Response response = await request.go(
  //       path: "app/getExpertList", cachePolicy: CachePolicy.ReturnNet_DoCache);
  //   TestHomeList homeList = TestHomeList.fromJson(response.data);
  //   print(homeList.toString());
  //   return homeList;
  // }

  // static void homeList() {
  //   QsRequest.go(
  //       url: "banner/json",
  //       decodeType: BannerModel(),
  //       completionHandler: (model, error) {
  //         if (model != null) {
  //           debugPrint("成功返回$model");
  //         }
  //         if (error != null) {
  //           debugPrint("失败了：msg=${error.message}");
  //         }
  //       });
  // }

  // static void homeList1<T>(
  //     {T? decodeType, required FinishedCallback<T> completionHandler}) {
  //   QsRequest.go(
  //       url: "banner/json",
  //       cache: CachePolicy.ReturnCache_DidLoad,
  //       decodeType: decodeType,
  //       completionHandler: completionHandler);
  // }
}

// import 'package:dio/dio.dart';
//
// import 'dio_instance.dart';
//
// class QsApi {
//   static QsApi? _instance;
//   QsApi._();
//   static QsApi instance() {
//     return _instance ??= QsApi._();
//   }
//
//   static DioInstance request = DioInstance.instance();
//
//   Future<StatusModel> actionPhoneVerCode(
//       String mobile, String vcode, String key) async {
//     Map<String, dynamic> map = {
//       "mobile": mobile,
//       "vcode": vcode,
//       "key": key,
//       "event": "login"
//     };
//     Response response =
//         await request.get(path: "api/sendPhoneCode", param: map);
//     return StatusModel.fromJson(response.data);
//   }
//
//   Future<TokenModel> actionLogin(String mobile, String code) async {
//     Map<String, dynamic> map = {
//       "mobile": mobile,
//       "area_code": "86",
//       "code": code,
//     };
//     Response response =
//         await request.get(path: "login/loginbymobile", param: map);
//     TokenModel tokenModel = TokenModel.fromJson(response.data);
//     QsAccount.saveTokenModel(tokenModel);
//     return tokenModel;
//   }
//
//   Future<TokenModel> actionAccessToken() async {
//     Response response = await request.goSafe(path: "api/freshaccesstoken");
//     TokenModel tokenModel = TokenModel.fromJson(response.data);
//     QsAccount.saveTokenModel(tokenModel);
//     return tokenModel;
//   }
//
//   Future<UserModel> actionUserGetuserinfo() async {
//     Map<String, dynamic> map = {
//       "access_token": QsAccount.tokenModel!.accessToken,
//     };
//     Response response =
//         await request.goSafe(path: "user/getuserinfo", param: map);
//     UserModel userModel = UserModel.fromJson(response.data);
//     QsAccount.saveUserModel(userModel);
//     return userModel;
//   }
//
//   Future<BusinessListModel> actionBusinessList() async {
//     Map<String, dynamic> map = {"start": "0", "num": "1000"};
//     Response response = await request.get(path: "business/list", param: map);
//     BusinessListModel model = BusinessListModel.fromJson(response.data);
//     return model;
//   }
//
//   Future<ChatListModel> actionChatList() async {
//     Response response = await request.goSafe(path: "chat/list");
//     ChatListModel model = ChatListModel.fromJson(response.data);
//     return model;
//   }
//
//   ///获取首页文章列表
//   // Future<HomeListData?> homeList(String pageCount) async {
//   //   Response response =
//   //       await DioInstance.instance().get(path: "article/list/$pageCount/json");
//   //   return HomeData.fromJson(response.data).data;
//   //   // return null;
//   // }
// }
