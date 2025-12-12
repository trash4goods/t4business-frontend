import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';
import 'package:t4g_for_business/core/services/http_service.dart';
import 'package:t4g_for_business/features/user_profile/profile_change_password/presentation/controller/profile_change_password_controller.impl.dart';

import '../../data/datasource/remote/profile_change_password_remote_datasource.impl.dart';
import '../../data/datasource/remote/profile_change_password_remote_datasource.interface.dart';
import '../../data/repository/profile_change_password_repository.impl.dart';
import '../../data/repository/profile_change_password_repository.interface.dart';
import '../../data/usecase/profile_change_password_usecase.impl.dart';
import '../../data/usecase/profile_change_password_usecase.interface.dart';
import '../controller/profile_change_password_controller.interface.dart';
import '../presenter/profile_change_password_presenter.impl.dart';
import '../presenter/profile_change_password_presenter.interface.dart';

class ProfileChangePasswordBindings extends Bindings {
  @override
  void dependencies() {
    // http
    Get.lazyPut<IHttp>(() => HttpService(), fenix: true);

    // datasource
    Get.lazyPut<ProfileChangePasswordRemoteDataSourceInterface>(() => ProfileChangePasswordRemoteDataSourceImpl(Get.find<IHttp>()), fenix: true);

    // repository
    Get.lazyPut<ProfileChangePasswordRepositoryInterface>(() => ProfileChangePasswordRepositoryImpl(Get.find<ProfileChangePasswordRemoteDataSourceInterface>()), fenix: true);

    // usecase
    Get.lazyPut<ProfileChangePasswordUseCaseInterface>(() => ProfileChangePasswordUseCaseImpl(Get.find<ProfileChangePasswordRepositoryInterface>()), fenix: true);

    // presenter 
    Get.lazyPut<ProfileChangePasswordPresenterInterface>(() => ProfileChangePasswordPresenterImpl(), fenix: true);

    // controller
    Get.lazyPut<ProfileChangePasswordControllerInterface>(() => ProfileChangePasswordControllerImpl(
      Get.find<ProfileChangePasswordPresenterInterface>(),
      Get.find<ProfileChangePasswordUseCaseInterface>(),
    ), fenix: true);
  }
}
  