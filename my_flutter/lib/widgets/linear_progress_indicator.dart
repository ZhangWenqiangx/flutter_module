import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineProgressIndicator extends StatefulWidget {
  double maxValue;
  bool completed = false;
  LineProgressIndicator({Key? key, required this.maxValue}) : super(key: key);

  @override
  LineProgressIndicatorState createState() => LineProgressIndicatorState();
}

class LineProgressIndicatorState extends State<LineProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _animate;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() => {}));

    _animate = Tween<double>(
      begin: 0.0,
      end: widget.maxValue,
    );

    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.completed = true;
      }
    });

    _animationController.forward();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: LinearProgressIndicator(
        value: _animate.animate(_animationController).value,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Color(0xFF6BB9F7)),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
