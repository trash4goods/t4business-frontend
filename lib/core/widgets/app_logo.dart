// core/widgets/app_logo.dart
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final bool showBusinessText;
  final Color? textColor;
  final TextStyle? textStyle;

  const AppLogo({
    super.key,
    this.width = 60,
    this.height = 60,
    this.showBusinessText = false,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (showBusinessText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/logo/logo_t4g.png', width: width, height: height),
        ],
      );
    }

    return Image.asset(
      'assets/logo/logo_t4g.png',
      width: width,
      height: height,
    );
  }
}
