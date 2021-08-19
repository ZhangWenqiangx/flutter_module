import 'dart:convert';

import 'package:dio/dio.dart';

import 'app_exceptions.dart';

class ErrCode {
  /// 成功
  static const SUCCESS = 0;

  /// 登录失效
  static const TOKEN_ERR = -1001;
}

/// 异常拦截
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String jsonStr = json.encode(response.data);
    Map<String, dynamic> map = json.decode(jsonStr);
    var err = map['errorCode'];
    if (err == ErrCode.SUCCESS) {
      handler.next(response);
    } else if (err == ErrCode.TOKEN_ERR) {
      //处理token过期
    } else {
      handler.reject(DioError(
          requestOptions: response.requestOptions,
          error: AppException.create(DioError(
              requestOptions: response.requestOptions,
              error: response.data != null &&
                      response.data is Map &&
                      response.data['errorMsg'] != null &&
                      response.data['errorMsg'].length > 0
                  ? response.data['errorMsg']
                  : "未知异常")),
          response: response));
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    AppException appException = AppException.create(err);
    err.error = appException;
    return super.onError(err, handler);
  }
}
