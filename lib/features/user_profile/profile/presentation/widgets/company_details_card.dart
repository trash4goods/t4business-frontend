import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_profile_model.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../controllers/interface/profile.dart';

class CompanyDetailsCard extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final UserAuthModel? userAuth;
  final bool isDesktop;
  final bool isTablet;

  const CompanyDetailsCard({
    super.key,
    required this.businessController,
    required this.userAuth,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Information',
                        style: ShadTheme.of(context).textTheme.h4,
                      ),
                      Text(
                        'Business details and organization info',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Container(
              height: 1,
              color: ShadTheme.of(context).colorScheme.border,
            ),
            const SizedBox(height: 24),

            // Company Details Grid
            Column(
              children: [
                _buildDetailRow(
                  context,
                  'Company Name',
                  userAuth?.profile?.userPartnersDepartments?.first.department?.name ?? 'Not available',
                  Icons.domain_outlined,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        context,
                        'Department',
                        userAuth?.profile?.userPartnersDepartments?.first.department?.departmentType ?? 'UNKNOWN',
                        Icons.category_outlined,
                      ),
                    ),
                    if (isDesktop || isTablet) ...[
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildDetailRow(
                          context,
                          'Status',
                          userAuth?.profile?.userPartnersDepartments?.first.department?.status ?? 'UNKNOWN',
                          Icons.info_outline,
                          badge: _buildStatusBadge(context, userAuth?.profile?.userPartnersDepartments?.first.department?.status),
                        ),
                      ),
                    ],
                  ],
                ),
                
                if (!isDesktop && !isTablet) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    'Status',
                    userAuth?.profile?.userPartnersDepartments?.first.department?.status ?? 'UNKNOWN',
                    Icons.info_outline,
                    badge: _buildStatusBadge(context, userAuth?.profile?.userPartnersDepartments?.first.department?.status),
                  ),
                ],
                
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  'Domain',
                  userAuth?.profile?.userPartnersDepartments?.first.department?.domain ?? 'Not available',
                  Icons.language_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Widget? badge,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: ShadTheme.of(context).textTheme.small.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: ShadTheme.of(context).textTheme.p,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              badge,
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    final color = _getStatusColor(status);
    return ShadBadge(
      backgroundColor: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status?.toUpperCase() ?? 'UNKNOWN',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
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