import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/utils/image_base64_converter.dart';

void main() {
  group('ImageBase64Converter Integration Tests', () {
    test('should validate supported image formats', () {
      // Test MIME type validation
      expect(ImageBase64Converter.isSupportedMimeType('image/jpeg'), isTrue);
      expect(ImageBase64Converter.isSupportedMimeType('image/png'), isTrue);
      expect(ImageBase64Converter.isSupportedMimeType('image/gif'), isTrue);
      expect(ImageBase64Converter.isSupportedMimeType('image/webp'), isTrue);
      expect(ImageBase64Converter.isSupportedMimeType('image/bmp'), isTrue);
      expect(ImageBase64Converter.isSupportedMimeType('image/jpg'), isTrue);

      // Test unsupported formats
      expect(ImageBase64Converter.isSupportedMimeType('text/plain'), isFalse);
      expect(
        ImageBase64Converter.isSupportedMimeType('application/pdf'),
        isFalse,
      );
      expect(ImageBase64Converter.isSupportedMimeType('video/mp4'), isFalse);
      expect(ImageBase64Converter.isSupportedMimeType(null), isFalse);
    });

    test('should provide immutable lists of supported formats', () {
      final mimeTypes = ImageBase64Converter.supportedMimeTypes;
      final extensions = ImageBase64Converter.supportedExtensions;

      // Verify content
      expect(mimeTypes, contains('image/jpeg'));
      expect(mimeTypes, contains('image/png'));
      expect(extensions, contains('.jpg'));
      expect(extensions, contains('.png'));

      // Verify immutability
      expect(() => mimeTypes.add('new/type'), throwsUnsupportedError);
      expect(() => extensions.add('.new'), throwsUnsupportedError);
    });

    test('should handle empty file list gracefully', () async {
      final emptyFiles = <BarcodeResultFileModel>[];
      final result = await ImageBase64Converter.convertImagesToBase64(
        emptyFiles,
      );

      expect(result, isEmpty);
    });

    test('should validate URL formats correctly', () {
      // Valid URLs should not throw during validation (they would fail at HTTP level)
      expect(
        () => ImageBase64Converter.urlToBase64('https://example.com/image.jpg'),
        throwsA(
          isA<Exception>(),
        ), // Will fail at HTTP level, but URL format is valid
      );

      // Invalid URL formats should throw immediately
      expect(
        () => ImageBase64Converter.urlToBase64('not-a-url'),
        throwsA(isA<ImageConversionException>()),
      );

      expect(
        () => ImageBase64Converter.urlToBase64('ftp://example.com/image.jpg'),
        throwsA(isA<ImageConversionException>()),
      );
    });

    test('should validate file extensions correctly', () {
      // Supported extensions should pass validation
      expect(
        () => ImageBase64Converter.urlToBase64('https://example.com/image.jpg'),
        throwsA(
          isA<Exception>(),
        ), // Will fail at HTTP level, but extension is valid
      );

      // Unsupported extensions should fail immediately
      expect(
        () => ImageBase64Converter.urlToBase64('https://example.com/file.txt'),
        throwsA(isA<ImageConversionException>()),
      );

      expect(
        () => ImageBase64Converter.urlToBase64('https://example.com/video.mp4'),
        throwsA(isA<ImageConversionException>()),
      );
    });

    test('should create proper BarcodeResultFileModel instances', () {
      // Test that our models work correctly with the converter
      final file = BarcodeResultFileModel(
        url: 'https://example.com/image.jpg',
        fileName: 'test-image.jpg',
        mimeType: 'image/jpeg',
        id: 1,
        size: 1024,
      );

      expect(file.url, equals('https://example.com/image.jpg'));
      expect(file.fileName, equals('test-image.jpg'));
      expect(file.mimeType, equals('image/jpeg'));

      // Test with null values
      final fileWithNulls = BarcodeResultFileModel(
        url: null,
        fileName: null,
        mimeType: null,
      );

      expect(fileWithNulls.url, isNull);
      expect(fileWithNulls.fileName, isNull);
      expect(fileWithNulls.mimeType, isNull);
    });

    test('should handle ImageConversionException properly', () {
      const message = 'Test error message';
      final exception = ImageConversionException(message);

      expect(exception.message, equals(message));
      expect(exception.toString(), contains(message));
      expect(exception, isA<Exception>());
    });
  });
}
