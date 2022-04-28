import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isliking;
  final Duration duration;
  final VoidCallback onEnd;
  final bool like;

  const LikeAnimation({
    Key key,
    @required this.isliking,
    this.duration = const Duration(milliseconds: 150),
    @required this.child,
    this.onEnd,
    this.like = false,
  }) : super(key: key);
  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isliking != oldWidget.isliking) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isliking || widget.like) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(
        const Duration(
          milliseconds: 200,
        ),
      );
      if (widget.onEnd != null) {
        widget.onEnd();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
