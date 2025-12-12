import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';

class CsvFileUploadCard extends StatelessWidget {
  final String? selectedFileName;
  final Uint8List? selectedFileBytes;
  final bool isUploading;
  final bool isCompleted;
  final VoidCallback? onPickFile;
  final bool isStepActive;

  final bool isMobile;

  const CsvFileUploadCard({
    super.key,
    required this.selectedFileName,
    required this.selectedFileBytes,
    required this.isUploading,
    required this.isCompleted,
    required this.onPickFile,
    required this.isStepActive,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFileName != null && (selectedFileName ?? '').isNotEmpty;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
          style: isStepActive && !hasFile ? BorderStyle.solid : BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _getBackgroundColor(),
      ),
      child: Column(
        children: [
          Icon(
            _getIcon(),
            size: 40,
            color: _getIconColor(),
          ),
          const SizedBox(height: 12),
          Text(
            _getTitle(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasFile
                ? 'File: $selectedFileName'
                : 'Select your filled CSV file to upload',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (hasFile && selectedFileBytes != null) ...[
            const SizedBox(height: 4),
            Text(
              'Size: ${_formatFileSize(selectedFileBytes!.length)}',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ShadButton(
              onPressed: isUploading ? null : onPickFile,
              backgroundColor: hasFile ? AppColors.primary : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isUploading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (!isUploading) ...[
                    Icon(
                      hasFile ? Icons.upload_file : Icons.folder_open,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    isUploading 
                        ? 'Selecting...' 
                        : (hasFile ? 'Change' : 'Choose'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          if (!hasFile) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Use the template from Step 1 or your existing template',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBorderColor() {
    if (isCompleted) return AppColors.success.withValues(alpha: 0.3);
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return AppColors.primary.withValues(alpha: 0.3);
    return AppColors.border;
  }

  Color _getBackgroundColor() {
    if (isCompleted) return AppColors.success.withValues(alpha: 0.05);
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return AppColors.primary.withValues(alpha: 0.05);
    return AppColors.surfaceElevated;
  }

  IconData _getIcon() {
    if (isCompleted) return Icons.check_circle_outline;
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return Icons.description;
    return Icons.cloud_upload_outlined;
  }

  Color _getIconColor() {
    if (isCompleted) return AppColors.success;
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return AppColors.primary;
    return AppColors.primary;
  }

  Color _getTextColor() {
    if (isCompleted) return AppColors.success;
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return AppColors.primary;
    return AppColors.textPrimary;
  }

  String _getTitle() {
    if (isCompleted) return 'File Uploaded';
    if (selectedFileName != null && (selectedFileName ?? '').isNotEmpty) return 'File Selected';
    return 'Upload Your CSV File';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}