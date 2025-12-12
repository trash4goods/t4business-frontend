// lib/core/components/profile/compact_profile_card.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';

class CompactProfileCard extends StatelessWidget {
  final String? imageUrl;
  final String? mainLogoUrl; // Main logo URL
  final String name;
  final String email;
  final VoidCallback? onImageTap;
  final VoidCallback? onEditTap;
  final bool isLoading;

  const CompactProfileCard({
    super.key,
    this.imageUrl,
    this.mainLogoUrl,
    required this.name,
    required this.email,
    this.onImageTap,
    this.onEditTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Compact avatar
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      mainLogoUrl != null
                          ? AppColors.primary
                          : AppColors.fieldBorder,
                  width: mainLogoUrl != null ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: _buildAvatarImage(),
                  ),
                  // Logo badge when showing main logo
                  if (mainLogoUrl != null)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.surface,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.business,
                          size: 10,
                          color: AppColors.primaryForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Profile info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Loading...' : name,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          if (onEditTap != null)
            IconButton(
              onPressed: isLoading ? null : onEditTap,
              icon:
                  isLoading
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                      : Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(32, 32),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    // Priority: Main logo > Profile picture > Placeholder
    final displayUrl = mainLogoUrl ?? imageUrl;

    if (displayUrl != null && displayUrl.isNotEmpty) {
      // Handle different image types like ImageUploadComponent
      if (_isAssetPath(displayUrl)) {
        return Image.asset(
          displayUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
        );
      } else if (_isWebBlobUrl(displayUrl) || _isHttpUrl(displayUrl)) {
        return Image.network(
          displayUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
        );
      } else {
        // Fallback to network for unknown types
        return Image.network(
          displayUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
        );
      }
    } else {
      return _buildAvatarPlaceholder();
    }
  }

  bool _isAssetPath(String path) {
    return path.startsWith('assets/');
  }

  bool _isWebBlobUrl(String url) {
    return url.startsWith('blob:');
  }

  bool _isHttpUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      alignment: Alignment.center,
      color: AppColors.surfaceContainer,
      child: Icon(
        Icons.person_outline,
        size: 28,
        color: AppColors.textSecondary,
      ),
    );
  }
}
