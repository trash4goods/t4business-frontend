import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/compact_formfield.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class ContactDetailsSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const ContactDetailsSection({
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
          Row(
            children: [
              Icon(
                Icons.contact_phone_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isDesktop || isTablet)
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CompactFormField(
                      label: 'First Name',
                      value: presenter.userAuth?.profile?.firstName ?? '',
                      hintText: presenter.userAuth?.profile?.firstName == null ? 'Not available' : 'Enter first name',
                      prefixIcon: Icons.person_outline,
                      onChanged: businessController.updateFirstName,
                      readOnly: presenter.userAuth?.profile?.firstName == null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => CompactFormField(
                      label: 'Last Name',
                      value: presenter.userAuth?.profile?.lastName ?? '',
                      hintText: presenter.userAuth?.profile?.lastName == null ? 'Not available' : 'Enter last name',
                      prefixIcon: Icons.person_outline,
                      onChanged: businessController.updateLastName,
                      readOnly: presenter.userAuth?.profile?.lastName == null,
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Obx(
              () => CompactFormField(
                label: 'First Name',
                value: presenter.userAuth?.profile?.firstName ?? '',
                hintText: presenter.userAuth?.profile?.firstName == null ? 'Not available' : 'Enter first name',
                prefixIcon: Icons.person_outline,
                onChanged: businessController.updateFirstName,
                readOnly: presenter.userAuth?.profile?.firstName == null,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CompactFormField(
                label: 'Last Name',
                value: presenter.userAuth?.profile?.lastName ?? '',
                hintText: presenter.userAuth?.profile?.lastName == null ? 'Not available' : 'Enter last name',
                prefixIcon: Icons.person_outline,
                onChanged: businessController.updateLastName,
                readOnly: presenter.userAuth?.profile?.lastName == null,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Obx(
            () => CompactFormField(
              label: 'Phone Number',
              value: presenter.userAuth?.profile?.phoneIndicative != null && presenter.userAuth?.profile?.phoneNumber != null
                  ? '${presenter.userAuth?.profile?.phoneIndicative} ${presenter.userAuth?.profile?.phoneNumber}'
                  : (presenter.userAuth?.profile?.phoneNumber ?? ''),
              hintText: presenter.userAuth?.profile?.phoneNumber == null ? 'Not available' : 'Enter phone number',
              prefixIcon: Icons.phone_outlined,
              onChanged: businessController.updatePhoneNumber,
              readOnly: presenter.userAuth?.profile?.phoneNumber == null,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => CompactFormField(
                    label: 'Account Status',
                    value: presenter.userAuth?.profile?.status?.toUpperCase() ?? 'UNKNOWN',
                    prefixIcon: Icons.shield_outlined,
                    readOnly: true,
                    suffix: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(presenter.userAuth?.profile?.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        presenter.userAuth?.profile?.status?.toUpperCase() ?? 'UNKNOWN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(presenter.userAuth?.profile?.status),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 16),
              if (isDesktop)
                Expanded(
                  child: Obx(
                    () => CompactFormField(
                      label: 'Member Since',
                      value: '${ presenter.userAuth?.profile?.insertedAt != null ? DateTime.parse(presenter.userAuth?.profile?.insertedAt ?? '').year : 'unknown'}',
                      prefixIcon: Icons.calendar_today_outlined,
                      readOnly: true,
                    ),
                  ),
                ),
            ],
          ),
          if (!isDesktop) const SizedBox(height: 16),
          if (!isDesktop)
            Obx(
              () => CompactFormField(
                label: 'Member Since',
                value: '${ presenter.userAuth?.profile?.insertedAt != null ? DateTime.parse(presenter.userAuth?.profile?.insertedAt ?? '').year : 'unknown'}',
                prefixIcon: Icons.calendar_today_outlined,
                readOnly: true,
              ),
            ),
          if (presenter.userAuth?.profile?.isAdmin == true) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Administrator Account',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
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