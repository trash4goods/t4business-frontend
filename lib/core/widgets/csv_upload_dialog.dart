import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:file_picker/file_picker.dart';
import '../app/themes/app_colors.dart';

class CsvUploadDialog extends StatefulWidget {
  final Function({
    String? filePath,
    String fileName,   
    Uint8List? fileBytes,
  })? onFileSelected;

  const CsvUploadDialog({
    super.key,
    this.onFileSelected,
  });

  @override
  State<CsvUploadDialog> createState() => _CsvUploadDialogState();
}

class _CsvUploadDialogState extends State<CsvUploadDialog> {
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;
  bool _isUploading = false;
  bool _hasSelectedFile = false;

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Upload CSV File'),
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
          child: const Text('Upload'),
        ),
      ],
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a CSV file to upload product data.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surfaceElevated,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  if (_selectedFileName != null) ...[
                    Text(
                      _selectedFileName!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      kIsWeb 
                          ? 'File loaded in memory (${_selectedFileBytes?.length ?? 0} bytes)'
                          : 'File path: ${_selectedFilePath ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  ShadButton.outline(
                    onPressed: _isUploading ? null : _pickFile,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isUploading) ...[
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(_selectedFileName != null ? 'Change File' : 'Choose File'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CSV Format Requirements:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kIsWeb
                        ? '• First row should contain headers\n• Required columns: name, code, brand, eco_grade, etc.\n• Maximum file size: 10MB\n• Web: File will be loaded into memory'
                        : '• First row should contain headers\n• Required columns: name, code, brand, eco_grade, etc.\n• Maximum file size: 10MB',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          debugPrint('File selected: ${file.name}');
          debugPrint('File size: ${file.size} bytes');
          debugPrint('Has bytes: ${file.bytes != null}');
          debugPrint('Has path: ${file.path != null}');
          debugPrint('Platform is web: $kIsWeb');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: Colors.red,
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
