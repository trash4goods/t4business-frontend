import 'package:get/get.dart';

import '../../../../core/services/http_interface.dart';
import '../../../auth/data/datasources/implementation/login_remote_datasource_impl.dart';
import '../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../../data/datasource/remote/dashboard_shell_remote_datasource.impl.dart';
import '../../data/datasource/remote/dashboard_shell_remote_datasource.interface.dart';
import '../../data/repository/dashboard_shell_repository.interface.dart';
import '../../data/repository/dashboard_shell_repository.impl.dart';
import '../../data/usecase/dashboard_shell_usecase.interface.dart';
import '../../data/usecase/dashboard_shell_usecase_impl.dart';
import '../controller/dashboard_shell_controller.impl.dart';
import '../controller/dashboard_shell_controller.interface.dart';
import '../presenter/dashboard_shell_presenter.impl.dart';
import '../presenter/dashboard_shell_presenter.interface.dart';

class DashboardShellBinding extends Bindings {
  @override
  void dependencies() {
    // datasource
    Get.lazyPut<DashboardShellRemoteDataSourceInterface>(
      () => DashboardShellRemoteDataSourceImpl(),
      fenix: true,
    );

    // repository & its dependencies
    Get.lazyPut<LoginRemoteDatasourceInterface>(
      () => LoginRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );
    Get.lazyPut<DashboardShellRepositoryInterface>(
      () => DashboardShellRepositoryImpl(
        remoteDataSource: Get.find<DashboardShellRemoteDataSourceInterface>(),
        loginDataSource: Get.find<LoginRemoteDatasourceInterface>(),
      ),
      fenix: true,
    );

    // usecase
    Get.lazyPut<DashboardShellUsecaseInterface>(
      () => DashboardShellUsecaseImpl(Get.find<DashboardShellRepositoryInterface>()),
      fenix: true,
    );

    // presenter
    Get.lazyPut<DashboardShellPresenterInterface>(
      () => DashboardShellPresenterImpl(),
      fenix: true,
    );

    // controller
    Get.lazyPut<DashboardShellControllerInterface>(
      () => DashboardShellControllerImpl(
        presenter: Get.find<DashboardShellPresenterInterface>(),
        usecase: Get.find<DashboardShellUsecaseInterface>(),
      ),
      fenix: true,
    );
  }
}
