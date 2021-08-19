// import 'package:flutter/material.dart';
//
// ///可以共享数据的InheritedWidget
// class InheritedProvider<T> extends InheritedWidget {
//   InheritedProvider(this.data, Widget child) : super(child: child);
//
//   ///数据
//   final T data;
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
// }
//
// ///Flutter自带具有发布 订阅模式的类      ----------数据变化的通知类
// class ChangeNotifier implements Listenable {
//   List listeners = [];
//
//   @override
//   void addListener(VoidCallback listener) {
//     listeners.add(listener);
//   }
//
//   @override
//   void removeListener(VoidCallback listener) {
//     listeners.remove(listener);
//   }
//
//   void notifyListeners() {
//     listeners.forEach((element) => element);
//   }
// }
//
// class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
//   final Widget child;
//   final T data;
//
//   ChangeNotifierProvider(this.child, this.data);
//
//   // static T of<T>(BuildContext context) {
//     // final type = _typeOf<InheritedProvider<T>>();
//     // final provider = context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
//     // return provider.data;
//   // }
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
