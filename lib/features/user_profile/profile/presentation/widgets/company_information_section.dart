import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/compact_formfield.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class CompanyInformationSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const CompanyInformationSection({
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
                Icons.business_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Company Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => CompactFormField(
                    label: 'Company Name',
                    value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.name ?? 'Not available',
                    hintText: 'Company name not set',
                    prefixIcon: Icons.domain_outlined,
                    readOnly: true,
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 16),
              if (isDesktop)
                Expanded(
                  child: Obx(
                    () => CompactFormField(
                      label: 'Department Type',
                      value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.departmentType?.toUpperCase() ?? 'UNKNOWN',
                      prefixIcon: Icons.category_outlined,
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
                label: 'Department Type',
                value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.departmentType?.toUpperCase() ?? 'UNKNOWN',
                prefixIcon: Icons.category_outlined,
                readOnly: true,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => CompactFormField(
                    label: 'Company Domain',
                    value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.domain ?? 'Not available',
                    prefixIcon: Icons.language_outlined,
                    readOnly: true,
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 16),
              if (isDesktop)
                Expanded(
                  child: Obx(
                    () => CompactFormField(
                      label: 'Status',
                      value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status?.toUpperCase() ?? 'UNKNOWN',
                      prefixIcon: Icons.info_outline,
                      readOnly: true,
                      suffix: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status?.toUpperCase() ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (!isDesktop) const SizedBox(height: 16),
          if (!isDesktop)
            Obx(
              () => CompactFormField(
                label: 'Status',
                value: presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status?.toUpperCase() ?? '',
                prefixIcon: Icons.info_outline,
                readOnly: true,
                suffix: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status?.toUpperCase() ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.status),
                    ),
                  ),
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
      case 'waiting':
        return AppColors.warning;
      case 'inactive':
        return AppColors.destructive;
      default:
        return AppColors.mutedForeground;
    }
  }
}