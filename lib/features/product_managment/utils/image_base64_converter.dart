import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/models/barcode/barcode_result_file.dart';
import '../data/models/barcode_update_upload_file.dart';

/// Utility class for converting image URLs to base64 format
/// Used for preparing images for API upload in product update operations
class ImageBase64Converter {
  // HTTP client for dependency injection in tests
  static http.Client? _httpClient;

  // Supported image MIME types
  static const List<String> _supportedMimeTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
    'image/bmp',
  ];

  // Supported file extensions
  static const List<String> _supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
  ];

  /// Sets the HTTP client for testing purposes
  static void setHttpClient(http.Client? client) {
    _httpClient = client;
  }

  /// Gets the HTTP client (for testing or default)
  static http.Client get _client => _httpClient ?? http.Client();

  /// Converts a single image URL to base64 format
  ///
  /// [imageUrl] - The URL of the image to convert
  ///
  /// Returns a Future<String> containing the base64 encoded image with data URI prefix
  /// Throws [ImageConversionException] if conversion fails
  static Future<String> urlToBase64(String imageUrl) async {
    try {
      log('[ImageBase64Converter] Converting image URL to base64: ${imageUrl.substring(0, imageUrl.length > 50 ? 50 : imageUrl.length)}...');

      // Check if it's already a base64 data URL
      if (imageUrl.startsWith('data:image/') && imageUrl.contains(';base64,')) {
        log('[ImageBase64Converter] URL is already a base64 data URI, returning as-is');
        return imageUrl;
      }

      // Validate URL format
      if (!_isValidUrl(imageUrl)) {
        throw ImageConversionException('Invalid URL format: $imageUrl');
      }

      // Validate file extension
      if (!_hasValidExtension(imageUrl)) {
        throw ImageConversionException(
          'Unsupported image format. URL: $imageUrl',
        );
      }

      // Make HTTP request to download the image
      final response = await _client
          .get(
            Uri.parse(imageUrl),
            headers: {'User-Agent': 'T4G-Business-App/1.0'},
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw ImageConversionException(
                'Request timeout for URL: $imageUrl',
              );
            },
          );

      // Check response status
      if (response.statusCode != 200) {
        throw ImageConversionException(
          'Failed to download image. Status: ${response.statusCode}, URL: $imageUrl',
        );
      }

      // Validate content type
      final contentType = response.headers['content-type'];
      if (contentType == null ||
          !_supportedMimeTypes.contains(contentType.toLowerCase())) {
        throw ImageConversionException(
          'Unsupported content type: $contentType for URL: $imageUrl',
        );
      }

      // Validate content length (max 10MB)
      final contentLength = response.contentLength ?? response.bodyBytes.length;
      if (contentLength > 10 * 1024 * 1024) {
        throw ImageConversionException(
          'Image too large: ${contentLength} bytes. Max size: 10MB. URL: $imageUrl',
        );
      }

      // Convert to base64 using compute to avoid blocking UI
      final bytes = response.bodyBytes;
      final base64String = await compute(_encodeToBase64, bytes);

      // Create data URI with proper MIME type
      final dataUri = 'data:$contentType;base64,$base64String';

      log(
        '[ImageBase64Converter] Successfully converted image to base64. Size: ${bytes.length} bytes',
      );
      return dataUri;
    } on http.ClientException catch (e) {
      log('[ImageBase64Converter] Network error: $e');
      throw ImageConversionException(
        'Network error while downloading image: $e',
      );
    } catch (e) {
      log('[ImageBase64Converter] Conversion error: $e');
      if (e is ImageConversionException) {
        rethrow;
      }
      throw ImageConversionException(
        'Unexpected error during image conversion: $e',
      );
    }
  }

  /// Converts a list of BarcodeResultFileModel to BarcodeUpdateUploadFileModel
  ///
  /// [files] - List of file models from the result model
  ///
  /// Returns a Future<List<BarcodeUpdateUploadFileModel>> with base64 encoded images
  /// Skips files that fail to convert and logs errors
  static Future<List<BarcodeUpdateUploadFileModel>> convertImagesToBase64(
    List<BarcodeResultFileModel> files,
  ) async {
    final List<BarcodeUpdateUploadFileModel> convertedFiles = [];

    log('[ImageBase64Converter] Converting ${files.length} images to base64');

    for (int i = 0; i < files.length; i++) {
      final file = files[i];

      try {
        // Skip files without URL
        if (file.url == null || file.url!.isEmpty) {
          log('[ImageBase64Converter] Skipping file ${i + 1}: No URL provided');
          continue;
        }

        // Skip files without filename
        if (file.fileName == null || file.fileName!.isEmpty) {
          log(
            '[ImageBase64Converter] Skipping file ${i + 1}: No filename provided',
          );
          continue;
        }

        // Convert to base64
        final base64Data = await urlToBase64(file.url!);

        // Create upload file model
        final uploadFile = BarcodeUpdateUploadFileModel(
          name: file.fileName!,
          base64: base64Data,
        );

        convertedFiles.add(uploadFile);
        log(
          '[ImageBase64Converter] Successfully converted file ${i + 1}: ${file.fileName}',
        );
      } catch (e) {
        log(
          '[ImageBase64Converter] Failed to convert file ${i + 1} (${file.fileName}): $e',
        );
        // Continue with other files instead of failing completely
        continue;
      }
    }

    log(
      '[ImageBase64Converter] Conversion complete. ${convertedFiles.length}/${files.length} files converted successfully',
    );
    return convertedFiles;
  }

  /// Validates if the provided string is a valid URL
  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validates if the URL has a supported image file extension
  static bool _hasValidExtension(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      return _supportedExtensions.any((ext) => path.endsWith(ext));
    } catch (e) {
      return false;
    }
  }

  /// Validates if the MIME type is supported
  static bool isSupportedMimeType(String? mimeType) {
    if (mimeType == null) return false;
    return _supportedMimeTypes.contains(mimeType.toLowerCase());
  }

  /// Gets the list of supported MIME types
  static List<String> get supportedMimeTypes =>
      List.unmodifiable(_supportedMimeTypes);

  /// Gets the list of supported file extensions
  static List<String> get supportedExtensions =>
      List.unmodifiable(_supportedExtensions);

  /// Converts a local file to base64 format using bytes (ASYNC version)
  ///
  /// [fileBytes] - The bytes of the file to convert
  /// [fileName] - The name of the file (used to determine MIME type)
  ///
  /// Returns a Future<String> containing the base64 encoded image with data URI prefix
  /// Throws [ImageConversionException] if conversion fails
  static Future<String> bytesToBase64(Uint8List fileBytes, String fileName) async {
    try {
      log('[ImageBase64Converter] Converting file bytes to base64: $fileName');

      // Validate file extension
      if (!_hasValidExtension(fileName)) {
        throw ImageConversionException(
          'Unsupported image format for file: $fileName',
        );
      }

      // Validate file size (max 10MB)
      if (fileBytes.length > 10 * 1024 * 1024) {
        throw ImageConversionException(
          'Image too large: ${fileBytes.length} bytes. Max size: 10MB. File: $fileName',
        );
      }

      // Determine MIME type from file extension
      final mimeType = _getMimeTypeFromFileName(fileName);

      // Convert to base64 using compute to avoid blocking UI
      final base64String = await compute(_encodeToBase64, fileBytes);

      // Create data URI with proper MIME type
      final dataUri = 'data:$mimeType;base64,$base64String';

      log(
        '[ImageBase64Converter] Successfully converted file to base64. Size: ${fileBytes.length} bytes',
      );
      return dataUri;
    } catch (e) {
      log('[ImageBase64Converter] Conversion error: $e');
      if (e is ImageConversionException) {
        rethrow;
      }
      throw ImageConversionException(
        'Unexpected error during file conversion: $e',
      );
    }
  }

  /// Isolate function for base64 encoding (runs in separate thread)
  /// This prevents UI blocking during heavy base64 encoding operations
  static String _encodeToBase64(Uint8List fileBytes) {
    return base64Encode(fileBytes);
  }

  /// Determines the MIME type based on file extension
  static String _getMimeTypeFromFileName(String fileName) {
    final lowerName = fileName.toLowerCase();
    
    if (lowerName.endsWith('.jpg') || lowerName.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (lowerName.endsWith('.png')) {
      return 'image/png';
    } else if (lowerName.endsWith('.gif')) {
      return 'image/gif';
    } else if (lowerName.endsWith('.webp')) {
      return 'image/webp';
    } else if (lowerName.endsWith('.bmp')) {
      return 'image/bmp';
    } else {
      // Default to JPEG if unknown
      return 'image/jpeg';
    }
  }
}

/// Custom exception for image conversion errors
class ImageConversionException implements Exception {
  final String message;

  const ImageConversionException(this.message);

  @override
  String toString() => 'ImageConversionException: $message';
}
