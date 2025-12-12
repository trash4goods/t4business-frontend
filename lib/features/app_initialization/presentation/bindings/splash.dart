import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../core/services/http_interface.dart';
import '../../../../core/services/http_service.dart';
import '../../../auth/data/datasources/implementation/login_remote_datasource_impl.dart';
import '../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../../data/datasources/firebase_auth.dart';
import '../../data/repositories/splash.dart';
import '../../domain/repositories/splash.dart';
import '../../domain/use_cases/splash.dart';
import '../controllers/controllers.dart';
import '../presenters/presenters.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Register HTTP service for login datasource
    Get.lazyPut<IHttp>(() => HttpService(), fenix: true);
    
    // Register login datasource for pending task service
    Get.lazyPut<LoginRemoteDatasourceInterface>(
      () => LoginRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );
    
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
