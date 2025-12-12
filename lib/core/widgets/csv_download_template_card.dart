import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';

class CsvDownloadTemplateCard extends StatelessWidget {
  final VoidCallback? onDownload;
  final bool isDownloading;
  final bool isCompleted;

  final bool isMobile;

  const CsvDownloadTemplateCard({
    super.key,
    required this.onDownload,
    required this.isDownloading,
    required this.isCompleted,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.3) : AppColors.border,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isCompleted 
            ? AppColors.success.withValues(alpha: 0.05) 
            : AppColors.surfaceElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCompleted ? Icons.check_circle_outline : Icons.file_download_outlined,
            size: 40,
            color: isCompleted ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            isCompleted ? 'Template Downloaded' : 'Download CSV Template',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCompleted ? AppColors.success : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Get the properly formatted template with all required columns',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ShadButton(
              onPressed: isDownloading ? null : onDownload,
              backgroundColor: isCompleted ? AppColors.success : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDownloading) ...[
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
                  if (!isDownloading) ...[
                    Icon(
                      isCompleted ? Icons.check : Icons.download,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    isDownloading 
                        ? 'Downloading...' 
                        : (isCompleted ? 'Downloaded' : 'Download'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          if (!isCompleted) ...[
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
                      'The template includes example data and column headers',
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
}