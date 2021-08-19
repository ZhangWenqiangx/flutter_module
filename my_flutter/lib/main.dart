import 'package:flutter/material.dart';
import 'package:my_flutter/pages/login_page.dart';

import 'common/Global.dart';
import 'common/Global.dart';

void main() {
  Global.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "index",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "index": (context) => LoginPage(),
      },
    );
  }
}
