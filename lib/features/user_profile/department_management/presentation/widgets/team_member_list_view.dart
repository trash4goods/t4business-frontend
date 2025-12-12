import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/models/manage_team.dart';
import '../controller/department_management_controller.interface.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_card.dart';

class TeamMemberListView extends StatelessWidget {
  const TeamMemberListView({
    super.key,
    required this.presenter,
    required this.controller,
    required this.isMobile,
    required this.onEditMember,
  });

  final DepartmentManagementPresenterInterface presenter;
  final DepartmentManagementControllerInterface controller;
  final bool isMobile;
  final void Function(ManageTeamModel member) onEditMember;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isMobile) {
        // Mobile: Card-based layout
        return ListView.separated(
          itemCount: presenter.filteredMembers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final member = presenter.filteredMembers[index];
            return TeamMemberCard(
              member: member,
              onEdit: () => onEditMember(member),
              onTransfer:
                  () => controller.showTransferConfirmation(
                    member,
                    (presenter.user?.profile?.roles?.first ?? '') == 't4b'
                        ? 'owner'
                        : (presenter.user?.profile?.roles?.first ?? ''),
                  ),
              onDelete: () => controller.showDeleteConfirmation(member),
            );
          },
        );
      } else {
        // Desktop/Tablet: Table layout
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Role',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Table rows
              Expanded(
                child: ListView.separated(
                  itemCount: presenter.filteredMembers.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  itemBuilder: (context, index) {
                    final member = presenter.filteredMembers[index];
                    return _TableRow(
                      member: member,
                      onEdit: () => onEditMember(member),
                      onTransfer:
                          () => controller.showTransferConfirmation(
                            member,
                            (presenter.user?.profile?.roles?.first ?? '') ==
                                    't4b'
                                ? 'owner'
                                : (presenter.user?.profile?.roles?.first ?? ''),
                          ),
                      onDelete: () => controller.showDeleteConfirmation(member),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.member,
    required this.onEdit,
    required this.onTransfer,
    required this.onDelete,
  });

  final ManageTeamModel member;
  final VoidCallback onEdit;
  final VoidCallback onTransfer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Name
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    if (member.isMyAccount ?? false) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Email
          Expanded(
            flex: 4,
            child: Text(
              member.displayEmail,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ),

          // Role
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 20,
              child: _RoleBadge(
                role:
                    (member.roleName ?? 'member') == 'pending'
                        ? 'member'
                        : (member.roleName ?? 'member'),
              ),
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 20,
              child: _StatusBadge(
                status: member.roleName == 'pending' ? 'Pending' : 'Active',
              ),
            ),
          ),

          // Actions
          if (member.isMyAccount ?? false) ...{
            Expanded(
              child: ShadButton.outline(
                size: ShadButtonSize.sm,
                onPressed: onDelete,
                child: Icon(
                  Icons.exit_to_app,
                  size: 16,
                  color: Colors.red.shade600,
                ),
              ),
            ),
          } else ...{
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    iconSize: 16,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  IconButton(
                    onPressed: onTransfer,
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    iconSize: 16,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.exit_to_app, size: 16),
                    iconSize: 16,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }

}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role.toLowerCase() == 'admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isAdmin
                ? const Color(0xFF0F172A).withValues(alpha: 0.1)
                : const Color(0xFF64748B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAdmin ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade500 : Colors.orange.shade500,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
