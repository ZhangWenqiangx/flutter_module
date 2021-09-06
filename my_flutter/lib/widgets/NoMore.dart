import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoMore extends StatelessWidget {
  const NoMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
          child: Text(
            "我也是有底线的~",
            style: TextStyle(color: Colors.black45),
          )),
    );
  }
}
