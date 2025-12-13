import 'dart:js' as js;

class WebEnv {
  static String getEnv(String key) {
    // Access the window.__ENV__ object we injected in server.js
    final env = js.context['__ENV__'];
    if (env == null) return '';

    return env[key]?.toString() ?? '';
  }
}
