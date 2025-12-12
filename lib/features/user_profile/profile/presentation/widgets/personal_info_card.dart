import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_auth_model.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../controllers/interface/profile.dart';

class PersonalInfoCard extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final UserAuthModel? userAuth;
  final bool isDesktop;
  final bool isTablet;
  final TextEditingController fullnameController;
  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController phoneController;

  const PersonalInfoCard({
    super.key,
    required this.businessController,
    required this.userAuth,
    required this.isDesktop,
    required this.isTablet,
    required this.fullnameController,
    required this.firstnameController,
    required this.lastnameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    log('## personal info card: ${userAuth?.profile?.toJson()}');
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
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: ShadTheme.of(context).textTheme.h4,
                        ),
                        Text(
                          'Your personal details and contact information',
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
          
              // Personal Information Form
              Column(
                children: [
                  // Full Name Field
                  ShadInputFormField(
                    label: const Text('Full Name'),
                    controller: fullnameController,
                    placeholder: Text(userAuth?.profile?.name ?? 'Enter your full name'),
                    onChanged: businessController.updateName,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Name Fields Row (if data is available)
                  if (isDesktop || isTablet)
                    Row(
                      children: [
                        Expanded(
                          child: ShadInputFormField(
                            label: const Text('First Name'),
                            onChanged: businessController.updateFirstName,
                            placeholder: Text(userAuth?.profile?.firstName ?? 'Enter first name'),
                            enabled: userAuth?.profile?.firstName != null,
                            controller: firstnameController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ShadInputFormField(
                            label: const Text('Last Name'),
                            onChanged: businessController.updateLastName,
                            placeholder: Text(userAuth?.profile?.lastName ?? 'Enter last name'),
                            enabled: userAuth?.profile?.lastName != null,
                            controller: lastnameController,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ShadInputFormField(
                          label: const Text('First Name'),
                          onChanged: businessController.updateFirstName,
                          placeholder: Text(userAuth?.profile?.firstName ?? 'Enter first name'),
                          enabled: userAuth?.profile?.firstName != null,
                          controller: firstnameController,
                        ),
                        const SizedBox(height: 16),
                        ShadInputFormField(
                          label: const Text('Last Name'),
                          onChanged: businessController.updateLastName,
                          placeholder: Text(userAuth?.profile?.lastName ?? 'Enter last name'),
                          enabled: userAuth?.profile?.lastName != null,
                          controller: lastnameController,
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Phone Number
                  ShadInputFormField(
                    label: const Text('Phone Number'),
                    onChanged: businessController.updatePhoneNumber,
                    placeholder: Text(userAuth?.profile?.phoneNumber ?? 'Enter phone number'),
                    controller: phoneController,
                  ),
                  
                  const SizedBox(height: 24),
                  Container(
                    height: 1,
                    color: ShadTheme.of(context).colorScheme.border,
                  ),
                  const SizedBox(height: 16),
                  
                  // Additional Info
                  _buildInfoGrid(context),
                ],
              ),
            ],
        
      )),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: ShadTheme.of(context).textTheme.small.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        if (isDesktop || isTablet)
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Account Status',
                  userAuth?.profile?.status?.toUpperCase() ?? 'unknown',
                  Icons.shield_outlined,
                  badge: _buildStatusBadge(context, userAuth?.profile?.status),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Member Since',
                  '${userAuth?.profile?.insertedAt != null ? (DateTime.parse(userAuth?.profile?.insertedAt ?? '').year) : 'unknown'}',
                  Icons.calendar_today_outlined,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildInfoItem(
                context,
                'Account Status',
                userAuth?.profile?.status?.toUpperCase() ?? 'unknown',
                Icons.shield_outlined,
                badge: _buildStatusBadge(context, userAuth?.profile?.status),
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                'Member Since',
                '${userAuth?.profile?.insertedAt != null ? (DateTime.parse(userAuth?.profile?.insertedAt ?? '').year) : 'unknown'}',
                Icons.calendar_today_outlined,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Widget? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
      ),
      child: Column(
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
      ),
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
            status?.toUpperCase() ?? 'unknown',
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
      case 'pending':
        return AppColors.warning;
      case 'inactive':
        return AppColors.destructive;
      default:
        return AppColors.mutedForeground;
    }
  }
}