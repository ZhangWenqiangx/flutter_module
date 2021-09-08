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
            "没有了~",
            style: TextStyle(color: Colors.black45),
          )),
    );
  }
}
