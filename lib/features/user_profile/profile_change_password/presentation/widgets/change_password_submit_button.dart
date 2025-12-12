import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  final VoidCallback handleSubmit;
  final bool isLoading;
  final bool isFormValid;
  const ChangePasswordSubmitButton({
    super.key,
    required this.handleSubmit,
    required this.isLoading,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ShadButton(
        enabled: isFormValid && !isLoading,
        onPressed: isFormValid && !isLoading ? handleSubmit : null,
        child:
            isLoading
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Updating...'),
                  ],
                )
                : const Text('Update Password'),
      ),
    );
  }
}
