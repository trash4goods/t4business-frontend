import 'package:flutter/material.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  final BoxConstraints constraints;
  final String title;
  final String subtitle;
  final IconData icon;

  const PageHeader({
    super.key,
    required this.constraints,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 20),
                onPressed: () => Scaffold.of(context).openDrawer(),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.foreground,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isDesktop
                      ? AppTextStyles.h3green
                      : AppTextStyles.h4green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
