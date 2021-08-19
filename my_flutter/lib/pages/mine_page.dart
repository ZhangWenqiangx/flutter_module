import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinePage extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<MinePage> {
  static const platform = const MethodChannel("flutter.flutter/demo");
  String _batteryLevel = "unknown battert level";
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: Column(
        children: [
          Text(_batteryLevel),
          TextButton(
              onPressed: () {
                _getBattertLevel();
              },
              child: Text("get battery level"))
        ],
      ),
    );
  }

  Future<Null> _getBattertLevel() async {
    String batteryLevel;
    final int result = await platform.invokeMethod('getBatteryLevel');
    batteryLevel = "battery level is $result%";
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  // loadData() async {
  //   var receivePort = ReceivePort();
  //   await Isolate.spawn(dataLoader, receivePort.sendPort);
  //   SendPort sendPort = await receivePort.first;
  // }
  //
  //
  //
  // //创建自己的监听port 并且向新的isolate发送
  // Future sendReceive(SendPort sendPort, String url) {
  //   var receivePort = ReceivePort();
  //   sendPort.send([url, receivePort.sendPort]);
  //   //接收返回值 并返回
  //   return receivePort.first;
  // }
}

class Counter with ChangeNotifier {
  int _count;

  Counter(this._count);

  void add() {
    _count++;
    notifyListeners();
  }

  get count => _count;
}
