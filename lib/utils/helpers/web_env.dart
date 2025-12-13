// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class WebEnv {
  /// Retrieves the value of an environment variable defined in the web environment.
  ///
  /// This function accesses the global `__ENV__` object injected into the web
  /// page to fetch environment-specific configuration values.
  ///
  /// [key]: The name of the environment variable to retrieve.
  ///
  /// Returns the value of the environment variable as a [String]. If the variable
  /// is not found, it returns an empty string.
  static String getEnv(String key) {
    final env = (html.window as dynamic).__ENV__;
    return env != null ? env[key]?.toString() ?? '' : '';
  }
}
