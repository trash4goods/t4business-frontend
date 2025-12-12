// core/widgets/gradient_background.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Color? startColor;
  final Color? endColor;

  const GradientBackground({
    super.key,
    required this.child,
    this.startColor,
    this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            startColor ?? AppColors.backgroundGradientStart,
            endColor ?? AppColors.backgroundGradientEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}
