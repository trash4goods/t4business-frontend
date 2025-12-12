import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/custom_colors.dart';

enum CustomStyleMessage { danger, success, info, warning }

class SnackbarMethods {
  static Color? color(CustomStyleMessage style) {
    switch (style) {
      case CustomStyleMessage.danger:
        return CustomColors.snackBarDangerBackgroundColor;
      case CustomStyleMessage.success:
        return CustomColors.snackBarSuccessBackgroundColor;
      case CustomStyleMessage.info:
        return CustomColors.snackBarInfoBackgroundColor;
      case CustomStyleMessage.warning:
        return CustomColors.snackBarWarningBackgroundColor;
    }
  }

  static IconData? showIcon(CustomStyleMessage style) {
    switch (style) {
      case CustomStyleMessage.danger:
        return Icons.dangerous;
      case CustomStyleMessage.success:
        return Icons.check_circle;
      case CustomStyleMessage.info:
        return Icons.info;
      case CustomStyleMessage.warning:
        return Icons.warning;
    }
  }

  static Future<void> vibrate(CustomStyleMessage style) {
    switch (style) {
      case CustomStyleMessage.danger:
        return HapticFeedback.heavyImpact();
      case CustomStyleMessage.success:
        return HapticFeedback.lightImpact();
      case CustomStyleMessage.info:
        return HapticFeedback.lightImpact();
      case CustomStyleMessage.warning:
        return HapticFeedback.mediumImpact();
    }
  }
}
