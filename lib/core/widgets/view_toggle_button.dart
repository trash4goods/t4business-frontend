import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

enum ViewMode { grid, list }

class ViewToggleButton extends StatelessWidget {
  final ViewMode currentView;
  final ValueChanged<ViewMode> onViewChanged;

  const ViewToggleButton({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            icon: Icons.grid_view,
            isSelected: currentView == ViewMode.grid,
            onTap: () => onViewChanged(ViewMode.grid),
            tooltip: 'Grid View',
          ),
          Container(
            width: 3,
            height: 32,
            color: AppColors.border,
          ),
          _buildToggleButton(
            icon: Icons.view_list,
            isSelected: currentView == ViewMode.list,
            onTap: () => onViewChanged(ViewMode.list),
            tooltip: 'List View',
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
