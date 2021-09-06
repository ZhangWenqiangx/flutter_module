import 'package:dio/dio.dart';
import 'package:my_flutter/api/api.dart';
import 'package:my_flutter/models/CoinListInfo.dart';
import 'package:my_flutter/models/CoinRankInfo.dart';
import 'package:my_flutter/models/UserInfo.dart';

import 'http/api_response.dart';
import 'http/net_utils.dart';

/// 只关心入参/数据和异常
class DataUtils {
  /// 登陆
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

  ///获取个人积分，需要登录后访问
  static Future<ApiResponse<CoinListInfo>> getUserCoinList(int page) async {
    try {
      var response = await NetUtils.instance.get(Api.COIN_LIST + "$page/json");
      return ApiResponse.completed(CoinListInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }

  ///获取个人积分，需要登录后访问
  static Future<ApiResponse<CoinRankInfo>> getCoinRank(int page) async {
    try {
      var response = await NetUtils.instance
          .get(Api.COIN_RANK + page.toString() + "/json");
      return ApiResponse.completed(CoinRankInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }
}
