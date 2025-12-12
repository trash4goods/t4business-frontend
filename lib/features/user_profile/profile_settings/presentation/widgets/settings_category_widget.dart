import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../profile_change_password/domain/entities/settings_category.dart';
import 'settings_item_widget.dart';

class ProfileSettingsCategoryWidget extends StatelessWidget {
  final SettingsCategoryModel category;
  final bool isDesktop;
  final bool isTablet;
  final Function(String) onTap;

  const ProfileSettingsCategoryWidget({
    super.key,
    required this.category,
    required this.isDesktop,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop ? 20 : (isTablet ? 18 : 16)),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              category.title,
              style: ShadTheme.of(context).textTheme.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 16 : (isTablet ? 14 : 12)),
            itemCount: category.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ProfileSettingsItemWidget(
                item: category.items[index],
                isDesktop: isDesktop,
                isTablet: isTablet,
                onTap: (id) => onTap(id),
              );
            },
          ),
        ],
      ),
    );
  }
}