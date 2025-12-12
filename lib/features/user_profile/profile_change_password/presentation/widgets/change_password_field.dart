import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../utils/profile_change_settings_utils.dart';

class ChangePasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool showStrengthIndicator;
  final bool isVisible;
  final void Function() onToggleVisibility;
  final void Function(String) onChanged;
  final String error;
  final double passwordStrength;
  const ChangePasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    required this.showStrengthIndicator,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.onChanged,
    required this.error,
    required this.passwordStrength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.small.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: !isVisible,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: theme.textTheme.muted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFF0F172A)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ShadButton.ghost(
              onPressed: onToggleVisibility,
              size: ShadButtonSize.sm,
              child: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                size: 16,
              ),
            ),
          ],
        ),

        // Password Strength Indicator (only for new password field)
        if (showStrengthIndicator) ...{
          if (controller.text.isNotEmpty) ...{
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: Colors.grey[300],
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: passwordStrength,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: ProfileChangeSettingsUtils.getStrengthColor(
                                  passwordStrength,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ProfileChangeSettingsUtils.getStrengthText(passwordStrength),
                        style: theme.textTheme.small.copyWith(
                          color: ProfileChangeSettingsUtils.getStrengthColor(passwordStrength),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ProfileChangeSettingsUtils.getPasswordRequirements(controller.text),
                    style: theme.textTheme.muted.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          },
        } else ...{
          const SizedBox.shrink(),
        },

        // Error text
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            error,
            style: theme.textTheme.small.copyWith(color: const Color(0xFFDC2626)),
          ),
        ),
      ],
    );
  }
}
