import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/utils/image_base64_converter.dart';

import 'image_base64_converter_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ImageBase64Converter', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      ImageBase64Converter.setHttpClient(mockClient);
    });

    tearDown(() {
      ImageBase64Converter.setHttpClient(null);
    });

    group('urlToBase64', () {
      test('should convert valid image URL to base64', () async {
        // Arrange
        const imageUrl = 'https://example.com/image.jpg';
        final imageBytes = Uint8List.fromList([137, 80, 78, 71]); // PNG header
        final response = http.Response.bytes(
          imageBytes,
          200,
          headers: {'content-type': 'image/jpeg'},
        );

        when(
          mockClient.get(Uri.parse(imageUrl), headers: anyNamed('headers')),
        ).thenAnswer((_) async => response);

        // Act
        final result = await ImageBase64Converter.urlToBase64(imageUrl);

        // Assert
        expect(result, startsWith('data:image/jpeg;base64,'));
        expect(result, contains(base64Encode(imageBytes)));
      });

      test(
        'should throw ImageConversionException for invalid URL format',
        () async {
          // Arrange
          const invalidUrl = 'not-a-valid-url';

          // Act & Assert
          expect(
            () => ImageBase64Converter.urlToBase64(invalidUrl),
            throwsA(isA<ImageConversionException>()),
          );
        },
      );

      test(
        'should throw ImageConversionException for unsupported file extension',
        () async {
          // Arrange
          const unsupportedUrl = 'https://example.com/file.txt';

          // Act & Assert
          expect(
            () => ImageBase64Converter.urlToBase64(unsupportedUrl),
            throwsA(isA<ImageConversionException>()),
          );
        },
      );

      test(
        'should throw ImageConversionException for HTTP error status',
        () async {
          // Arrange
          const imageUrl = 'https://example.com/image.jpg';
          final response = http.Response('Not Found', 404);

          when(
            mockClient.get(Uri.parse(imageUrl), headers: anyNamed('headers')),
          ).thenAnswer((_) async => response);

          // Act & Assert
          expect(
            () => ImageBase64Converter.urlToBase64(imageUrl),
            throwsA(isA<ImageConversionException>()),
          );
        },
      );

      test(
        'should throw ImageConversionException for unsupported content type',
        () async {
          // Arrange
          const imageUrl = 'https://example.com/image.jpg';
          final imageBytes = Uint8List.fromList([1, 2, 3, 4]);
          final response = http.Response.bytes(
            imageBytes,
            200,
            headers: {'content-type': 'text/plain'},
          );

          when(
            mockClient.get(Uri.parse(imageUrl), headers: anyNamed('headers')),
          ).thenAnswer((_) async => response);

          // Act & Assert
          expect(
            () => ImageBase64Converter.urlToBase64(imageUrl),
            throwsA(isA<ImageConversionException>()),
          );
        },
      );

      test(
        'should throw ImageConversionException for oversized image',
        () async {
          // Arrange
          const imageUrl = 'https://example.com/image.jpg';
          // Create a large byte array (11MB)
          final largeImageBytes = Uint8List(11 * 1024 * 1024);
          final response = http.Response.bytes(
            largeImageBytes,
            200,
            headers: {'content-type': 'image/jpeg'},
          );

          when(
            mockClient.get(Uri.parse(imageUrl), headers: anyNamed('headers')),
          ).thenAnswer((_) async => response);

          // Act & Assert
          expect(
            () => ImageBase64Converter.urlToBase64(imageUrl),
            throwsA(isA<ImageConversionException>()),
          );
        },
      );
    });

    group('convertImagesToBase64', () {
      test('should convert list of valid files to base64', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            url: 'https://example.com/image1.jpg',
            fileName: 'image1.jpg',
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: 'https://example.com/image2.png',
            fileName: 'image2.png',
            mimeType: 'image/png',
          ),
        ];

        final imageBytes = Uint8List.fromList([137, 80, 78, 71]);
        final response = http.Response.bytes(
          imageBytes,
          200,
          headers: {'content-type': 'image/jpeg'},
        );

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => response);

        // Act
        final result = await ImageBase64Converter.convertImagesToBase64(files);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].name, equals('image1.jpg'));
        expect(result[0].base64, startsWith('data:image/jpeg;base64,'));
        expect(result[1].name, equals('image2.png'));
        expect(result[1].base64, startsWith('data:image/jpeg;base64,'));
      });

      test('should skip files with null or empty URL', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            url: null,
            fileName: 'image1.jpg',
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: '',
            fileName: 'image2.jpg',
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: 'https://example.com/image3.jpg',
            fileName: 'image3.jpg',
            mimeType: 'image/jpeg',
          ),
        ];

        final imageBytes = Uint8List.fromList([137, 80, 78, 71]);
        final response = http.Response.bytes(
          imageBytes,
          200,
          headers: {'content-type': 'image/jpeg'},
        );

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => response);

        // Act
        final result = await ImageBase64Converter.convertImagesToBase64(files);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].name, equals('image3.jpg'));
      });

      test('should skip files with null or empty filename', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            url: 'https://example.com/image1.jpg',
            fileName: null,
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: 'https://example.com/image2.jpg',
            fileName: '',
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: 'https://example.com/image3.jpg',
            fileName: 'image3.jpg',
            mimeType: 'image/jpeg',
          ),
        ];

        final imageBytes = Uint8List.fromList([137, 80, 78, 71]);
        final response = http.Response.bytes(
          imageBytes,
          200,
          headers: {'content-type': 'image/jpeg'},
        );

        when(
          mockClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => response);

        // Act
        final result = await ImageBase64Converter.convertImagesToBase64(files);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].name, equals('image3.jpg'));
      });

      test('should continue processing other files when one fails', () async {
        // Arrange
        final files = [
          BarcodeResultFileModel(
            url: 'https://example.com/invalid.jpg',
            fileName: 'invalid.jpg',
            mimeType: 'image/jpeg',
          ),
          BarcodeResultFileModel(
            url: 'https://example.com/valid.jpg',
            fileName: 'valid.jpg',
            mimeType: 'image/jpeg',
          ),
        ];

        final imageBytes = Uint8List.fromList([137, 80, 78, 71]);
        final validResponse = http.Response.bytes(
          imageBytes,
          200,
          headers: {'content-type': 'image/jpeg'},
        );
        final invalidResponse = http.Response('Not Found', 404);

        when(
          mockClient.get(
            Uri.parse('https://example.com/invalid.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => invalidResponse);

        when(
          mockClient.get(
            Uri.parse('https://example.com/valid.jpg'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => validResponse);

        // Act
        final result = await ImageBase64Converter.convertImagesToBase64(files);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].name, equals('valid.jpg'));
      });

      test('should return empty list for empty input', () async {
        // Arrange
        final files = <BarcodeResultFileModel>[];

        // Act
        final result = await ImageBase64Converter.convertImagesToBase64(files);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('validation methods', () {
      test('isSupportedMimeType should validate MIME types correctly', () {
        expect(ImageBase64Converter.isSupportedMimeType('image/jpeg'), isTrue);
        expect(ImageBase64Converter.isSupportedMimeType('image/png'), isTrue);
        expect(ImageBase64Converter.isSupportedMimeType('image/gif'), isTrue);
        expect(ImageBase64Converter.isSupportedMimeType('image/webp'), isTrue);
        expect(ImageBase64Converter.isSupportedMimeType('image/bmp'), isTrue);
        expect(ImageBase64Converter.isSupportedMimeType('text/plain'), isFalse);
        expect(ImageBase64Converter.isSupportedMimeType(null), isFalse);
      });

      test('supportedMimeTypes should return immutable list', () {
        final mimeTypes = ImageBase64Converter.supportedMimeTypes;
        expect(mimeTypes, contains('image/jpeg'));
        expect(mimeTypes, contains('image/png'));
        expect(() => mimeTypes.add('new/type'), throwsUnsupportedError);
      });

      test('supportedExtensions should return immutable list', () {
        final extensions = ImageBase64Converter.supportedExtensions;
        expect(extensions, contains('.jpg'));
        expect(extensions, contains('.png'));
        expect(() => extensions.add('.new'), throwsUnsupportedError);
      });
    });
  });

  group('ImageConversionException', () {
    test('should create exception with message', () {
      const message = 'Test error message';
      final exception = ImageConversionException(message);

      expect(exception.message, equals(message));
      expect(
        exception.toString(),
        equals('ImageConversionException: $message'),
      );
    });
  });
}
