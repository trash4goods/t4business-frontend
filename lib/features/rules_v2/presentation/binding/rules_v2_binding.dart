import 'package:get/get.dart';

import '../../../../core/services/http_interface.dart';
import '../../../auth/data/datasources/implementation/login_remote_datasource_impl.dart';
import '../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../../../dashboard_shell/data/datasource/remote/dashboard_shell_remote_datasource.impl.dart';
import '../../../dashboard_shell/data/datasource/remote/dashboard_shell_remote_datasource.interface.dart';
import '../../../dashboard_shell/data/repository/dashboard_shell_repository.impl.dart';
import '../../../dashboard_shell/data/repository/dashboard_shell_repository.interface.dart';
import '../../../dashboard_shell/data/usecase/dashboard_shell_usecase.interface.dart';
import '../../../dashboard_shell/data/usecase/dashboard_shell_usecase_impl.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.impl.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../dashboard_shell/presentation/presenter/dashboard_shell_presenter.impl.dart';
import '../../../dashboard_shell/presentation/presenter/dashboard_shell_presenter.interface.dart';
import '../../../product_managment/data/datasource/remote/product_management_remote_datasource.impl.dart';
import '../../../product_managment/data/datasource/remote/product_management_remote_datasource.interface.dart';
import '../../../rewards/data/datasource/rewards_remote_datasource.impl.dart';
import '../../../rewards/data/datasource/rewards_remote_datasource.interface.dart';
import '../../data/datasource/rules_remote_datasource.impl.dart';
import '../../data/datasource/rules_remote_datasource.interface.dart';
import '../../data/repository/rules_repository.impl.dart';
import '../../data/repository/rules_repository.interface.dart';
import '../../data/usecase/rules_usecase.impl.dart';
import '../../data/usecase/rules_usecase.interface.dart';
import '../controller/rules_v2_controller.impl.dart';
import '../controller/rules_v2_controller.interface.dart';
import '../presenter/rules_v2_presenter.impl.dart';
import '../presenter/rules_v2_presenter.interface.dart';

class RulesV2Binding extends Bindings {
  @override
  void dependencies() {
    // datasource
    Get.lazyPut<RulesV2RemoteDataSourceInterface>(
      () => RulesV2RemoteDataSourceImpl(http: Get.find<IHttp>()),
      fenix: true,
    );

    // product management datasource
    Get.lazyPut<ProductManagementRemoteDatasourceInterface>(
      () => ProductManagementRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    // rewards datasource
    Get.lazyPut<RewardsRemoteDataSourceInterface>(
      () => RewardsRemoteDataSourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    // repository
    Get.lazyPut<RulesV2RepositoryInterface>(
      () => RulesV2RepositoryImpl(
        remoteDataSource: Get.find<RulesV2RemoteDataSourceInterface>(),
        productManagementRemoteDatasource: Get.find<ProductManagementRemoteDatasourceInterface>(),
        rewardsRemoteDataSource: Get.find<RewardsRemoteDataSourceInterface>(),
      ),
      fenix: true,
    );

    // usecase
    Get.lazyPut<RulesV2UseCaseInterface>(
      () => RulesV2UseCaseImpl(
        repository: Get.find<RulesV2RepositoryInterface>(),
      ),
      fenix: true,
    );

    // controller
    Get.lazyPut<RulesV2ControllerInterface>(
      () => RulesV2ControllerImpl(
        presenter: Get.find<RulesV2PresenterInterface>(),
        useCase: Get.find<RulesV2UseCaseInterface>(),
      ),
      fenix: true,
    );

    // external presenter dependencies
    // dashboard remote datasource
    Get.lazyPut<DashboardShellRemoteDataSourceInterface>(
      () => DashboardShellRemoteDataSourceImpl(),
      fenix: true,
    );

    // login remote datasource
    Get.lazyPut<LoginRemoteDatasourceInterface>(
      () => LoginRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    // dashboard repostory 
    Get.lazyPut<DashboardShellRepositoryInterface>(
      () => DashboardShellRepositoryImpl(
        remoteDataSource: Get.find<DashboardShellRemoteDataSourceInterface>(),
        loginDataSource: Get.find<LoginRemoteDatasourceInterface>(),
      ),
      fenix: true,
    );

    // dashboard usecase
    Get.lazyPut<DashboardShellUsecaseInterface>(
      () => DashboardShellUsecaseImpl(
        Get.find<DashboardShellRepositoryInterface>(),
      ),
      fenix: true,
    );

    // dashboard presenter
    Get.lazyPut<DashboardShellPresenterInterface>(
      () => DashboardShellPresenterImpl(),
      fenix: true,
    );

    // dashboard controller
    Get.lazyPut<DashboardShellControllerInterface>(
      () => DashboardShellControllerImpl(
        presenter: Get.find<DashboardShellPresenterInterface>(),
        usecase: Get.find<DashboardShellUsecaseInterface>(),
      ),
      fenix: true,
    );

    // presenter
    Get.lazyPut<RulesV2PresenterInterface>(
      () => RulesV2PresenterImpl(
        useCase: Get.find<RulesV2UseCaseInterface>(),
        dashboardShellController: Get.find<DashboardShellControllerInterface>(),
      ),
      fenix: true,
    );
  }
}
