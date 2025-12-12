import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_service.dart';

import '../../../../core/services/http_interface.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../rules_v2/data/datasource/rules_remote_datasource.impl.dart';
import '../../../rules_v2/data/datasource/rules_remote_datasource.interface.dart';
import '../../data/datasource/rewards_remote_datasource.impl.dart';
import '../../data/datasource/rewards_remote_datasource.interface.dart';
import '../../data/repository/rewards_repository.impl.dart';
import '../../data/repository/rewards_repository.interface.dart';
import '../../data/usecase/rewards_usecase.impl.dart';
import '../../data/usecase/rewards_usecase.interface.dart';
import '../controllers/implementation/rewards_controller.impl.dart';
import '../controllers/interface/rewards_controller.interface.dart';
import '../presenters/implementation/rewards_presenter.impl.dart';
import '../presenters/interface/rewards_presenter.interface.dart';

class RewardsBinding extends Bindings {
  @override
  void dependencies() {
    // http
    Get.lazyPut<IHttp>(() => HttpService(), fenix: true);

    // datasource 
    Get.lazyPut<RewardsRemoteDataSourceInterface>(() => RewardsRemoteDataSourceImpl(Get.find<IHttp>()), fenix: true);

    // rules remote datasource
    Get.lazyPut<RulesV2RemoteDataSourceInterface>(() => RulesV2RemoteDataSourceImpl(http: Get.find<IHttp>()), fenix: true);

    // repository 
    Get.lazyPut<RewardsRepositoryInterface>(() => RewardsRepositoryImpl(
      remoteDataSource: Get.find<RewardsRemoteDataSourceInterface>(),
      rulesRemoteDatasource: Get.find<RulesV2RemoteDataSourceInterface>(),
    ), fenix: true);

    // usecase 
    Get.lazyPut<RewardsUseCaseInterface>(() => RewardsUsecaseImpl(Get.find<RewardsRepositoryInterface>()), fenix: true);

    // presenter
    Get.lazyPut<RewardsPresenterInterface>(() => RewardsPresenterImpl(Get.find<RewardsUseCaseInterface>(), Get.find<DashboardShellControllerInterface>()), fenix: true);

    // controller
    Get.lazyPut<RewardsControllerInterface>(() => RewardsControllerImpl(presenter: Get.find<RewardsPresenterInterface>(), usecase: Get.find<RewardsUseCaseInterface>(), dashboardShellController: Get.find<DashboardShellControllerInterface>()), fenix: true);

  }
}