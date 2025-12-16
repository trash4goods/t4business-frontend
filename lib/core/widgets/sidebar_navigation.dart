// core/widgets/sidebar_navigation.dart
import 'package:flutter/material.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../app/app_routes.dart';
import '../app/constants.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';
import '../utils/municipality_utils.dart';

class SidebarNavigation extends StatelessWidget {
  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SidebarNavigation({
    super.key,
    required this.currentRoute,
    required this.isCollapsed,
    required this.onToggle,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint;
    final sidebarWidth = isCollapsed ? 80.0 : 280.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isDesktop ? sidebarWidth : null,
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          _buildHeader(isDesktop),
          Expanded(child: _buildNavigationItems()),
          if (!isCollapsed) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isCollapsed ? 16 : 24),
      height: isCollapsed ? 64 : 80,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final shouldShowExpanded = !isCollapsed && availableWidth > 150;

          if (!shouldShowExpanded) {
            return Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: onToggle,
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.primary,
                  ),
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 40),
                  ),
                  tooltip: 'Expand sidebar',
                ),
              ),
            );
          }

          return Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(AppImages.logo),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Trash4Business',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDesktop && availableWidth > 200) ...[
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.mutedForeground.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    onPressed: onToggle,
                    icon: const Icon(Icons.keyboard_arrow_left),
                    iconSize: 18,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.mutedForeground,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 32),
                    ),
                    tooltip: 'Collapse sidebar',
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationItems() {
    return FutureBuilder<bool>(
      future: MunicipalityUtils.isMunicipalityUser(),
      builder: (context, snapshot) {
        final isMunicipality = snapshot.data ?? false;
        
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCollapsed) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedForeground,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                if (!isMunicipality) ...[
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: 'Dashboard',
                    route: AppRoutes.dashboard,
                  ),
                  const SizedBox(height: 4),
                  _buildNavItem(
                    icon: Icons.recycling_outlined,
                    activeIcon: Icons.recycling,
                    title: 'Recycling Products',
                    route: AppRoutes.productManagement,
                  ),
                  const SizedBox(height: 4),
                ],
                _buildNavItem(
                  icon: Icons.storefront_outlined,
                  activeIcon: Icons.storefront,
                  title: 'Rewards',
                  route: AppRoutes.rewards,
                ),
                const SizedBox(height: 4),
                if (!isMunicipality) ...[
                  _buildNavItem(
                    icon: Icons.rule_folder_outlined,
                    activeIcon: Icons.rule_folder,
                    title: 'Rules',
                    route: AppRoutes.rulesV2,
                  ),
                  const SizedBox(height: 4),
                ],
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  title: 'Profile',
                  route: AppRoutes.profile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return InkWell(
      onTap: () => onNavigate(route),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child:
            isCollapsed
                ? Tooltip(
                  message: title,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      isActive ? activeIcon : icon,
                      size: 20,
                      color: isActive ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                )
                : ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  leading: Icon(
                    isActive ? activeIcon : icon,
                    size: 18,
                    color: isActive ? AppColors.primary : AppColors.secondary,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                      color:
                          isActive
                              ? AppColors.accentForeground
                              : AppColors.foreground,
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 200) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primaryForeground,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Admin User',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.foreground,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'admin@t4g.com',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12,
                              color: AppColors.mutedForeground,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildLogoutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout, size: 16, color: AppColors.destructive),
        label: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.destructive,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: AppColors.destructive.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
