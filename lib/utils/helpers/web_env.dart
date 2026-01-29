import 'dart:js' as js;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebEnv {
  static String getEnv(String key) {
    // First, try to access the window.__ENV__ object we injected in server.js
    final env = js.context['__ENV__'];
    if (env != null) {
      final value = env[key]?.toString();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    // Fallback to flutter_dotenv if window.__ENV__ is not available
    return dotenv.env[key] ?? '';
  }
}
