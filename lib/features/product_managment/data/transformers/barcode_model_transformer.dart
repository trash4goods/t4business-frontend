import 'dart:developer';
import '../models/barcode/barcode_result.dart';
import '../models/barcode_upload.dart';
import '../models/barcode_update_upload_file.dart';
import '../../utils/image_base64_converter.dart';

/// Utility class for transforming between BarcodeResultModel and BarcodeUploadModel
/// Handles field mapping and image conversion for product update operations
class BarcodeModelTransformer {
  /// Converts BarcodeResultModel to BarcodeUploadModel without image processing
  ///
  /// [source] - The source BarcodeResultModel to convert
  /// [deleteFiles] - Whether to mark files for deletion (defaults to false)
  ///
  /// Returns a BarcodeUploadModel with mapped fields
  static BarcodeUploadModel toUploadModel(
    BarcodeResultModel source, {
    bool deleteFiles = false,
  }) {
    log(
      '[BarcodeModelTransformer] Converting BarcodeResultModel to BarcodeUploadModel',
    );

    return BarcodeUploadModel(
      name: source.name,
      code: source.code,
      brand: source.brand,
      ecoGrade: source.ecoGrade,
      co2Packaging: source.co2Packaging,
      mainMaterial: source.mainMaterial,
      instructions: source.instructions,
      trashType: source.trashType,
      deleteFile: deleteFiles ? "True" : "False",
      uploadFiles: [], // Empty list when not processing images
    );
  }

  /// Converts BarcodeResultModel to BarcodeUploadModel with base64 image conversion
  ///
  /// [source] - The source BarcodeResultModel to convert
  /// [deleteFiles] - Whether to mark files for deletion (defaults to false)
  /// [isUpdate] - Whether this is an update operation (defaults to false)
  ///
  /// Returns a Future<BarcodeUploadModel> with mapped fields and converted images
  /// Images are converted to base64 format using ImageBase64Converter
  static Future<BarcodeUploadModel> toUploadModelWithBase64Images(
    BarcodeResultModel source, {
    bool deleteFiles = false,
    bool isUpdate = false,
  }) async {
    log(
      '[BarcodeModelTransformer] Converting BarcodeResultModel to BarcodeUploadModel with base64 images',
    );

    List<BarcodeUpdateUploadFileModel> convertedFiles = [];

    // Convert images to base64 if files exist
    if (source.files != null && source.files!.isNotEmpty && !deleteFiles) {
      try {
        log(
          '[BarcodeModelTransformer] Converting ${source.files!.length} images to base64',
        );
        convertedFiles = await ImageBase64Converter.convertImagesToBase64(
          source.files!,
        );
        log(
          '[BarcodeModelTransformer] Successfully converted ${convertedFiles.length} images',
        );
      } catch (e) {
        log('[BarcodeModelTransformer] Error converting images to base64: $e');
        // Continue with empty files list if conversion fails
        convertedFiles = [];
      }
    }

    return BarcodeUploadModel(
      name: source.name,
      code: source.code,
      brand: source.brand,
      ecoGrade: source.ecoGrade,
      co2Packaging: source.co2Packaging,
      mainMaterial: source.mainMaterial,
      instructions: source.instructions,
      trashType: source.trashType,
      uploadFiles: convertedFiles,
      // Set deleteFile to "True" when updating with new images to replace old ones
      deleteFile: isUpdate ? deleteFiles ? "True" : "False" : null,
    );
  }

  /// Validates that a BarcodeResultModel has the minimum required fields for update
  ///
  /// [source] - The source model to validate
  ///
  /// Returns true if the model has required fields, false otherwise
  static bool isValidForUpdate(BarcodeResultModel source) {
    // Check for essential fields that are typically required for updates
    if (source.name == null || source.name!.trim().isEmpty) {
      log('[BarcodeModelTransformer] Validation failed: name is required');
      return false;
    }

    if (source.code == null || source.code!.trim().isEmpty) {
      log('[BarcodeModelTransformer] Validation failed: code is required');
      return false;
    }

    log('[BarcodeModelTransformer] Model validation passed');
    return true;
  }

  /// Creates a copy of BarcodeResultModel with updated fields
  ///
  /// [source] - The source model to copy
  /// [name] - Optional new name
  /// [code] - Optional new code
  /// [brand] - Optional new brand
  /// [ecoGrade] - Optional new eco grade
  /// [co2Packaging] - Optional new CO2 packaging value
  /// [mainMaterial] - Optional new main material
  /// [instructions] - Optional new instructions
  /// [trashType] - Optional new trash type
  ///
  /// Returns a new BarcodeResultModel with updated fields
  static BarcodeResultModel copyWith(
    BarcodeResultModel source, {
    String? name,
    String? code,
    String? brand,
    String? ecoGrade,
    double? co2Packaging,
    String? mainMaterial,
    String? instructions,
    String? trashType,
  }) {
    return BarcodeResultModel(
      id: source.id,
      name: name ?? source.name,
      code: code ?? source.code,
      brand: brand ?? source.brand,
      ecoGrade: ecoGrade ?? source.ecoGrade,
      co2Packaging: co2Packaging ?? source.co2Packaging,
      mainMaterial: mainMaterial ?? source.mainMaterial,
      instructions: instructions ?? source.instructions,
      trashType: trashType ?? source.trashType,
      files: source.files,
    );
  }

  /// Logs the field mapping for debugging purposes
  ///
  /// [source] - The source model
  /// [result] - The resulting upload model
  static void _logFieldMapping(
    BarcodeResultModel source,
    BarcodeUploadModel result,
  ) {
    log('[BarcodeModelTransformer] Field mapping:');
    log('  name: ${source.name} -> ${result.name}');
    log('  code: ${source.code} -> ${result.code}');
    log('  brand: ${source.brand} -> ${result.brand}');
    log('  ecoGrade: ${source.ecoGrade} -> ${result.ecoGrade}');
    log('  co2Packaging: ${source.co2Packaging} -> ${result.co2Packaging}');
    log('  mainMaterial: ${source.mainMaterial} -> ${result.mainMaterial}');
    log('  instructions: ${source.instructions} -> ${result.instructions}');
    log('  trashType: ${source.trashType} -> ${result.trashType}');
    log('  deleteFile: ${result.deleteFile}');
    log('  uploadFiles count: ${result.uploadFiles?.length ?? 0}');
  }
}
