import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/snackbar_background.dart';

class CSSnackBar {
  static void showMessage({
    required CustomStyleMessage style,
    required String? text,
  }) {
    // HapticFeedback.heavyImpact();
    SnackbarMethods.vibrate(style);

    // Create animation controller
    final controller = GetInstance().put(
      AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: navigator!.overlay! as TickerProvider,
      ),
      tag: 'snackbar_controller',
    );

    // Create animation
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceIn,
    );

    Get.showSnackbar(
      GetSnackBar(
        overlayColor: Colors.black.withValues(alpha: 0.2),
        overlayBlur: 2,
        onTap: (e) {
          Get.delete<AnimationController>(tag: 'snackbar_controller');
          Get.closeCurrentSnackbar();
        },
        // Using current custom animation
        animationDuration: const Duration(milliseconds: 500),
        duration: null,
        backgroundColor: SnackbarMethods.color(style) ?? Colors.transparent,
        borderRadius: 20,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        dismissDirection: DismissDirection.none,
        // Custom animation for the snackbar
        forwardAnimationCurve: animation.curve,
        reverseAnimationCurve: animation.curve,
        messageText: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.scale(
                scale: animation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Icon(
                          SnackbarMethods.showIcon(style) ?? Icons.info,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Text(
                          text ?? 'no-text',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    // Start the animation
    controller.forward();
  }
}
