import 'package:dio/dio.dart';
import 'package:my_flutter/api/api.dart';
import 'package:my_flutter/models/CoinListInfo.dart';
import 'package:my_flutter/models/UserInfo.dart';

import 'http/api_response.dart';
import 'http/net_utils.dart';

/// 只关心入参/数据和异常
class DataUtils {
  // 登陆
  static Future<ApiResponse<UserInfo>> doLogin(
      String username, String password) async {
    try {
      var response = await NetUtils.instance.postForm(
          Api.DO_LOGIN,
          new FormData.fromMap({
            "username": "$username",
            "password": "$password",
          }));
      return ApiResponse.completed(UserInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }

  static Future<ApiResponse<CoinListInfo>> getUserCoinList(int page) async {
    try {
      var response = await NetUtils.instance.get(Api.COIN_LIST + page.toString()+"/json");
      return ApiResponse.completed(CoinListInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }
}
