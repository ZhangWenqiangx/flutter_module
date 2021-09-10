// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_boost/boost_channel.dart';
import 'package:flutter_boost/boost_flutter_binding.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:flutter_boost/flutter_boost_app.dart';
import 'package:fps_monitor/widget/custom_widget_inspector.dart';
import 'package:my_flutter/pages/coin_list_page.dart';
import 'package:my_flutter/pages/coin_rank_page.dart';
import 'package:my_flutter/pages/login_page.dart';
import 'package:my_flutter/pages/my_collection_page.dart';
import 'package:my_flutter/pages/my_share_page.dart';
import 'package:my_flutter/pages/setting_page.dart';
import 'package:my_flutter/utils/http/cookie_utils.dart';

import 'api/api.dart';
import 'common/Constance.dart';
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
  GlobalKey<NavigatorState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerCookieListener();
    });
  }

  ///路由表
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    FLUTTER_PAGE_LOGIN: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => LoginPage());
    },
    FLUTTER_PAGE_COIN_LIST: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) =>
              CoinListPage(params: settings.arguments));
    },
    FLUTTER_PAGE_COIN_RANK: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => CoinRankPage());
    },
    FLUTTER_PAGE_SHARE: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => MySharePage());
    },
    FLUTTER_PAGE_COLLECTION: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => MyCollectionPage());
    },
    FLUTTER_PAGE_SETTING: (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => SettingPage());
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
    SchedulerBinding.instance.addPostFrameCallback(
        (t) => overlayState = globalKey.currentState.overlay);
    return MaterialApp(
        navigatorKey: globalKey,
        builder: (ctx, child) => CustomWidgetInspector(
              child: child,
            ),
        home: FlutterBoostApp(routeFactory));
  }

  ///从原生拿用户cookie
  void registerCookieListener() {
    removeListener = BoostChannel.instance
        .addEventListener(FLUTTER_MSG_RESULT_COOKIE, (key, arguments) {
      var cookies = CookieUtils.encodeCookie(arguments["result"]);
      Global.cookieJar.saveFromResponse(Uri.parse(Api.BASE_URL), cookies);
      return;
    });
    BoostChannel.instance.sendEventToNative(FLUTTER_MSG_GET_COOKIE, {"": ""});
  }

  @override
  void dispose() {
    super.dispose();
    removeListener?.call();
  }
}
