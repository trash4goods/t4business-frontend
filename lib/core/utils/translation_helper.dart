class BackendTranslationHelper {
  static String translate(String text, {String? locale}) {
    return text; // Simple mock implementation
  }
}

String translate(String key) {
  switch (key) {
    case 'scan_product.product_details.how_to_recycle':
      return 'How to recycle';
    default:
      return key;
  }
}