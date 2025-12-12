import 'package:get/get.dart';

import '../../../../core/controllers/protected_route_controller.dart';
import '../../../../core/services/http_interface.dart';
import '../../../../core/services/http_service.dart';
import '../../../auth/data/datasources/implementation/login_remote_datasource_impl.dart';
import '../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../dashboard_shell/presentation/presenter/dashboard_shell_presenter.interface.dart';
import '../../data/datasources/firebase_auth.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/usecase/usecase.dart';
import '../presenters/presenters.dart';
import '../controllers/controllers.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardPresenterInterface>(
      () =>
          DashboardPresenterImpl(
            dashboardShellController: Get.find<DashboardShellControllerInterface>(),
          ),
      fenix: true,
    );

    Get.lazyPut<DashboardControllerInterface>(
      () => DashboardControllerImpl(
        presenter: Get.find<DashboardPresenterInterface>(),
        usecase: Get.find<DashboardUsecaseInterface>(),
        dashboardShellPresenter: Get.find<DashboardShellPresenterInterface>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DashboardUsecaseInterface>(
      () => DashboardUsecaseImpl(Get.find<DashboardRepositoryInterface>()),
      fenix: true,
    );

    Get.lazyPut<IHttp>(() => HttpService(), fenix: true);

    Get.lazyPut<LoginRemoteDatasourceInterface>(
      () => LoginRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    Get.lazyPut<DashboardRepositoryInterface>(
      () => DashboardRepositoryImpl(Get.find<LoginRemoteDatasourceInterface>()),
      fenix: true,
    );

    Get.lazyPut(() => DashboardFirebaseAuthDataSource());

    // Add browser history protection for this protected route
    Get.put(ProtectedRouteController(), tag: 'dashboard');
  }
}
