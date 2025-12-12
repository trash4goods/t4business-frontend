// filepath: /Users/marcelocesar/Desktop/t4g_dashboard/lib/src/components/custom_button.dart
import 'package:flutter/material.dart';

import '../app/themes/app_colors.dart';

/// Button type options for CustomButton
enum CustomButtonType { primary, secondary, text }

/// A reusable custom button component with consistent styling
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when the button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// The type of button to display (primary, secondary, text)
  final CustomButtonType buttonType;

  /// Optional icon to display alongside the text
  final IconData? icon;

  /// Constructor for the custom button
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.buttonType = CustomButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case CustomButtonType.primary:
        return _buildPrimaryButton();
      case CustomButtonType.secondary:
        return _buildSecondaryButton();
      case CustomButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.backgroundColor,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color:
              isLoading
                  ? AppColors.primaryLight.withValues(alpha: 0.5)
                  : AppColors.primaryLight,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(isTextButton: true),
    );
  }

  Widget _buildButtonContent({bool isTextButton = false}) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTextButton ? FontWeight.w500 : FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: isTextButton ? FontWeight.w500 : FontWeight.bold,
      ),
    );
  }
}
