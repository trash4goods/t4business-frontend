import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/product_managment/utils/filename_extractor.dart';

void main() {
  group('FilenameExtractor', () {
    group('extractFilename', () {
      test('should extract filename from regular URL', () {
        // Arrange
        const url = 'https://example.com/images/product.jpg';

        // Act
        final result = FilenameExtractor.extractFilename(url);

        // Assert
        expect(result, equals('product.jpg'));
      });

      test('should extract filename from URL with query parameters', () {
        // Arrange
        const url = 'https://example.com/images/product.png?v=123&size=large';

        // Act
        final result = FilenameExtractor.extractFilename(url);

        // Assert
        expect(result, equals('product.png'));
      });

      test('should generate filename for blob URL', () {
        // Arrange
        const url = 'blob:https://example.com/12345-abcde';

        // Act
        final result = FilenameExtractor.extractFilename(url);

        // Assert
        expect(result, startsWith('uploaded_image_'));
        expect(result, endsWith('.jpg'));
      });

      test('should generate filename for data URL with MIME type', () {
        // Arrange
        const url =
            'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==';

        // Act
        final result = FilenameExtractor.extractFilename(url);

        // Assert
        expect(result, startsWith('uploaded_image_'));
        expect(result, endsWith('.png'));
      });

      test('should generate default filename for invalid URL', () {
        // Arrange
        const url = 'invalid-url';

        // Act
        final result = FilenameExtractor.extractFilename(url);

        // Assert
        expect(result, startsWith('uploaded_image_'));
        expect(result, endsWith('.jpg'));
      });

      test('should extract filename from file path', () {
        // Arrange
        const path = '/Users/test/Documents/my-image.jpeg';

        // Act
        final result = FilenameExtractor.extractFilename(path);

        // Assert
        expect(result, equals('my-image.jpeg'));
      });
    });

    group('isValidFilename', () {
      test('should return true for valid filename', () {
        // Act & Assert
        expect(FilenameExtractor.isValidFilename('image.jpg'), isTrue);
        expect(FilenameExtractor.isValidFilename('product.png'), isTrue);
        expect(FilenameExtractor.isValidFilename('test-file.jpeg'), isTrue);
      });

      test('should return false for invalid filename', () {
        // Act & Assert
        expect(
          FilenameExtractor.isValidFilename(null),
          isFalse,
          reason: 'null should be invalid',
        );
        expect(
          FilenameExtractor.isValidFilename(''),
          isFalse,
          reason: 'empty string should be invalid',
        );
        expect(
          FilenameExtractor.isValidFilename('   '),
          isFalse,
          reason: 'whitespace should be invalid',
        );
        expect(
          FilenameExtractor.isValidFilename('file.txt'),
          isFalse,
          reason: '.txt extension should be invalid',
        );
        expect(
          FilenameExtractor.isValidFilename('a.jp'),
          isFalse,
          reason: 'too short filename should be invalid',
        );
      });
    });

    group('createFileModelData', () {
      test('should use existing filename if valid', () {
        // Arrange
        const url = 'https://example.com/image.jpg';
        const existingFilename = 'custom-name.png';

        // Act
        final result = FilenameExtractor.createFileModelData(
          url: url,
          existingFilename: existingFilename,
        );

        // Assert
        expect(result['url'], equals(url));
        expect(result['fileName'], equals(existingFilename));
      });

      test('should extract filename if existing filename is invalid', () {
        // Arrange
        const url = 'https://example.com/image.jpg';
        const invalidFilename = '';

        // Act
        final result = FilenameExtractor.createFileModelData(
          url: url,
          existingFilename: invalidFilename,
        );

        // Assert
        expect(result['url'], equals(url));
        expect(result['fileName'], equals('image.jpg'));
      });

      test('should generate filename if URL has no extractable filename', () {
        // Arrange
        const url = 'blob:https://example.com/12345';

        // Act
        final result = FilenameExtractor.createFileModelData(url: url);

        // Assert
        expect(result['url'], equals(url));
        expect(result['fileName'], startsWith('uploaded_image_'));
        expect(result['fileName'], endsWith('.jpg'));
      });
    });
  });
}
