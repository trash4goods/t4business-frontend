// filepath: /Users/marcelocesar/Desktop/t4g_dashboard/lib/src/utils/snackbar_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app/themes/app_colors.dart';

enum SnackbarType { success, error, info, warning }

/// A service for showing snackbars consistently throughout the app
/// with shadcn UI-inspired styling
///
/// Features:
/// - Modern design with refined styling and rounded borders
/// - Color-coded indicators for different message types
/// - Action button support for interactive snackbars
/// - Customizable duration and position
/// - Consistent typography and spacing
/// - Click/tap handling for the entire snackbar
/// - Animations for smooth entrance and exit
///
/// Usage examples:
/// ```dart
/// // Basic usage
/// SnackbarService.showSuccess('Operation completed successfully');
///
/// // With action button
/// SnackbarService.showError(
///   'Connection failed',
///   actionLabel: 'Retry',
///   onActionPressed: () => reconnect(),
/// );
/// ```
class SnackbarServiceHelper {
  SnackbarServiceHelper._(); // Private constructor to prevent instantiation

  /// Shows a snackbar with the given message and type
  static void show({
    required String message,
    required SnackbarType type,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    Function? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    // Close any existing snackbars to prevent stacking
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Color backgroundColor;
    Color iconBackgroundColor;
    Color textColor;
    Color borderColor;
    IconData? icon;

    // Set properties based on the snackbar type
    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.backgroundColorSecondary;
        iconBackgroundColor = AppColors.snackBarSuccessBackgroundColor
            .withValues(alpha: 0.15);
        borderColor = AppColors.snackBarSuccessBackgroundColor;
        textColor = AppColors.backgroundColor;
        icon = Icons.check_circle_rounded;
        title = title ?? 'Success';
        break;
      case SnackbarType.error:
        backgroundColor = AppColors.backgroundColorSecondary;
        iconBackgroundColor = AppColors.snackBarDangerBackgroundColor
            .withValues(alpha: 0.15);
        borderColor = AppColors.snackBarDangerBackgroundColor;
        textColor = AppColors.backgroundColor;
        icon = Icons.error_rounded;
        title = title ?? 'Error';
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.backgroundColorSecondary;
        iconBackgroundColor = AppColors.snackBarInfoBackgroundColor.withValues(
          alpha: 0.15,
        );
        borderColor = AppColors.snackBarInfoBackgroundColor;
        textColor = AppColors.backgroundColor;
        icon = Icons.info_rounded;
        title = title ?? 'Information';
        break;
      case SnackbarType.warning:
        backgroundColor = AppColors.backgroundColorSecondary;
        iconBackgroundColor = AppColors.snackBarWarningBackgroundColor
            .withValues(alpha: 0.15);
        borderColor = AppColors.snackBarWarningBackgroundColor;
        textColor = AppColors.backgroundColor;
        icon = Icons.warning_rounded;
        title = title ?? 'Warning';
        break;
    }

    // Get the snackbar color based on the type
    Color getIconColor() {
      switch (type) {
        case SnackbarType.success:
          return AppColors.snackBarSuccessBackgroundColor;
        case SnackbarType.error:
          return AppColors.snackBarDangerBackgroundColor;
        case SnackbarType.info:
          return AppColors.snackBarInfoBackgroundColor;
        case SnackbarType.warning:
          return AppColors.snackBarWarningBackgroundColor;
      }
    }

    // Create message widget that may include an action button
    Widget messageWidget;
    if (actionLabel != null && onActionPressed != null) {
      messageWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onActionPressed,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return getIconColor().withValues(alpha: 0.2);
                }
                return getIconColor().withValues(alpha: 0.08);
              }),
              overlayColor: WidgetStateProperty.all(
                getIconColor().withValues(alpha: 0.12),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              minimumSize: WidgetStateProperty.all(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: TextStyle(
                color: getIconColor(),
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      );
    } else {
      messageWidget = Text(
        message,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.85),
          fontSize: 13,
          height: 1.4,
        ),
      );
    }

    // Show the snackbar with shadcn UI card styling
    Get.snackbar(
      '',
      '',
      titleText: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: textColor,
            letterSpacing: -0.3,
          ),
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
        child: messageWidget,
      ),
      backgroundColor: backgroundColor,
      borderRadius: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(0),
      duration: duration,
      snackPosition: position,
      barBlur: 0,
      isDismissible: true,
      maxWidth: 500, // Limit width for better readability on larger devices
      animationDuration: const Duration(milliseconds: 200),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      dismissDirection: DismissDirection.horizontal,
      onTap: onTap == null ? null : (_) => onTap(),
      borderWidth: 1,
      borderColor: borderColor.withValues(alpha: 0.2),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: -2,
        ),
      ],
      icon: Container(
        margin: const EdgeInsets.only(left: 16, right: 10),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: getIconColor(), size: 22),
      ),
      shouldIconPulse: false,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          visualDensity: VisualDensity.compact,
        ),
        child: Icon(
          Icons.close,
          size: 18,
          color: textColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  /// Shows a success snackbar
  static void showSuccess(
    String message, {
    String? title,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    Function? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: SnackbarType.success,
      title: title,
      duration: duration ?? const Duration(seconds: 2),
      position: position,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Shows an error snackbar
  static void showError(
    String message, {
    String? title,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    Function? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: SnackbarType.error,
      title: title,
      duration: duration ?? const Duration(seconds: 2),
      position: position,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Shows an info snackbar
  static void showInfo(
    String message, {
    String? title,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    Function? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: SnackbarType.info,
      title: title,
      duration: duration ?? const Duration(seconds: 2),
      position: position,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Shows a warning snackbar
  static void showWarning(
    String message, {
    String? title,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
    Function? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: SnackbarType.warning,
      title: title,
      duration: duration ?? const Duration(seconds: 2),
      position: position,
      onTap: onTap,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
