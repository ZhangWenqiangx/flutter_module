import 'package:dio/dio.dart';
import 'package:my_flutter/api/api.dart';
import 'package:my_flutter/models/CoinListInfo.dart';
import 'package:my_flutter/models/CoinRankInfo.dart';
import 'package:my_flutter/models/CollectionArticleInfo.dart';
import 'package:my_flutter/models/ShareArticleInfo.dart';
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

  ///退出
  static Future<ApiResponse<Null>> logout() async {
    try {
      var response = await NetUtils.instance.get(Api.LOGOUT);
      return ApiResponse.completed(response);
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

  ///获取自己分享的文章列表，需要登录后访问
  static Future<ApiResponse<ShareArticleInfo>> getShareArticles(
      int page) async {
    try {
      var response = await NetUtils.instance
          .get(Api.SHARE_ARTICLE + page.toString() + "/json");
      return ApiResponse.completed(ShareArticleInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }

  ///获取自己收藏文章列表，需要登录后访问
  static Future<ApiResponse<CollectionArticleInfo>> getCollectionArticles(
      int page) async {
    try {
      var response = await NetUtils.instance
          .get(Api.COLLECTION_ARTICLE + page.toString() + "/json");
      return ApiResponse.completed(CollectionArticleInfo.fromJson(response));
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }

  ///我的收藏页面（该页面包含自己录入的内容）
  static Future<ApiResponse<Null>> unCollect(
      int id, int orgId) async {
    try {
      var response = await NetUtils.instance.postForm(
          Api.UN_COLLECT + "$id/json",
          new FormData.fromMap({
            "originId": "$orgId",
          }));
      return ApiResponse.completed(response);
    } on DioError catch (err) {
      return ApiResponse.error(err.error);
    }
  }
}
