import '../data/models/upload_file_model.dart';

/// Validation helper for product management operations
/// Contains input validation logic that should be used in the presentation layer
class ProductValidationHelper {
  ProductValidationHelper._(); // Private constructor to prevent instantiation

  /// Validates authentication token
  static String? validateToken(String? token) {
    if (token == null || token.trim().isEmpty) {
      return 'Authentication token is required';
    }
    return null;
  }

  /// Validates product name
  static String? validateProductName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Product name is required';
    }
    if (name.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    if (name.trim().length > 100) {
      return 'Product name must not exceed 100 characters';
    }
    return null;
  }

  /// Validates product code
  static String? validateProductCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return 'Product code is required';
    }
    if (code.trim().length < 2) {
      return 'Product code must be at least 2 characters';
    }
    if (code.trim().length > 50) {
      return 'Product code must not exceed 50 characters';
    }
    // Check for valid characters (alphanumeric, hyphens, underscores)
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(code.trim())) {
      return 'Product code can only contain letters, numbers, hyphens, and underscores';
    }
    return null;
  }

  /// Validates product ID
  static String? validateProductId(String? id) {
    if (id == null || id.trim().isEmpty) {
      return 'Product ID is required';
    }
    return null;
  }

  /// Validates pagination parameters
  static String? validatePerPage(int? perPage) {
    if (perPage == null) {
      return 'Items per page is required';
    }
    if (perPage <= 0) {
      return 'Items per page must be greater than 0';
    }
    if (perPage > 100) {
      return 'Items per page must not exceed 100';
    }
    return null;
  }

  /// Validates page number
  static String? validatePage(int? page) {
    if (page == null) {
      return 'Page number is required';
    }
    if (page <= 0) {
      return 'Page number must be greater than 0';
    }
    return null;
  }

  /// Validates image upload files
  static String? validateImageUpload(List<UploadFileModel>? uploadFiles) {
    if (uploadFiles == null || uploadFiles.isEmpty) {
      return null; // Images are optional
    }

    // Validate maximum image count
    if (uploadFiles.length > 10) {
      return 'Maximum 10 images allowed';
    }

    // Validate each file
    for (int i = 0; i < uploadFiles.length; i++) {
      final file = uploadFiles[i];

      // Each file must have either base64 data or URL
      if ((file.base64?.trim().isEmpty ?? true) &&
          (file.url?.trim().isEmpty ?? true)) {
        return 'Image ${i + 1}: Each upload file must have either base64 data or URL';
      }

      // Each file must have a name
      if (file.name?.trim().isEmpty ?? true) {
        return 'Image ${i + 1}: Each upload file must have a name';
      }

      // Validate file name format
      if (file.name != null && file.name!.isNotEmpty) {
        if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(file.name!)) {
          return 'Image ${i + 1}: File name can only contain letters, numbers, dots, hyphens, and underscores';
        }
      }

      // Validate URL format if provided
      if (file.url != null && file.url!.isNotEmpty) {
        final uri = Uri.tryParse(file.url!);
        if (uri == null || !uri.hasScheme || (!uri.scheme.startsWith('http'))) {
          return 'Image ${i + 1}: Invalid URL format';
        }
      }

      // Validate base64 format if provided (basic check)
      if (file.base64 != null && file.base64!.isNotEmpty) {
        if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(file.base64!)) {
          return 'Image ${i + 1}: Invalid base64 format';
        }
      }

      // Validate MIME type if provided
      if (file.mimeType != null && file.mimeType!.isNotEmpty) {
        if (!file.mimeType!.startsWith('image/')) {
          return 'Image ${i + 1}: Only image files are allowed';
        }
      }
    }

    return null;
  }

  /// Validates all required fields for creating a product
  static List<String> validateCreateProduct({
    required String? token,
    required String? name,
    required String? code,
    List<UploadFileModel>? uploadFiles,
  }) {
    final errors = <String>[];

    final tokenError = validateToken(token);
    if (tokenError != null) errors.add(tokenError);

    final nameError = validateProductName(name);
    if (nameError != null) errors.add(nameError);

    final codeError = validateProductCode(code);
    if (codeError != null) errors.add(codeError);

    final imageError = validateImageUpload(uploadFiles);
    if (imageError != null) errors.add(imageError);

    return errors;
  }

  /// Validates all required fields for updating a product
  static List<String> validateUpdateProduct({
    required String? token,
    required String? id,
    List<UploadFileModel>? uploadFiles,
  }) {
    final errors = <String>[];

    final tokenError = validateToken(token);
    if (tokenError != null) errors.add(tokenError);

    final idError = validateProductId(id);
    if (idError != null) errors.add(idError);

    final imageError = validateImageUpload(uploadFiles);
    if (imageError != null) errors.add(imageError);

    return errors;
  }

  /// Validates all required fields for deleting a product
  static List<String> validateDeleteProduct({
    required String? token,
    required String? id,
  }) {
    final errors = <String>[];

    final tokenError = validateToken(token);
    if (tokenError != null) errors.add(tokenError);

    final idError = validateProductId(id);
    if (idError != null) errors.add(idError);

    return errors;
  }

  /// Validates pagination parameters for getting products
  static List<String> validateGetProducts({
    required String? token,
    int? perPage,
    int? page,
  }) {
    final errors = <String>[];

    final tokenError = validateToken(token);
    if (tokenError != null) errors.add(tokenError);

    if (perPage != null) {
      final perPageError = validatePerPage(perPage);
      if (perPageError != null) errors.add(perPageError);
    }

    if (page != null) {
      final pageError = validatePage(page);
      if (pageError != null) errors.add(pageError);
    }

    return errors;
  }
}
