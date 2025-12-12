import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile_change_password/domain/entities/settings_category.dart';
import '../profile_change_password/domain/entities/settings_item.dart';
import '../profile/presentation/presenters/interface/profile.dart';

class ProfileSettingsUtils {
  static List<SettingsCategoryModel> getCategories() {
    return [
      SettingsCategoryModel(
        id: 'general',
        title: 'General',
        items: [
          SettingsItemModel(
            id: 'change_password',
            title: 'Change Password',
            subtitle: 'Update your account password',
            icon: Icons.lock_outline,
          ),
          SettingsItemModel(
            id: 'delete_user',
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            icon: Icons.delete,
          ),
        ],
      ),
      if (_hasTeamManagementPermission())
        SettingsCategoryModel(
          id: 'department',
          title: 'Department',
          items: [
            SettingsItemModel(
              id: 'manage_team',
              title: 'Manage Team',
              subtitle: 'Add, edit, and remove team members',
              icon: Icons.group,
            ),
            /*
            SettingsItemModel(
              id: 'transfer_ownership',
              title: 'Transfer Ownership',
              subtitle: 'Transfer department ownership to another user',
              icon: Icons.swap_horiz,
            ),
            SettingsItemModel(
              id: 'leave_department',
              title: 'Leave Department',
              subtitle: 'Leave this department',
              icon: Icons.exit_to_app,
              isDestructive: true,
            ),
            SettingsItemModel(
              id: 'answer_invite',
              title: 'Answer Invite',
              subtitle: 'Respond to department invitations',
              icon: Icons.mail,
            ),
            */
          ],
        ),
    ];
  }

  /// Checks if the current user has team management permissions
  ///
  /// Returns true if the user is an admin or has appropriate role permissions
  static bool _hasTeamManagementPermission() {
    try {
      // Try to get the profile presenter to access user auth data
      final profilePresenter = Get.find<ProfilePresenterInterface>();
      final userAuth = profilePresenter.userAuth;

      // Check if user is admin
      if (userAuth?.profile?.isAdmin == true) {
        return true;
      }

      // Check if user has admin role in their department
      final roles = userAuth?.profile?.fullRoles ?? [];
      final hasAdminRole = roles.any(
        (role) =>
            role.name?.toLowerCase() == 'admin' ||
            role.name?.toLowerCase() == 'owner',
      );

      if (hasAdminRole) {
        return true;
      }

      // For now, allow access if user has any department association
      // This can be made more restrictive based on business requirements
      final hasDepartment =
          userAuth?.profile?.userPartnersDepartments?.isNotEmpty == true;
      return hasDepartment;
    } catch (e) {
      // If we can't determine permissions, default to false for security
      return false;
    }
  }
}
