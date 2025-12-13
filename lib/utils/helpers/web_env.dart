import 'dart:js' as js; // Use dart:js for better compatibility than dart:html

class WebEnv {
  static String getEnv(String key) {
    // 1. Try to get it from compile-time (useful for local development)
    const compileTimeValue = String.fromEnvironment('MY_KEY');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;

    // 2. Fallback: Try to get it from the injected window.__ENV__ (for Heroku)
    try {
      if (js.context.hasProperty('__ENV__')) {
        final env = js.context['__ENV__'];
        return env[key]?.toString() ?? '';
      }
    } catch (e) {
      print('Error accessing runtime env: $e');
    }

    return '';
  }
}
