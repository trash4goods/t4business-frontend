import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/app/app_images.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../domain/entities/product_file_entity.dart';

class BannerImage extends StatelessWidget {
  final String placeholderPath;
  final List<ProductFileEntity> files;
  final String? lastImageUrl;
  final bool shoudlShowT4Glogo;
  final BoxFit? fit;

  const BannerImage({
    super.key,
    required this.placeholderPath,
    required this.files,
    this.lastImageUrl,
    this.shoudlShowT4Glogo = false,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    // Use lastImageUrl if available, otherwise use first file
    String? imageUrl = lastImageUrl;
    if ((imageUrl == null || imageUrl.isEmpty) && files.isNotEmpty) {
      imageUrl = files.first.url;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      log('📱 Mobile Preview: Loading image: $imageUrl');
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImageWidget(imageUrl, fit: fit),
      );
    } else {
      log('📱 Mobile Preview: Loading T4G logo');
      return _buildPlaceholder();
    }
  }

  Widget _buildImageWidget(String imageUrl, {BoxFit? fit}) {
    log('📱 Mobile Preview: Loading image: $imageUrl');

    // Handle different image types
    if (imageUrl.startsWith('assets/')) {
      // Asset image
      log('📱 Mobile Preview: Loading asset image: $imageUrl');
      return Image.asset(
        imageUrl,
        fit: fit ?? BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          log('💥 Mobile Preview: Error loading asset image: $error');
          return _buildPlaceholder();
        },
      );
    } else if (imageUrl.startsWith('blob:') || imageUrl.startsWith('http')) {
      // Network image (including blob URLs for web)
      log('📱 Mobile Preview: Loading network image: $imageUrl');
      return Image.network(
        imageUrl,
        fit: fit ?? BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          log('💥 Mobile Preview: Error loading network image: $error');
          return _buildPlaceholder();
        },
      );
    } else {
      // Local file (only on non-web platforms)
      if (kIsWeb) {
        log(
          '⚠️ Mobile Preview: Local file path on web, falling back to placeholder',
        );
        return _buildPlaceholder();
      } else {
        log('📱 Mobile Preview: Loading local file: $imageUrl');
        return Image.file(
          File(imageUrl),
          fit: fit ?? BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            log('💥 Mobile Preview: Error loading local file: $error');
            return _buildPlaceholder();
          },
        );
      }
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        !shoudlShowT4Glogo ? placeholderPath : AppImages.logo,
        fit: fit ?? BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Icon(
              Icons.image_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
      ),
    );
  }

  static Widget buildCarouselImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        "assets/images/default_event_picture.jpg",
        fit: BoxFit.cover,
        width: double.infinity,
        height: 140,
      );
    }

    // Check if it's a local file path or URL
    if (kIsWeb) {
      // On web, handle network/blob URLs, assets, and base64 data URLs
      if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
        );
      } else if (_isBase64DataUrl(imageUrl)) {
        // Handle base64 data URLs
        try {
          final bytes = _decodeBase64Image(imageUrl);
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 140,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/default_event_picture.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
              );
            },
          );
        } catch (e) {
          return Image.asset(
            "assets/images/default_event_picture.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 140,
          );
        }
      } else {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/default_event_picture.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 140,
            );
          },
        );
      }
    } else {
      // On non-web platforms, handle local files
      final isLocalFile =
          !imageUrl.startsWith('http') && !imageUrl.startsWith('assets/');

      if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
        );
      } else if (isLocalFile) {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/default_event_picture.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 140,
            );
          },
        );
      } else {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 140,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/default_event_picture.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 140,
            );
          },
        );
      }
    }
  }

  static bool _isBase64DataUrl(String url) {
    return url.startsWith('data:image/') && url.contains(';base64,');
  }

  static Uint8List _decodeBase64Image(String dataUrl) {
    // Extract the base64 part after 'data:image/[type];base64,'
    final base64String = dataUrl.split(',')[1];
    return base64Decode(base64String);
  }
}