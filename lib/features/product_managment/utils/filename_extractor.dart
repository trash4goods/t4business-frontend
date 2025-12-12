import 'dart:developer';

/// Utility class for extracting and generating filenames from URLs and file paths
/// Used to ensure BarcodeResultFileModel objects have proper filenames for API operations
class FilenameExtractor {
  /// Extracts filename from a URL or file path
  ///
  /// [urlOrPath] - The URL or file path to extract filename from
  ///
  /// Returns a filename string, or generates one if extraction fails
  static String extractFilename(String urlOrPath) {
    try {
      log('[FilenameExtractor] Extracting filename from: $urlOrPath');

      // Handle blob URLs (common in web uploads)
      if (urlOrPath.startsWith('blob:')) {
        log('[FilenameExtractor] Detected blob URL, generating filename');
        return _generateBlobFilename();
      }

      // Handle data URLs (base64 encoded images)
      if (urlOrPath.startsWith('data:')) {
        log('[FilenameExtractor] Detected data URL, generating filename');
        return _generateDataUrlFilename(urlOrPath);
      }

      // Handle regular URLs and file paths
      final uri = Uri.tryParse(urlOrPath);
      if (uri != null) {
        // Extract filename from path
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          final lastSegment = pathSegments.last;
          if (lastSegment.isNotEmpty && _hasValidExtension(lastSegment)) {
            log('[FilenameExtractor] Extracted filename: $lastSegment');
            return lastSegment;
          }
        }
      }

      // Fallback: try to extract from the end of the string
      final parts = urlOrPath.split('/');
      if (parts.isNotEmpty) {
        final lastPart = parts.last;
        if (lastPart.isNotEmpty && _hasValidExtension(lastPart)) {
          log('[FilenameExtractor] Extracted filename from path: $lastPart');
          return lastPart;
        }
      }

      // Final fallback: generate a filename
      log('[FilenameExtractor] Could not extract filename, generating default');
      return _generateDefaultFilename();
    } catch (e) {
      log('[FilenameExtractor] Error extracting filename: $e');
      return _generateDefaultFilename();
    }
  }

  /// Generates a filename for blob URLs
  static String _generateBlobFilename() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'uploaded_image_$timestamp.jpg';
  }

  /// Generates a filename for data URLs based on MIME type
  static String _generateDataUrlFilename(String dataUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Extract MIME type from data URL
    if (dataUrl.contains('image/png')) {
      return 'uploaded_image_$timestamp.png';
    } else if (dataUrl.contains('image/gif')) {
      return 'uploaded_image_$timestamp.gif';
    } else if (dataUrl.contains('image/webp')) {
      return 'uploaded_image_$timestamp.webp';
    } else {
      // Default to JPEG for other image types
      return 'uploaded_image_$timestamp.jpg';
    }
  }

  /// Generates a default filename when extraction fails
  static String _generateDefaultFilename() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'uploaded_image_$timestamp.jpg';
  }

  /// Checks if a filename has a valid image extension
  static bool _hasValidExtension(String filename) {
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];

    final lowerFilename = filename.toLowerCase();
    return validExtensions.any((ext) => lowerFilename.endsWith(ext));
  }

  /// Validates if a filename is suitable for API upload
  ///
  /// [filename] - The filename to validate
  ///
  /// Returns true if the filename is valid for API operations
  static bool isValidFilename(String? filename) {
    if (filename == null || filename.trim().isEmpty) {
      return false;
    }

    final trimmed = filename.trim();

    // Check for reasonable length (not too short or too long)
    if (trimmed.length < 5 || trimmed.length > 255) {
      return false;
    }

    // Check for valid extension
    if (!_hasValidExtension(trimmed)) {
      return false;
    }

    return true;
  }

  /// Creates a BarcodeResultFileModel with proper filename extraction
  ///
  /// [url] - The image URL
  /// [existingFilename] - Optional existing filename to preserve
  ///
  /// Returns a BarcodeResultFileModel with guaranteed filename
  static Map<String, dynamic> createFileModelData({
    required String url,
    String? existingFilename,
  }) {
    // Use existing filename if valid, otherwise extract/generate one
    final filename =
        isValidFilename(existingFilename)
            ? existingFilename!
            : extractFilename(url);

    log(
      '[FilenameExtractor] Created file model data: url=$url, filename=$filename',
    );

    return {'url': url, 'fileName': filename};
  }
}
