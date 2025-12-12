// lib/core/components/common/image_upload_component.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class ImageUploadComponent extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onUpload;
  final VoidCallback? onRemove;
  final VoidCallback? onSetAsLogo; // New callback for setting as logo
  final String title;
  final String subtitle;
  final bool compact;
  final double? width;
  final double? height;
  final bool isLogo; // New property to indicate if this is already a logo

  const ImageUploadComponent({
    super.key,
    this.imageUrl,
    required this.onUpload,
    this.onRemove,
    this.onSetAsLogo,
    required this.title,
    required this.subtitle,
    this.compact = false,
    this.width,
    this.height,
    this.isLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl?.isNotEmpty == true) {
      return _buildImagePreview(context);
    } else {
      return _buildImageDropZone();
    }
  }

  Widget _buildImagePreview(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? (compact ? 80 : 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLogo ? AppColors.primary : AppColors.fieldBorder,
          width: isLogo ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(),
          ),
          // Logo badge
          if (isLogo)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LOGO',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryForeground,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Three dots menu button (always shown when image exists)
          Positioned(top: 4, right: 4, child: _buildMenuButton(context)),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete' && onRemove != null) {
          onRemove!();
        } else if (value == 'set_as_logo' && onSetAsLogo != null) {
          onSetAsLogo!();
        }
      },
      itemBuilder: (context) {
        List<PopupMenuItem<String>> items = [];

        // Always show delete option
        items.add(
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: AppColors.destructive,
                ),
                const SizedBox(width: 8),
                Text(
                  'Delete',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.destructive,
                  ),
                ),
              ],
            ),
          ),
        );

        // Show logo option only if onSetAsLogo callback is provided (from profile)
        if (onSetAsLogo != null) {
          items.add(
            PopupMenuItem<String>(
              value: 'set_as_logo',
              child: Row(
                children: [
                  Icon(
                    isLogo ? Icons.star : Icons.star_outline,
                    size: 16,
                    color: isLogo ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isLogo ? 'Remove as Logo' : 'Set as Logo',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return items;
      },
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.overlay.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.more_vert, color: Colors.white, size: 12),
      ),
      offset: const Offset(0, 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.fieldBorder.withOpacity(0.2)),
      ),
      color: AppColors.surface,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }

  Widget _buildImageWidget() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildImageDropZone();
    }

    // Determine image type and load accordingly
    if (_isAssetPath(imageUrl!)) {
      return Image.asset(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageErrorWidget();
        },
      );
    } else if (_isWebBlobUrl(imageUrl!)) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageErrorWidget();
        },
      );
    } else if (_isHttpUrl(imageUrl!)) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageErrorWidget();
        },
      );
    } else if (_isBase64DataUrl(imageUrl!)) {
      // Handle base64 data URLs
      try {
        final bytes = _decodeBase64Image(imageUrl!);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageErrorWidget();
          },
        );
      } catch (e) {
        return _buildImageErrorWidget();
      }
    } else {
      // Local file path - only on non-web platforms
      if (kIsWeb) {
        return _buildImageErrorWidget();
      } else {
        return Image.file(
          File(imageUrl!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageErrorWidget();
          },
        );
      }
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

  bool _isBase64DataUrl(String url) {
    return url.startsWith('data:image/') && url.contains(';base64,');
  }

  Uint8List _decodeBase64Image(String dataUrl) {
    // Extract the base64 part after 'data:image/[type];base64,'
    final base64String = dataUrl.split(',')[1];
    return base64Decode(base64String);
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceContainer,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 32,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildImageDropZone() {
    return InkWell(
      onTap: onUpload,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? (compact ? 80 : 120),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.fieldBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(compact ? 8 : 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: compact ? 16 : 24,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: compact ? 4 : 8),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 12 : 14,
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: compact ? 10 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
