// lib/features/rewards/presentation/components/reward_image_upload_component.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RewardViewImageUploadComponent extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onUpload;
  final VoidCallback? onRemove;
  final String title;
  final String subtitle;
  final bool compact;
  final double? width;
  final double? height;

  const RewardViewImageUploadComponent({
    super.key,
    this.imageUrl,
    required this.onUpload,
    this.onRemove,
    required this.title,
    required this.subtitle,
    this.compact = false,
    this.width,
    this.height,
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(),
          ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildImageDropZone();
    }

    if (imageUrl!.startsWith('assets/')) {
      return Image.asset(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else if (imageUrl!.startsWith('data:image/')) {
      // Handle base64 data URLs
      return Image.memory(
        Uri.parse(imageUrl!).data!.contentAsBytes(),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else if (imageUrl!.startsWith('http') || imageUrl!.startsWith('blob:')) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageErrorWidget(),
      );
    } else {
      if (kIsWeb) {
        return _buildImageErrorWidget();
      } else {
        return Image.file(
          File(imageUrl!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => _buildImageErrorWidget(),
        );
      }
    }
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF8FAFC),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 32,
        color: Color(0xFF64748B),
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
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(compact ? 6 : 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: compact ? 14 : 20,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: compact ? 2 : 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 10 : 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 1),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: compact ? 8 : 10,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: compact ? 1 : 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
