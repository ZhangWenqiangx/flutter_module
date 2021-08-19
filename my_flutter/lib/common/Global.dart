import 'package:flutter/material.dart';

//主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static List<MaterialColor> get themes => _themes;

  static bool get isRealease => bool.fromEnvironment("dart.vm.product");

  static Future init() async{

  }
}
