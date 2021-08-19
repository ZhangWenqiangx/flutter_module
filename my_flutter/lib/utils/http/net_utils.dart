import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'ErrorInterceptor.dart';

Map<String, dynamic> optHeader = {'content-type': 'application/json'};

var dio = Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

class NetUtils {
  static Future get(String url, [Map<String, dynamic>? params]) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    var response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return getData(response);
  }

  static Future post(String url, Map<String, dynamic> params) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    var response = await dio.post(url, data: params);
    return getData(response);
  }

  static Future postForm(String url, FormData params) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    var response = await dio.post(url, data: params);
    return getData(response);
  }

  static getData(Response response) {
    String jsonStr = json.encode(response.data);
    Map<String, dynamic> map = json.decode(jsonStr);
    return map['data'];
  }
}
