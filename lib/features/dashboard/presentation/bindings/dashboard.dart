import 'package:get/get.dart';

import '../../../../core/controllers/protected_route_controller.dart';
import '../../data/datasources/firebase_auth.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/usecase/interface/dashboard.dart';
import '../../domain/usecase/usecase.dart';
import '../presenters/presenters.dart';
import '../controllers/controllers.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardPresenterInterface>(
      () => DashboardPresenterImpl(),
      fenix: true,
    );

    Get.lazyPut<DashboardControllerInterface>(
      () => DashboardControllerImpl(
        Get.find<DashboardPresenterInterface>(),
        Get.find<DashboardUsecaseInterface>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DashboardUsecaseInterface>(
      () => DashboardUsecaseImpl(Get.find<DashboardRepositoryInterface>()),
      fenix: true,
    );

    Get.lazyPut<DashboardRepositoryInterface>(
      () =>
          DashboardRepositoryImpl(Get.find<DashboardFirebaseAuthDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => DashboardFirebaseAuthDataSource());

    // Add browser history protection for this protected route
    Get.put(ProtectedRouteController(), tag: 'dashboard');
  }
}
