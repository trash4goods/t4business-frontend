import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/compact_action_button.dart';
import '../../../../core/widgets/compact_formfield.dart';
import '../../../../core/widgets/compact_profile_card.dart';
import '../../../../features/product_managment/presentation/components/image_upload_component.dart';
import '../../../product_managment/presentation/components/form_field_component.dart';
import '../controllers/interface/profile.dart';
import '../presenters/interface/profile.dart';

class ProfileView
    extends
        CustomGetView<ProfileControllerInterface, ProfilePresenterInterface> {
  const ProfileView({super.key});

  @override
  Widget buildView(BuildContext context) {
    // Load profile when view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessController.loadProfile();
    });

    // Check if we're being rendered within a dashboard layout
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;
        final isTablet =
            constraints.maxWidth > AppConstants.mobileBreakpoint &&
            constraints.maxWidth <= AppConstants.tabletBreakpoint;

        return RefreshIndicator(
          onRefresh: () async => businessController.loadProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(context, isDesktop, isTablet),
                    const SizedBox(height: 32),
                    _buildLogosSection(context, isDesktop, isTablet),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (hasScaffoldAncestor) {
      // We're inside a dashboard, don't create our own Scaffold
      return content;
    } else {
      // We're a standalone page, create our own Scaffold
      return Scaffold(
        backgroundColor: AppColors.surfaceElevated,
        body: content,
      );
    }
  }

  // Replace the existing profile view methods with these optimized versions
  Widget _buildProfileSection(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact profile card
          Obx(
            () => CompactProfileCard(
              imageUrl: presenter.profilePictureUrl,
              mainLogoUrl: presenter.mainLogoUrl,
              name: presenter.userName,
              email: presenter.userEmail,
              onImageTap: businessController.uploadProfilePicture,
              isLoading: presenter.isLoading,
            ),
          ),
          const SizedBox(height: 20),
          // Compact form fields
          CompactFormField(
            label: 'Email Address',
            value: presenter.userEmail,
            prefixIcon: Icons.email_outlined,
            readOnly: true,
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.mutedForeground.withOpacity(0.1),
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
              value: presenter.userName,
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              onChanged: businessController.updateName,
              required: true,
            ),
          ),
          const SizedBox(height: 20),
          // Compact save button
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

  Widget _buildLogosSection(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: _buildFormField(
        label: 'Company Logos',
        child: _buildLogosUpload(),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool required = false,
    String? helpText,
  }) {
    return FormFieldComponent(
      label: label,
      required: required,
      helpText: helpText,
      child: child,
    );
  }

  Widget _buildLogosUpload() {
    return Obx(() {
      final mainLogo =
          presenter.mainLogoUrl; // Explicitly access the reactive value
      final logos = presenter.logoUrls; // Explicitly access the reactive list

      return Column(
        children: [
          if (logos.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: logos.length,
                itemBuilder: (context, index) {
                  final logoUrl = logos[index];
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 8),
                    child: ImageUploadComponent(
                      imageUrl: logoUrl,
                      onUpload: () {}, // No upload on existing image
                      onRemove: () {
                        businessController.deleteLogo(logoUrl);
                      },
                      title: '',
                      subtitle: '',
                      compact: true,
                      onSetAsLogo: () {
                        businessController.setMainLogo(logoUrl);
                      },
                      isLogo: logoUrl == mainLogo,
                      width: 100,
                      height: 100,
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 8),
          if (logos.length < 5) // Allow up to 5 logos
            ImageUploadComponent(
              onUpload: () => businessController.uploadLogo(),
              title: 'Add Company Logo',
              subtitle:
                  logos.isEmpty
                      ? 'Add up to 5 company logos'
                      : 'Add ${5 - logos.length} more logo(s)',
              compact: true,
            ),
        ],
      );
    });
  }
}
