import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/core/services/navigation.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const ProfileHeaderCard({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop || isTablet)
              Row(
                children: [
                  _buildAvatarSection(context),
                  const SizedBox(width: 24),
                  Expanded(child: _buildInfoSection(context)),
                  Column(
                    children: [
                      _buildActionSection(context),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        width: 140,
                        child: ShadButton.outline(
                          onPressed: () => NavigationService.to(AppRoutes.profileSettings),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.settings_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Settings'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildAvatarSection(context),
                  const SizedBox(height: 16),
                  _buildInfoSection(context),
                  const SizedBox(height: 16),
                  _buildActionSection(context),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    width: 140,
                    child: ShadButton.outline(
                      onPressed: () => NavigationService.to(AppRoutes.profileSettings),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: businessController.uploadProfilePicture,
        child: Container(
          width: isDesktop ? 96 : 80,
          height: isDesktop ? 96 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ShadTheme.of(context).colorScheme.border,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipOval(
                child:
                    presenter.profilePictureUrl != null
                        ? Image.network(
                          presenter.profilePictureUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildDefaultAvatar(context),
                        )
                        : _buildDefaultAvatar(context),
              ),
              // Camera overlay
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ShadTheme.of(context).colorScheme.background,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              if (presenter.isLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ShadTheme.of(
                      context,
                    ).colorScheme.background.withValues(alpha: 0.8),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: isDesktop ? 40 : 32,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name with admin badge
          Row(
            children: [
              Flexible(
                child: Text(
                  presenter.userAuth?.profile?.name ?? 'User',
                  style: ShadTheme.of(context).textTheme.h3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (presenter.userAuth?.profile?.isUserAdmin ?? false) ...[
                const SizedBox(width: 8),
                ShadBadge.secondary(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      const Text('Admin'),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Email
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 16,
                color: ShadTheme.of(context).colorScheme.mutedForeground,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  presenter.userAuth?.profile?.email ?? 'no email',
                  style: ShadTheme.of(context).textTheme.muted,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (presenter.userAuth?.profile?.insertedAt != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: ShadTheme.of(context).colorScheme.mutedForeground,
                ),
                const SizedBox(width: 6),
                Text(
                  'Member since ${DateTime.parse(presenter.userAuth?.profile?.insertedAt ?? '').year}',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          // Status badge
          ShadBadge(
            backgroundColor: _getStatusColor(
              presenter.userAuth?.profile?.status,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  presenter.userAuth?.profile?.status ?? 'UNKNOWN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 140,
            child: ShadButton(
              onPressed:
                  presenter.isLoading ? null : businessController.saveProfile,
              child:
                  presenter.isLoading
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Saving...'),
                        ],
                      )
                      : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Save Changes', style: TextStyle(fontSize: 12),),
                        ],
                      ),
            ),
          ),
          if (!isDesktop && !isTablet) const SizedBox(height: 8),
          if (!isDesktop && !isTablet)
            SizedBox(
              height: 40,
              child: ShadButton.outline(
                onPressed: businessController.uploadProfilePicture,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Update Photo'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'inactive':
        return AppColors.destructive;
      default:
        return AppColors.mutedForeground;
    }
  }
}
