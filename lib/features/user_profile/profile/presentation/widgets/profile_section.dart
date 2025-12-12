import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/compact_action_button.dart';
import '../../../../../core/widgets/compact_formfield.dart';
import '../../../../../core/widgets/compact_profile_card.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class ProfileSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const ProfileSection({
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
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CompactProfileCard(
              imageUrl: presenter.profilePictureUrl,
              mainLogoUrl: presenter.mainLogoUrl,
              name: presenter.userAuth?.profile?.name ?? 'unknown',
              email: presenter.userAuth?.profile?.email ?? 'unknown',
              onImageTap: businessController.uploadProfilePicture,
              isLoading: presenter.isLoading,
            ),
          ),
          const SizedBox(height: 20),
          CompactFormField(
            label: 'Email Address',
            value: presenter.userAuth?.profile?.email ?? 'unknown',
            prefixIcon: Icons.email_outlined,
            readOnly: true,
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.mutedForeground.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Read-only',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => CompactFormField(
              label: 'Full Name',
              value: presenter.userAuth?.profile?.name ?? 'unknown',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              onChanged: businessController.updateName,
              required: true,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Obx(
                () => CompactActionButton(
                  text: presenter.isLoading ? 'Saving...' : 'Save Changes',
                  icon: Icons.save_outlined,
                  onPressed: businessController.saveProfile,
                  isLoading: presenter.isLoading,
                  variant: CompactButtonVariant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
