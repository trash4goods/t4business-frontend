import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/data/transformers/barcode_model_transformer.dart';
import 'package:t4g_for_business/features/product_managment/utils/image_base64_converter.dart';

import 'barcode_model_transformer_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('BarcodeModelTransformer Integration Tests', () {
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      ImageBase64Converter.setHttpClient(mockHttpClient);
    });

    tearDown(() {
      ImageBase64Converter.setHttpClient(null);
    });

    test(
      'should handle complete product update transformation with real images',
      () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            fileName: 'product_image_1.jpg',
            url: 'https://example.com/images/product1.jpg',
            mimeType: 'image/jpeg',
            size: 1024,
          ),
          BarcodeResultFileModel(
            fileName: 'product_image_2.png',
            url: 'https://example.com/images/product2.png',
            mimeType: 'image/png',
            size: 2048,
          ),
        ];

        final source = BarcodeResultModel(
          id: 123,
          name: 'Eco-Friendly Water Bottle',
          code: '1234567890123',
          brand: 'EcoBottle Co.',
          ecoGrade: 'A+',
          co2Packaging: 0.5,
          mainMaterial: 'Recycled Plastic',
          instructions: 'Rinse before recycling',
          trashType: 'Recyclable',
          files: files,
        );

        // Mock HTTP responses for image downloads
        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/images/product1.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'fake-jpeg-image-data',
            200,
            headers: {'content-type': 'image/jpeg'},
          ),
        );

        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/images/product2.png'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'fake-png-image-data',
            200,
            headers: {'content-type': 'image/png'},
          ),
        );

        // Act
        final result =
            await BarcodeModelTransformer.toUploadModelWithBase64Images(source);

        // Assert - Verify field mapping
        expect(result.name, equals('Eco-Friendly Water Bottle'));
        expect(result.code, equals('1234567890123'));
        expect(result.brand, equals('EcoBottle Co.'));
        expect(result.ecoGrade, equals('A+'));
        expect(result.co2Packaging, equals(0.5));
        expect(result.mainMaterial, equals('Recycled Plastic'));
        expect(result.instructions, equals('Rinse before recycling'));
        expect(result.trashType, equals('Recyclable'));
        expect(result.deleteFile, equals('False'));

        // Assert - Verify image conversion
        expect(result.uploadFiles, hasLength(2));

        final firstFile = result.uploadFiles![0];
        expect(firstFile.name, equals('product_image_1.jpg'));
        expect(firstFile.base64, startsWith('data:image/jpeg;base64,'));
        expect(
          firstFile.base64,
          contains('ZmFrZS1qcGVnLWltYWdlLWRhdGE='),
        ); // base64 of 'fake-jpeg-image-data'

        final secondFile = result.uploadFiles![1];
        expect(secondFile.name, equals('product_image_2.png'));
        expect(secondFile.base64, startsWith('data:image/png;base64,'));
        expect(
          secondFile.base64,
          contains('ZmFrZS1wbmctaW1hZ2UtZGF0YQ=='),
        ); // base64 of 'fake-png-image-data'

        // Verify HTTP calls were made
        verify(
          mockHttpClient.get(
            Uri.parse('https://example.com/images/product1.jpg'),
            headers: anyNamed('headers'),
          ),
        ).called(1);

        verify(
          mockHttpClient.get(
            Uri.parse('https://example.com/images/product2.png'),
            headers: anyNamed('headers'),
          ),
        ).called(1);
      },
    );

    test(
      'should handle mixed success and failure scenarios gracefully',
      () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            fileName: 'valid_image.jpg',
            url: 'https://example.com/valid.jpg',
          ),
          BarcodeResultFileModel(
            fileName: 'invalid_image.jpg',
            url: 'https://example.com/invalid.jpg',
          ),
          BarcodeResultFileModel(
            fileName: 'another_valid.png',
            url: 'https://example.com/valid.png',
          ),
        ];

        final source = BarcodeResultModel(
          name: 'Test Product',
          code: '123',
          files: files,
        );

        // Mock responses - one success, one failure, one success
        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/valid.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'valid-image-data',
            200,
            headers: {'content-type': 'image/jpeg'},
          ),
        );

        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/invalid.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenThrow(Exception('Network error'));

        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/valid.png'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'another-valid-image',
            200,
            headers: {'content-type': 'image/png'},
          ),
        );

        // Act
        final result =
            await BarcodeModelTransformer.toUploadModelWithBase64Images(source);

        // Assert - Should only include successful conversions
        expect(result.name, equals('Test Product'));
        expect(result.code, equals('123'));
        expect(
          result.uploadFiles,
          hasLength(2),
        ); // Only 2 successful conversions

        expect(result.uploadFiles![0].name, equals('valid_image.jpg'));
        expect(
          result.uploadFiles![0].base64,
          startsWith('data:image/jpeg;base64,'),
        );

        expect(result.uploadFiles![1].name, equals('another_valid.png'));
        expect(
          result.uploadFiles![1].base64,
          startsWith('data:image/png;base64,'),
        );
      },
    );

    test('should validate model before transformation', () {
      // Arrange - Invalid model (missing required fields)
      final invalidSource = BarcodeResultModel(
        brand: 'Some Brand',
        ecoGrade: 'A',
        // Missing name and code
      );

      // Act & Assert
      expect(BarcodeModelTransformer.isValidForUpdate(invalidSource), isFalse);

      // Arrange - Valid model
      final validSource = BarcodeResultModel(
        name: 'Valid Product',
        code: '123456789',
        brand: 'Some Brand',
      );

      // Act & Assert
      expect(BarcodeModelTransformer.isValidForUpdate(validSource), isTrue);
    });

    test('should handle copyWith functionality for model updates', () {
      // Arrange
      final original = BarcodeResultModel(
        id: 1,
        name: 'Original Product',
        code: '111111111',
        brand: 'Original Brand',
        ecoGrade: 'B',
        co2Packaging: 1.0,
      );

      // Act
      final updated = BarcodeModelTransformer.copyWith(
        original,
        name: 'Updated Product',
        ecoGrade: 'A+',
        co2Packaging: 0.5,
      );

      // Assert
      expect(updated.id, equals(1)); // Preserved
      expect(updated.name, equals('Updated Product')); // Updated
      expect(updated.code, equals('111111111')); // Preserved
      expect(updated.brand, equals('Original Brand')); // Preserved
      expect(updated.ecoGrade, equals('A+')); // Updated
      expect(updated.co2Packaging, equals(0.5)); // Updated
    });
  });
}
