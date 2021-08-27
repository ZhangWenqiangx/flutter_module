// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_boost/boost_flutter_binding.dart';
import 'package:flutter_boost/boost_navigator.dart';
import 'package:flutter_boost/flutter_boost_app.dart';
import 'package:my_flutter/pages/home_page.dart';
import 'package:my_flutter/pages/login_page.dart';

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
  ///路由表
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    'index': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            return LoginPage();
          });
    },
    'homePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => HomePage());
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
}
