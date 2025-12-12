import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../controller/department_management_controller.interface.dart';
import '../presenter/department_management_presenter.interface.dart';

class TeamManagementHeader extends StatelessWidget {
  const TeamManagementHeader({
    super.key,
    required this.presenter,
    required this.controller,
    required this.isMobile,
  });

  final DepartmentManagementPresenterInterface presenter;
  final DepartmentManagementControllerInterface controller;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and description section
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '${presenter.filteredMembers.length} Team Members',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (!isMobile)
                    const Text(
                      'Manage your team members and their access',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                ],
              ),
            ),

            // Add Member button (desktop only)
            if (!isMobile)
              ShadButton(
                onPressed: controller.showAddMemberDialogUI,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 8),
                    Text('Add Member'),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Search bar
        ShadInput(
          placeholder: const Text('Search team members...'),
          leading: const Icon(Icons.search, size: 16, color: Color(0xFF64748B)),
          onChanged: controller.onSearchChanged,
        ),

        // Mobile add member button
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ShadButton(
              onPressed: controller.showAddMemberDialogUI,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text('Add Member'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
