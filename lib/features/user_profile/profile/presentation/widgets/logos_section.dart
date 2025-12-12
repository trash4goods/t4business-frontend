import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';
import 'profile_form_field_wrapper.dart';
import '../controllers/interface/profile.dart';
import '../presenters/interface/profile.dart';
import 'logos_upload_widget.dart';

class LogosSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const LogosSection({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: ProfileFormFieldWrapper(
        label: 'Company Logos',
        child: LogosUploadWidget(
          businessController: businessController,
          presenter: presenter,
        ),
      ),
    );
  }
}
