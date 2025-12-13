import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:t4g_for_business/features/auth/data/datasources/auth_cache.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/department_model.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_profile_full_roles.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_profile_partners_departments.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_statistics_model.dart';
import 'package:t4g_for_business/utils/helpers/web_env.dart';

import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/services/browser_history_service.dart';
import 'core/services/pending_task_service.dart';
import 'features/auth/data/models/user_auth/created_by_model.dart';
import 'features/auth/data/models/user_auth/department_file_model.dart';
import 'features/auth/data/models/user_auth/month_statistics_model.dart';
import 'features/auth/data/models/user_auth/user_auth_model.dart';
import 'features/auth/data/models/user_auth/user_preferences_model.dart';
import 'features/auth/data/models/user_auth/user_profile_model.dart';
import 'features/auth/data/models/user_auth/year_statistics_model.dart';
import 'firebase_options.dart';
import 'utils/helpers/local_storage.dart';
import 'utils/url_strategy.dart';

void main() async {
  print("Main started");
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  if (kDebugMode) {
    await dotenv.load(fileName: ".env");
  }

  debugEnv();
  // Initialize Firebase
  // FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
  // await Firebase.initializeApp(options: options);

  // Configure URL strategy to remove "#" from URLs (path-based routing)
  configureUrlStrategy();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserAuthModelAdapter());
  Hive.registerAdapter(UserProfileModelAdapter());
  Hive.registerAdapter(UserProfileFullRolesModelAdapter());
  Hive.registerAdapter(UserPreferencesModelAdapter());
  Hive.registerAdapter(UserStatisticsModelAdapter());
  Hive.registerAdapter(UserPartnersDepartmentModelAdapter());
  Hive.registerAdapter(YearStatisticsModelAdapter());
  Hive.registerAdapter(MonthStatisticsModelAdapter());
  Hive.registerAdapter(DepartmentModelAdapter());
  Hive.registerAdapter(DepartmentFileModelAdapter());
  Hive.registerAdapter(CreatedByModelAdapter());

  // init auth cache
  await AuthCacheDataSource.instance.init();

  await LocalStorageHelper.init();

  await Get.putAsync(() => AuthService().init());

  // Initialize browser history service for back button control
  Get.put(BrowserHistoryService());

  // Initialize pending task service for route management
  Get.put(PendingTaskService());

  runApp(const App());
}

void debugEnv() {
  for (final k in [
    'FIREBASE_API_KEY',
    'FIREBASE_AUTH_DOMAIN',
    'FIREBASE_PROJECT_ID',
    'FIREBASE_APP_ID',
  ]) {
    final v = WebEnv.getEnv(k);
    print('$k = ${v.isEmpty ? "EMPTY" : "OK"}');
  }
}
