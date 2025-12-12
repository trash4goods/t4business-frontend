import 'package:get/get.dart';
import 'package:t4g_for_business/features/user_profile/profile/presentation/presenters/interface/profile.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../data/datasources/firebase_profile.dart';
import '../../data/repositories/implementation/profile.dart';
import '../../data/repositories/interface/profile.dart';
import '../../domain/usecases/implementation/profile.dart';
import '../../domain/usecases/interface/profile.dart';
import '../controllers/implementation/profile.dart';
import '../controllers/interface/profile.dart';
import '../presenters/implementation/profile.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // DataSource
    Get.lazyPut(() => ProfileFirebaseDataSource());

    // Repository
    Get.lazyPut<ProfileRepositoryInterface>(
      () => ProfileRepositoryImpl(Get.find()),
      fenix: true,
    );

    // UseCase
    Get.lazyPut<ProfileUseCaseInterface>(
      () => ProfileUseCaseImpl(Get.find()),
      fenix: true,
    );

    // Presenter
    Get.lazyPut<ProfilePresenterInterface>(
      () => ProfilePresenterImpl(
        dashboardShellController: Get.find<DashboardShellControllerInterface>(),
      ),
      fenix: true,
    );

    // Controller
    Get.lazyPut<ProfileControllerInterface>(
      () => ProfileControllerImpl(Get.find(), Get.find()),
      fenix: true,
    );
  }
}
