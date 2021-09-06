// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_channel.dart';
import 'package:flutter_boost/boost_flutter_binding.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:flutter_boost/flutter_boost_app.dart';
import 'package:my_flutter/pages/coin_list_page.dart';
import 'package:my_flutter/pages/coin_rank_page.dart';
import 'package:my_flutter/pages/home_page.dart';
import 'package:my_flutter/pages/login_page.dart';

import 'api/api.dart';
import 'common/Global.dart';

class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

void main() {
  Global.init().then((value) {
    CustomFlutterBinding();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VoidCallback removeListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userCookieListener();
    });
  }

  ///路由表
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    'login': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => LoginPage());
    },
    'home': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => HomePage());
    },
    'coin_list': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => CoinListPage(params: settings.arguments));
    },
    'coin_rank': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => CoinRankPage());
    },
  };

  Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
    var func = routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(routeFactory);
  }

  ///从原生拿用户cookie
  void userCookieListener() {
    removeListener = BoostChannel.instance.addEventListener("resultOfCookie",
        (key, arguments) {
      var cookies = <Cookie>[];
      List decode = json.decode(arguments["result"]);
      decode.forEach((element) {
        print(element);
        cookies.add(Cookie(element['name'], element['value']));
      });
      Global.cookieJar.saveFromResponse(Uri.parse(Api.BASE_URL), cookies);
      return;
    });
    BoostChannel.instance.sendEventToNative("getCookie", {"": ""});
  }

  @override
  void dispose() {
    super.dispose();
    removeListener?.call();
  }
}
