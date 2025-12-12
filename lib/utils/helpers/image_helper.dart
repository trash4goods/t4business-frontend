import 'package:flutter/services.dart';

class ImageHelper {
  /// Converts an asset to Uint8List
  static Future<Uint8List> getBytesFromAsset(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    return Uint8List.view(byteData.buffer);
  }
}
