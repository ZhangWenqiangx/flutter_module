import 'package:flutter/material.dart';

/// 点赞/收藏组件
class LikeButtonWidget extends StatefulWidget {
  bool isLike = false;
  Function onClick;

  LikeButtonWidget({Key? key, required this.isLike, required this.onClick})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LikeButtonWidgetState();
}

class LikeButtonWidgetState extends State<LikeButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _iconAnimation;
  double size = 22.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _iconAnimation =
        Tween(begin: size, end: size * 0.5).animate(_animationController);

    _iconAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: size, end: size * 0.5)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(tween: Tween(begin: size * 0.5, end: size), weight: 50),
    ]).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: LikeAnimation(
        controller: _animationController,
        animation: _iconAnimation,
        isLike: widget.isLike,
        onClick: widget.onClick,
      ),
    );
  }
}

class LikeAnimation extends AnimatedWidget implements StatefulWidget {
  AnimationController controller;
  Animation animation;
  Function onClick;
  bool isLike = false;

  LikeAnimation(
      {required this.controller,
      required this.animation,
      required this.isLike,
      required this.onClick})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: isLike
          ? Icon(IconData(0xe620, fontFamily: 'myIcon'),
              color: Colors.redAccent, size: animation.value)
          : Icon(
              IconData(0xe8bc, fontFamily: 'myIcon'),
              color: Colors.black,
              size: animation.value,
            ),
      onTapDown: (dragDownDetails) {
        controller.forward();
      },
      onTapUp: (dragDownDetails) {
        Future.delayed(Duration(milliseconds: 100), () {
          controller.reverse();
          onClick();
        });
      },
    );
  }
}
