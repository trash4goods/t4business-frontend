import 'package:flutter/material.dart';

class AnimatedContentWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double translateOffset;
  final bool enableTranslation;
  final bool enableOpacity;

  const AnimatedContentWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.translateOffset = 30.0,
    this.enableTranslation = true,
    this.enableOpacity = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: enableOpacity ? value : 1.0,
          child: Transform.translate(
            offset: enableTranslation 
                ? Offset(0, translateOffset * (1 - value))
                : Offset.zero,
            child: this.child,
          ),
        );
      },
    );
  }
}