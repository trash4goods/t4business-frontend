import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color? lineColor;
  final Color? textColor;
  final double fontSize;
  final double horizontalPadding;

  const DividerWithText({
    super.key,
    required this.text,
    this.lineColor,
    this.textColor,
    this.fontSize = 14,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: lineColor ?? AppColors.lightBorder,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.lightTextSecondary,
              fontSize: fontSize,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: lineColor ?? AppColors.lightBorder,
          ),
        ),
      ],
    );
  }
}