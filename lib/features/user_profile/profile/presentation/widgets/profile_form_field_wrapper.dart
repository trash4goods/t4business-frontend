import 'package:flutter/material.dart';
import '../../../../product_managment/presentation/components/form_field_component.dart';

class ProfileFormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final bool requiredField;
  final String? helpText;

  const ProfileFormFieldWrapper({
    super.key,
    required this.label,
    required this.child,
    this.requiredField = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    // Keep identical structure by reusing the existing FormFieldComponent
    return FormFieldComponent(
      label: label,
      required: requiredField,
      helpText: helpText,
      child: child,
    );
  }
}
