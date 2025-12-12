import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';

class MobileDeviceFrame extends StatelessWidget {
  final Widget child;

  const MobileDeviceFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 540,
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Status bar
          _buildStatusBar(),
          // Screen content
          Positioned(
            top: 40,
            left: 8,
            right: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Positioned(
      top: 12,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.signal_cellular_4_bar,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 4),
                Icon(Icons.wifi, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Icon(
                  Icons.battery_full,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
