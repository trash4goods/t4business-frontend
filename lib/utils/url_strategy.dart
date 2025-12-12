import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Configure URL strategy for Flutter web
/// This removes the "#" from URLs by using path-based routing
void configureUrlStrategy() {
  if (kIsWeb) {
    // Use path-based routing instead of hash-based routing
    // This removes the "#" from URLs
    usePathUrlStrategy();
  }
}
