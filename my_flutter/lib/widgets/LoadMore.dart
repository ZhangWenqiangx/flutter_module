import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadMore extends StatelessWidget {
  const LoadMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(child: new CircularProgressIndicator()),
    );
  }
}
