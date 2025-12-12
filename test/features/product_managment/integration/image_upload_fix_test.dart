import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/utils/filename_extractor.dart';

void main() {
  group('Image Upload Fix Integration Test', () {
    test('should handle newly uploaded images without filenames', () {
      // Arrange - Simulate a newly uploaded image (like from file picker)
      const uploadedImageUrl = 'blob:https://localhost:3000/12345-abcde-67890';

      // Act - Create file model data using the utility
      final fileData = FilenameExtractor.createFileModelData(
        url: uploadedImageUrl,
      );
      final fileModel = BarcodeResultFileModel(
        url: fileData['url'],
        fileName: fileData['fileName'],
      );

      // Assert
      expect(fileModel.url, equals(uploadedImageUrl));
      expect(fileModel.fileName, isNotNull);
      expect(fileModel.fileName, isNotEmpty);
      expect(fileModel.fileName, startsWith('uploaded_image_'));
      expect(fileModel.fileName, endsWith('.jpg'));

      // Verify the filename is valid for the image converter
      expect(FilenameExtractor.isValidFilename(fileModel.fileName), isTrue);
    });

    test('should preserve existing API filenames', () {
      // Arrange - Simulate an existing image from API
      const apiImageUrl = 'https://api.example.com/images/product_123.png';
      const existingFilename = 'product_123.png';

      // Act - Create file model data preserving existing filename
      final fileData = FilenameExtractor.createFileModelData(
        url: apiImageUrl,
        existingFilename: existingFilename,
      );
      final fileModel = BarcodeResultFileModel(
        url: fileData['url'],
        fileName: fileData['fileName'],
      );

      // Assert
      expect(fileModel.url, equals(apiImageUrl));
      expect(fileModel.fileName, equals(existingFilename));

      // Verify the filename is valid for the image converter
      expect(FilenameExtractor.isValidFilename(fileModel.fileName), isTrue);
    });

    test('should handle mixed scenarios (existing + new images)', () {
      // Arrange - Mix of existing API images and new uploads
      final images = [
        // Existing API image
        BarcodeResultFileModel(
          url: 'https://api.example.com/images/existing.jpg',
          fileName: 'existing.jpg',
        ),
        // New upload without filename
        BarcodeResultFileModel(
          url: 'blob:https://localhost:3000/new-upload',
          fileName: null,
        ),
      ];

      // Act - Process images to ensure all have filenames
      final processedImages =
          images.map((image) {
            if (FilenameExtractor.isValidFilename(image.fileName)) {
              return image; // Keep existing
            } else {
              // Generate filename for new upload
              final fileData = FilenameExtractor.createFileModelData(
                url: image.url!,
              );
              return BarcodeResultFileModel(
                url: image.url,
                fileName: fileData['fileName'],
              );
            }
          }).toList();

      // Assert
      expect(processedImages.length, equals(2));

      // First image should keep original filename
      expect(processedImages[0].fileName, equals('existing.jpg'));

      // Second image should have generated filename
      expect(processedImages[1].fileName, isNotNull);
      expect(processedImages[1].fileName, startsWith('uploaded_image_'));

      // All should be valid for image converter
      for (final image in processedImages) {
        expect(FilenameExtractor.isValidFilename(image.fileName), isTrue);
      }
    });
  });
}
