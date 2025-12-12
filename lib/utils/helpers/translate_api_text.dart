class TranslateApiTextHelper {
  static String translate(String rawText, {required String locale}) {
    if (rawText.isEmpty) return '';

    // If text doesn't contain any locale tags, return as-is (plain English)
    if (!rawText.contains('<') || !rawText.contains('>')) {
      return rawText;
    }

    String lang = '';
    switch (locale) {
      case 'en_US':
        lang = 'en-US';
        break;
      case 'pt_pt':
        lang = 'pt';
        break;
      case 'es_es':
        lang = 'es';
        break;
      case 'fr_fr':
        lang = 'fr';
        break;
      case 'de_de':
        lang = 'de';
        break;
      default:
        lang = locale;
        break;
    }

    // Try to extract text for the requested locale
    final startTag = '<$lang>';
    final endTag = '</$lang>';
    
    if (rawText.contains(startTag) && rawText.contains(endTag)) {
      final startIndex = rawText.indexOf(startTag) + startTag.length;
      final endIndex = rawText.indexOf(endTag, startIndex);
      if (endIndex > startIndex) {
        return rawText.substring(startIndex, endIndex);
      }
    }

    // Fallback: try to extract English text
    const fallbackStartTag = '<en-US>';
    const fallbackEndTag = '</en-US>';
    
    if (rawText.contains(fallbackStartTag) && rawText.contains(fallbackEndTag)) {
      final startIndex = rawText.indexOf(fallbackStartTag) + fallbackStartTag.length;
      final endIndex = rawText.indexOf(fallbackEndTag, startIndex);
      if (endIndex > startIndex) {
        return rawText.substring(startIndex, endIndex);
      }
    }

    // Last fallback: return the raw text (in case format is different)
    return rawText;
  }
}
