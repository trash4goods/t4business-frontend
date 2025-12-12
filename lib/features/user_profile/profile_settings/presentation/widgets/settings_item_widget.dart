import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../profile_change_password/domain/entities/settings_item.dart';

class ProfileSettingsItemWidget extends StatelessWidget {
  final SettingsItemModel item;
  final bool isDesktop;
  final bool isTablet;
  final Function(String) onTap;

  const ProfileSettingsItemWidget({
    super.key,
    required this.item,
    required this.isDesktop,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item.id),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16 : (isTablet ? 14 : 12),
          vertical: isDesktop ? 16 : (isTablet ? 14 : 12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              item.icon,
              size: isDesktop ? 24 : (isTablet ? 22 : 20),
              color: item.isDestructive 
                  ? AppColors.destructive 
                  : AppColors.foreground,
            ),
            SizedBox(width: isDesktop ? 16 : (isTablet ? 14 : 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: ShadTheme.of(context).textTheme.p.copyWith(
                      fontWeight: FontWeight.w500,
                      color: item.isDestructive 
                          ? AppColors.destructive 
                          : AppColors.foreground,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle!,
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: isDesktop ? 14 : (isTablet ? 13 : 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: isDesktop ? 20 : (isTablet ? 18 : 16),
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}