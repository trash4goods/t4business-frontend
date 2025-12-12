import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode_upload.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode_update_upload_file.dart';
import 'package:t4g_for_business/features/product_managment/data/transformers/barcode_model_transformer.dart';
import 'package:t4g_for_business/features/product_managment/utils/image_base64_converter.dart';

import 'barcode_model_transformer_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('BarcodeModelTransformer', () {
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      ImageBase64Converter.setHttpClient(mockHttpClient);
    });

    tearDown(() {
      ImageBase64Converter.setHttpClient(null);
    });

    group('toUploadModel', () {
      test(
        'should convert BarcodeResultModel to BarcodeUploadModel with all fields',
        () {
          // Arrange
          final source = BarcodeResultModel(
            id: 1,
            name: 'Test Product',
            code: '123456789',
            brand: 'Test Brand',
            ecoGrade: 'A',
            co2Packaging: 1.5,
            mainMaterial: 'Plastic',
            instructions: 'Test instructions',
            trashType: 'Recyclable',
            files: [],
          );

          // Act
          final result = BarcodeModelTransformer.toUploadModel(source);

          // Assert
          expect(result.name, equals('Test Product'));
          expect(result.code, equals('123456789'));
          expect(result.brand, equals('Test Brand'));
          expect(result.ecoGrade, equals('A'));
          expect(result.co2Packaging, equals(1.5));
          expect(result.mainMaterial, equals('Plastic'));
          expect(result.instructions, equals('Test instructions'));
          expect(result.trashType, equals('Recyclable'));
          expect(result.deleteFile, equals('False'));
          expect(result.uploadFiles, isEmpty);
        },
      );

      test('should handle null fields correctly', () {
        // Arrange
        final source = BarcodeResultModel();

        // Act
        final result = BarcodeModelTransformer.toUploadModel(source);

        // Assert
        expect(result.name, isNull);
        expect(result.code, isNull);
        expect(result.brand, isNull);
        expect(result.ecoGrade, isNull);
        expect(result.co2Packaging, isNull);
        expect(result.mainMaterial, isNull);
        expect(result.instructions, isNull);
        expect(result.trashType, isNull);
        expect(result.deleteFile, equals('False'));
        expect(result.uploadFiles, isEmpty);
      });

      test('should set deleteFile to True when deleteFiles is true', () {
        // Arrange
        final source = BarcodeResultModel(name: 'Test');

        // Act
        final result = BarcodeModelTransformer.toUploadModel(
          source,
          deleteFiles: true,
        );

        // Assert
        expect(result.deleteFile, equals('True'));
      });

      test('should set deleteFile to False when deleteFiles is false', () {
        // Arrange
        final source = BarcodeResultModel(name: 'Test');

        // Act
        final result = BarcodeModelTransformer.toUploadModel(
          source,
          deleteFiles: false,
        );

        // Assert
        expect(result.deleteFile, equals('False'));
      });
    });

    group('toUploadModelWithBase64Images', () {
      test(
        'should convert model without images when files list is empty',
        () async {
          // Arrange
          final source = BarcodeResultModel(
            name: 'Test Product',
            code: '123456789',
            files: [],
          );

          // Act
          final result =
              await BarcodeModelTransformer.toUploadModelWithBase64Images(
                source,
              );

          // Assert
          expect(result.name, equals('Test Product'));
          expect(result.code, equals('123456789'));
          expect(result.deleteFile, equals('False'));
          expect(result.uploadFiles, isEmpty);
        },
      );

      test(
        'should convert model without images when files list is null',
        () async {
          // Arrange
          final source = BarcodeResultModel(
            name: 'Test Product',
            code: '123456789',
            files: null,
          );

          // Act
          final result =
              await BarcodeModelTransformer.toUploadModelWithBase64Images(
                source,
              );

          // Assert
          expect(result.name, equals('Test Product'));
          expect(result.code, equals('123456789'));
          expect(result.deleteFile, equals('False'));
          expect(result.uploadFiles, isEmpty);
        },
      );

      test('should convert images to base64 when files exist', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            fileName: 'test1.jpg',
            url: 'https://example.com/test1.jpg',
          ),
          BarcodeResultFileModel(
            fileName: 'test2.png',
            url: 'https://example.com/test2.png',
          ),
        ];

        final source = BarcodeResultModel(name: 'Test Product', files: files);

        // Mock HTTP responses
        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/test1.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'fake-image-data-1',
            200,
            headers: {'content-type': 'image/jpeg'},
          ),
        );

        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/test2.png'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'fake-image-data-2',
            200,
            headers: {'content-type': 'image/png'},
          ),
        );

        // Act
        final result =
            await BarcodeModelTransformer.toUploadModelWithBase64Images(source);

        // Assert
        expect(result.name, equals('Test Product'));
        expect(result.deleteFile, equals('False'));
        expect(result.uploadFiles, hasLength(2));
        expect(result.uploadFiles![0].name, equals('test1.jpg'));
        expect(
          result.uploadFiles![0].base64,
          startsWith('data:image/jpeg;base64,'),
        );
        expect(result.uploadFiles![1].name, equals('test2.png'));
        expect(
          result.uploadFiles![1].base64,
          startsWith('data:image/png;base64,'),
        );
      });

      test('should handle image conversion errors gracefully', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            fileName: 'test1.jpg',
            url: 'https://example.com/test1.jpg',
          ),
        ];

        final source = BarcodeResultModel(name: 'Test Product', files: files);

        // Mock HTTP error
        when(
          mockHttpClient.get(
            Uri.parse('https://example.com/test1.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act
        final result =
            await BarcodeModelTransformer.toUploadModelWithBase64Images(source);

        // Assert
        expect(result.name, equals('Test Product'));
        expect(result.deleteFile, equals('False'));
        expect(
          result.uploadFiles,
          isEmpty,
        ); // Should be empty due to conversion error
      });

      test('should not process images when deleteFiles is true', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            fileName: 'test1.jpg',
            url: 'https://example.com/test1.jpg',
          ),
        ];

        final source = BarcodeResultModel(name: 'Test Product', files: files);

        // Act
        final result =
            await BarcodeModelTransformer.toUploadModelWithBase64Images(
              source,
              deleteFiles: true,
            );

        // Assert
        expect(result.name, equals('Test Product'));
        expect(result.deleteFile, equals('True'));
        expect(result.uploadFiles, isEmpty);
        verifyNever(mockHttpClient.get(any, headers: anyNamed('headers')));
      });
    });

    group('isValidForUpdate', () {
      test('should return true for valid model with required fields', () {
        // Arrange
        final source = BarcodeResultModel(
          name: 'Test Product',
          code: '123456789',
        );

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isTrue);
      });

      test('should return false when name is null', () {
        // Arrange
        final source = BarcodeResultModel(name: null, code: '123456789');

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when name is empty', () {
        // Arrange
        final source = BarcodeResultModel(name: '', code: '123456789');

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when name is whitespace only', () {
        // Arrange
        final source = BarcodeResultModel(name: '   ', code: '123456789');

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when code is null', () {
        // Arrange
        final source = BarcodeResultModel(name: 'Test Product', code: null);

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when code is empty', () {
        // Arrange
        final source = BarcodeResultModel(name: 'Test Product', code: '');

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when code is whitespace only', () {
        // Arrange
        final source = BarcodeResultModel(name: 'Test Product', code: '   ');

        // Act
        final result = BarcodeModelTransformer.isValidForUpdate(source);

        // Assert
        expect(result, isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        // Arrange
        final source = BarcodeResultModel(
          id: 1,
          name: 'Original Name',
          code: 'Original Code',
          brand: 'Original Brand',
          ecoGrade: 'B',
          co2Packaging: 1.0,
          mainMaterial: 'Original Material',
          instructions: 'Original Instructions',
          trashType: 'Original Type',
        );

        // Act
        final result = BarcodeModelTransformer.copyWith(
          source,
          name: 'Updated Name',
          ecoGrade: 'A',
          co2Packaging: 2.0,
        );

        // Assert
        expect(result.id, equals(1)); // Preserved
        expect(result.name, equals('Updated Name')); // Updated
        expect(result.code, equals('Original Code')); // Preserved
        expect(result.brand, equals('Original Brand')); // Preserved
        expect(result.ecoGrade, equals('A')); // Updated
        expect(result.co2Packaging, equals(2.0)); // Updated
        expect(result.mainMaterial, equals('Original Material')); // Preserved
        expect(
          result.instructions,
          equals('Original Instructions'),
        ); // Preserved
        expect(result.trashType, equals('Original Type')); // Preserved
        expect(result.files, equals(source.files)); // Preserved
      });

      test('should preserve all fields when no updates provided', () {
        // Arrange
        final source = BarcodeResultModel(
          id: 1,
          name: 'Test Name',
          code: 'Test Code',
          brand: 'Test Brand',
        );

        // Act
        final result = BarcodeModelTransformer.copyWith(source);

        // Assert
        expect(result.id, equals(source.id));
        expect(result.name, equals(source.name));
        expect(result.code, equals(source.code));
        expect(result.brand, equals(source.brand));
        expect(result.ecoGrade, equals(source.ecoGrade));
        expect(result.co2Packaging, equals(source.co2Packaging));
        expect(result.mainMaterial, equals(source.mainMaterial));
        expect(result.instructions, equals(source.instructions));
        expect(result.trashType, equals(source.trashType));
        expect(result.files, equals(source.files));
      });
    });
  });
}
