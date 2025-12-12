import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/data/transformers/barcode_model_transformer.dart';

void main() {
  group('Create Product Fix Integration Test', () {
    test(
      'should validate that BarcodeModelTransformer works for create operations',
      () async {
        // Arrange
        final inputProduct = BarcodeResultModel(
          name: 'Test Product',
          code: '1234567890123',
          brand: 'Test Brand',
          instructions: 'Test instructions',
          trashType: 'plastic',
          files: [
            BarcodeResultFileModel(
              url: 'https://example.com/image.jpg',
              fileName: 'image.jpg',
            ),
          ],
        );

        // Act - Test that the transformer can handle the product
        final isValid = BarcodeModelTransformer.isValidForUpdate(inputProduct);
        final uploadModel = BarcodeModelTransformer.toUploadModel(inputProduct);

        // Assert
        expect(isValid, isTrue);
        expect(uploadModel.name, equals('Test Product'));
        expect(uploadModel.code, equals('1234567890123'));
        expect(uploadModel.brand, equals('Test Brand'));
        expect(uploadModel.instructions, equals('Test instructions'));
        expect(uploadModel.trashType, equals('plastic'));
        expect(uploadModel.deleteFile, equals('False'));
        expect(
          uploadModel.uploadFiles,
          isEmpty,
        ); // No base64 conversion in this test
      },
    );

    test('should validate that invalid products are rejected', () {
      // Arrange
      final invalidProduct = BarcodeResultModel(
        name: null, // Invalid - name is required
        code: '1234567890123',
        brand: 'Test Brand',
        instructions: 'Test instructions',
        trashType: 'plastic',
      );

      // Act & Assert
      final isValid = BarcodeModelTransformer.isValidForUpdate(invalidProduct);
      expect(isValid, isFalse);
    });

    test('should handle products without images', () {
      // Arrange
      final inputProduct = BarcodeResultModel(
        name: 'Test Product No Images',
        code: '9876543210987',
        brand: 'Test Brand',
        instructions: 'Test instructions',
        trashType: 'glass',
        files: null, // No images
      );

      // Act
      final isValid = BarcodeModelTransformer.isValidForUpdate(inputProduct);
      final uploadModel = BarcodeModelTransformer.toUploadModel(inputProduct);

      // Assert
      expect(isValid, isTrue);
      expect(uploadModel.name, equals('Test Product No Images'));
      expect(uploadModel.uploadFiles, isEmpty);
    });
  });
}
