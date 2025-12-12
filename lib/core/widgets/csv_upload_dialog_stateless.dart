import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';
import 'csv_step_indicator.dart';
import 'csv_download_template_card.dart';
import 'csv_file_upload_card.dart';

class CsvUploadDialogStateless extends StatelessWidget {
  final String? selectedFileName;
  final String? selectedFilePath;
  final Uint8List? selectedFileBytes;
  final bool isUploading;
  final bool isDownloadingTemplate;
  final bool hasDownloadedTemplate;
  final bool hasSelectedFile;
  final VoidCallback onDownloadTemplate;
  final VoidCallback onPickFile;
  final VoidCallback? onCancel;
  final Function({
    String? filePath,
    String fileName,   
    Uint8List? fileBytes,
  })? onFileSelected;

  const CsvUploadDialogStateless({
    super.key,
    required this.selectedFileName,
    required this.selectedFilePath,
    required this.selectedFileBytes,
    required this.isUploading,
    required this.isDownloadingTemplate,
    required this.hasDownloadedTemplate,
    required this.hasSelectedFile,
    required this.onDownloadTemplate,
    required this.onPickFile,
    this.onCancel,
    this.onFileSelected,
  });

  int get _currentStep {
    if (hasSelectedFile) return 2;
    if (hasDownloadedTemplate) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth < 900;
    final isMobile = screenWidth < 600;
    
    double dialogWidth;
    if (isMobile) {
      dialogWidth = screenWidth * 0.85;
    } else if (isTablet) {
      dialogWidth = screenWidth * 0.9;
    } else {
      dialogWidth = 800.0.clamp(600.0, screenWidth * 0.9);
    }
    
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onCancel?.call();
        }
      },
      child: ShadDialog(
      title: const Text('Upload Products via CSV'),
      description: const Text(
        'Follow these simple steps to bulk upload your products',
      ),
      actions: [
        ShadButton.outline(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ShadButton(
          enabled: hasSelectedFile && !isUploading,
          onPressed: hasSelectedFile && !isUploading
              ? () {
                  if (onFileSelected != null && selectedFileName != null) {
                    onFileSelected!(
                      filePath: selectedFilePath,
                      fileName: selectedFileName!,
                      fileBytes: selectedFileBytes,
                    );
                    onCancel?.call(); // Clear state after save
                    Navigator.of(context).pop();
                  }
                }
              : null,
          child: const Text('Save'),
        ),
      ],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step Indicator
              CsvStepIndicator(
                currentStep: _currentStep,
                steps: const ['Download', 'Upload', 'Save'],
              ),
              const SizedBox(height: 24),
              
              // Content based on screen size
              if (isTablet) ...[
                // Mobile/Tablet: Stack cards vertically
                _buildMobileLayout(context),
              ] else ...[
                // Desktop: Side by side layout
                _buildDesktopLayout(context),
              ],
              
              const SizedBox(height: 20),
              
              // Help text
              _buildHelpSection(),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        CsvDownloadTemplateCard(
          onDownload: onDownloadTemplate,
          isDownloading: isDownloadingTemplate,
          isCompleted: hasDownloadedTemplate,
          isMobile: isMobile,
        ),
        const SizedBox(height: 16),
        CsvFileUploadCard(
          selectedFileName: selectedFileName,
          selectedFileBytes: selectedFileBytes,
          isUploading: isUploading,
          isCompleted: false,
          onPickFile: onPickFile,
          isStepActive: hasDownloadedTemplate,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1: Download Template
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeader(1, 'Download Template', _currentStep >= 0),
              const SizedBox(height: 12),
              CsvDownloadTemplateCard(
                onDownload: onDownloadTemplate,
                isDownloading: isDownloadingTemplate,
                isCompleted: hasDownloadedTemplate,
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // Step 2: Upload CSV
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeader(2, 'Upload Your CSV', _currentStep >= 1),
              const SizedBox(height: 12),
              CsvFileUploadCard(
                selectedFileName: selectedFileName,
                selectedFileBytes: selectedFileBytes,
                isUploading: isUploading,
                isCompleted: false,
                onPickFile: onPickFile,
                isStepActive: hasDownloadedTemplate,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader(int step, String title, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.surfaceElevated,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Step $step: $title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'CSV Requirements',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• First row must contain column headers\n'
            '• Required columns: name, code, brand, category, eco_grade\n'
            '• Optional columns: description, price, image_url\n'
            '• Maximum file size: 10MB\n'
            '• Supported format: .csv files only',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}