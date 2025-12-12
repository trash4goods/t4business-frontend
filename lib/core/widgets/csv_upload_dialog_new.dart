import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../app/themes/app_colors.dart';
import 'csv_step_indicator.dart';
import 'csv_download_template_card.dart';
import 'csv_file_upload_card.dart';

class CsvUploadDialogNew extends StatefulWidget {
  final Function({
    String? filePath,
    String fileName,   
    Uint8List? fileBytes,
  })? onFileSelected;

  const CsvUploadDialogNew({
    super.key,
    this.onFileSelected,
  });

  @override
  State<CsvUploadDialogNew> createState() => _CsvUploadDialogNewState();
}

class _CsvUploadDialogNewState extends State<CsvUploadDialogNew> {
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;
  bool _isUploading = false;
  bool _hasSelectedFile = false;
  bool _isDownloadingTemplate = false;
  bool _hasDownloadedTemplate = false;
  
  int get _currentStep {
    if (_hasSelectedFile) return 2;
    if (_hasDownloadedTemplate) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth < 900;
    final isMobile = screenWidth < 600;
    
    double dialogWidth;
    if (isMobile) {
      dialogWidth = screenWidth * 0.85; // More space for mobile
    } else if (isTablet) {
      dialogWidth = screenWidth * 0.9;
    } else {
      dialogWidth = 800.0.clamp(600.0, screenWidth * 0.9); // Desktop
    }
    
    return ShadDialog(
      title: const Text('Upload Products via CSV'),
      description: const Text(
        'Follow these simple steps to bulk upload your products',
      ),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ShadButton(
          onPressed: _hasSelectedFile && !_isUploading
              ? () {
                  if (widget.onFileSelected != null && _selectedFileName != null) {
                    widget.onFileSelected!(
                      filePath: _selectedFilePath,
                      fileName: _selectedFileName!,
                      fileBytes: _selectedFileBytes,
                    );
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
                _buildMobileLayout(),
              ] else ...[
                // Desktop: Side by side layout
                _buildDesktopLayout(),
              ],
              
              const SizedBox(height: 20),
              
              // Help text
              _buildHelpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        CsvDownloadTemplateCard(
          onDownload: _downloadTemplate,
          isDownloading: _isDownloadingTemplate,
          isCompleted: _hasDownloadedTemplate,
          isMobile: isMobile,
        ),
        const SizedBox(height: 16),
        CsvFileUploadCard(
          selectedFileName: _selectedFileName,
          selectedFileBytes: _selectedFileBytes,
          isUploading: _isUploading,
          isCompleted: false,
          onPickFile: _pickFile,
          isStepActive: _hasDownloadedTemplate,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
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
                onDownload: _downloadTemplate,
                isDownloading: _isDownloadingTemplate,
                isCompleted: _hasDownloadedTemplate,
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
                selectedFileName: _selectedFileName,
                selectedFileBytes: _selectedFileBytes,
                isUploading: _isUploading,
                isCompleted: false,
                onPickFile: _pickFile,
                isStepActive: _hasDownloadedTemplate,
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

  Future<void> _downloadTemplate() async {
    setState(() {
      _isDownloadingTemplate = true;
    });

    try {
      // Fetch template URL from Firebase
      final snapshot = await FirebaseFirestore.instance
          .collection('csv_template')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Template not found');
      }

      final templateUrl = snapshot.docs.first.data()['url'] as String?;
      if (templateUrl == null) {
        throw Exception('Template URL not found');
      }

      // Download the file
      final response = await http.get(Uri.parse(templateUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create download link
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement()
          ..href = url
          ..download = 'products_template.csv'
          ..click();
        
        html.Url.revokeObjectUrl(url);
        
        setState(() {
          _hasDownloadedTemplate = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template downloaded successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        throw Exception('Failed to download template');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading template: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloadingTemplate = false;
      });
    }
  }

  Future<void> _pickFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        setState(() {
          _selectedFileName = file.name;
          _selectedFileBytes = file.bytes;
          _selectedFilePath = file.path;
          _hasSelectedFile = true;
        });
        
        if (kDebugMode) {
          print('File selected: ${file.name}');
          print('File size: ${file.size} bytes');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}