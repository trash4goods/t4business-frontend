import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/custom_getview.dart';

import '../controller/department_management_controller.interface.dart';
import '../presenter/department_management_presenter.interface.dart';
import '../widgets/team_management_header.dart';
import '../widgets/team_management_empty_state.dart';
import '../widgets/team_member_list_view.dart';

class ManageTeamView
    extends
        CustomGetView<
          DepartmentManagementControllerInterface,
          DepartmentManagementPresenterInterface
        > {
  const ManageTeamView({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar:
              (isMobile || isTablet)
                  ? AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: businessController.onBack,
                    ),
                    title: const Text(
                      'Manage Team',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  )
                  : null,
          body: Container(
            color: const Color(0xFFFAFAFA),
            child: Column(
              children: [
                // Desktop header (when no scaffold ancestor)
                if (!hasScaffoldAncestor && !isMobile && !isTablet)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: businessController.onBack,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Manage Team',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main content area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      children: [
                        // Team management header with search and add button
                        TeamManagementHeader(
                          presenter: presenter,
                          controller: businessController,
                          isMobile: isMobile,
                        ),
                        const SizedBox(height: 24),

                        // Main content - list or empty state
                        Expanded(
                          child: Obx(() {
                            // Show loading state
                            if (presenter.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            // Show error state
                            if (presenter.error.isNotEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: isMobile ? 48 : 64,
                                      color: const Color(0xFF64748B),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error',
                                      style: TextStyle(
                                        fontSize: isMobile ? 18 : 24,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      presenter.error,
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 16,
                                        color: const Color(0xFF64748B),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed:
                                          () async =>
                                              await presenter.loadDepartment(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Show empty state or member list
                            if (presenter.filteredMembers.isEmpty) {  
                              // Check if it's empty due to search or actually no members
                              if (presenter.searchQuery.isNotEmpty &&
                                  presenter.teamMembers.isNotEmpty) {
                                // No search results
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: isMobile ? 48 : 64,
                                        color: const Color(0xFF64748B),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No members found',
                                        style: TextStyle(
                                          fontSize: isMobile ? 18 : 24,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Try adjusting your search query',
                                        style: TextStyle(
                                          fontSize: isMobile ? 14 : 16,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // Actually no members
                                return TeamManagementEmptyState(
                                  isMobile: isMobile,
                                  onAddMember:
                                      businessController.showAddMemberDialogUI,
                                );
                              }
                            }

                            // Show member list
                            return TeamMemberListView(
                              presenter: presenter,
                              controller: businessController,
                              isMobile: isMobile,
                              onEditMember:
                                  businessController.showEditMemberDialogUI,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mobile FAB for adding members
          floatingActionButton:
              isMobile
                  ? FloatingActionButton(
                    onPressed: businessController.showAddMemberDialogUI,
                    backgroundColor: const Color(0xFF0F172A),
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                  : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
