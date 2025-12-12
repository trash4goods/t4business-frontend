import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/user_profile/profile/presentation/views/profile.dart';
import 'page_header.dart';

class ProfileContent extends StatelessWidget {
  final BoxConstraints constraints;
  const ProfileContent({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          constraints: constraints,
          title: 'Profile Settings',
          subtitle: 'Manage your account and business information',
          icon: Icons.person_outline,
        ),
        const Expanded(child: ProfileView()),
      ],
    );
  }
}
