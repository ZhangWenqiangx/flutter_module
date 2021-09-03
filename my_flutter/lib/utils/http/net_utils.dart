import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:my_flutter/common/Global.dart';

import 'ErrorInterceptor.dart';

Map<String, dynamic> optHeader = {'content-type': 'application/json'};

class NetUtils {
  factory NetUtils() => _getInstance();

  static NetUtils get instance => _getInstance();
  static NetUtils? _instance;
  static late Dio _dio;

  static NetUtils _getInstance() {
    if (null == _instance) {
      _instance = new NetUtils._internal();
    }
    return _instance!;
  }

  NetUtils._internal() {
    _dio = Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));
    _dio.interceptors.add(ErrorInterceptor());
    _dio.interceptors.add(CookieManager(Global.cookieJar));
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future get(String url, [Map<String, dynamic>? params]) async {
    var response;
    if (params != null) {
      response = await _dio.get(url, queryParameters: params);
    } else {
      response = await _dio.get(url);
    }
    return _getData(response);
  }

  Future post(String url, Map<String, dynamic> params) async {
    var response = await _dio.post(url, data: params);
    return _getData(response);
  }

  Future postForm(String url, FormData params) async {
    var response = await _dio.post(url, data: params);
    return _getData(response);
  }

  _getData(Response response) {
    String jsonStr = json.encode(response.data);
    Map<String, dynamic> map = json.decode(jsonStr);
    return map['data'];
  }
}
