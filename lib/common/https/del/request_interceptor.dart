// import 'package:dio/dio.dart';
//
// import '../base_model.dart';
//
// class RequestInterceptor extends InterceptorsWrapper {
//   // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//   //   // TODO: implement onRequest
//   //   super.onRequest(options, handler);
//   // }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     // if (response.realUri.path.indexOf('sendPhoneCode') >= 0) {
//     //   print(response.data);
//     // }
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = response.data;
//       var rsp = BaseModel.fromJson(data);
//       if (rsp.errorCode != null && rsp.errorCode != 0) {
//         // if (rsp.errorCode == 10001) {
//         //   //刷新token
//         //   //todo
//         //   QsApi.instance().actionAccessToken().then((onValue) {
//         //     //刷新成功，重新发起请求
//         //     // return DioInstance.instance().get(path: path)
//         //     print("刷新token成功");
//         //     RequestOptions requestOptions = response.requestOptions;
//         //     return DioInstance.instance().goSafe(
//         //         path: requestOptions.path,
//         //         options: Options(
//         //           method: requestOptions.method,
//         //           headers: requestOptions.headers,
//         //         ),
//         //         param: requestOptions.queryParameters);
//         //   });
//         // } else if (rsp.errorCode == 10002) {
//         //   // logintoken 过期
//         //   QsAccount.cleanAccount();
//         // } else {
//         //   DialogHelper.showToast(rsp.errorMsg ?? "服务端出差了");
//         // }
//       } else {
//         // handler.next(Response(
//         //     requestOptions: response.requestOptions, data: data)); //rsp.data
//         super.onResponse(response, handler);
//       }
//     } else {
//       handler.reject(DioException(requestOptions: response.requestOptions));
//     }
//   }
// }
