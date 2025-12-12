import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/services/browser_history_service.dart';
import 'firebase_options.dart';
import 'utils/helpers/local_storage.dart';
import 'utils/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure URL strategy to remove "#" from URLs (path-based routing)
  configureUrlStrategy();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorageHelper.init();

  await Get.putAsync(() => AuthService().init());

  // Initialize browser history service for back button control
  Get.put(BrowserHistoryService());

  runApp(const App());
}
