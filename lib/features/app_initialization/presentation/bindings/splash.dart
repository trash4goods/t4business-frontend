import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../data/datasources/firebase_auth.dart';
import '../../data/repositories/splash.dart';
import '../../domain/repositories/splash.dart';
import '../../domain/use_cases/splash.dart';
import '../controllers/controllers.dart';
import '../presenters/presenters.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Register Firebase Auth instance
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);

    // Register data source
    Get.lazyPut<AuthDataSource>(
      () => FirebaseAuthDataSource(Get.find<FirebaseAuth>()),
      fenix: true,
    );

    // Register repository
    Get.lazyPut<SplashRepositoryInterface>(
      () => SplashRepositoryImpl(Get.find<AuthDataSource>()),
      fenix: true,
    );

    // Register use case
    Get.lazyPut<SplashUseCaseInterface>(
      () => SplashUseCaseImpl(Get.find<SplashRepositoryInterface>()),
      fenix: true,
    );

    // Register the concrete presenter implementation
    Get.lazyPut<SplashPresenterInterface>(
      () => SplashPresenterImpl(),
      fenix: true,
    );

    // Register the business controller
    Get.lazyPut<SplashControllerInterface>(
      () => SplashControllerImpl(
        presenter: Get.find<SplashPresenterInterface>(),
        useCase: Get.find<SplashUseCaseInterface>(),
      ),
      fenix: true,
    );
  }
}
