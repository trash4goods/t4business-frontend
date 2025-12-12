import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';
import 'package:t4g_for_business/core/services/http_service.dart';

import '../../data/datasource/remote/profile_delete_account_remote_datasource.impl.dart';
import '../../data/datasource/remote/profile_delete_account_remote_datasource.interface.dart';
import '../../data/repository/profile_delete_account_repository.impl.dart';
import '../../data/repository/profile_delete_account_repository.interface.dart';
import '../../data/usecase/profile_delete_account_usecase.impl.dart';
import '../../data/usecase/profile_delete_account_usecase.interface.dart';
import '../controller/profile_delete_account_controller.impl.dart';
import '../controller/profile_delete_account_controller.interface.dart';
import '../presenter/profile_delete_account_presenter.impl.dart';
import '../presenter/profile_delete_account_presenter.interface.dart';

class ProfileDeleteAccountBindings extends Bindings {
  @override
  void dependencies() {
    // http
    Get.lazyPut<IHttp>(() => HttpService(), fenix: true);

    // datasource
    Get.lazyPut<ProfileDeleteAccountRemoteDataSourceInterface>(
      () => ProfileDeleteAccountRemoteDataSourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    // repository
    Get.lazyPut<ProfileDeleteAccountRepositoryInterface>(
      () => ProfileDeleteAccountRepositoryImpl(
        Get.find<ProfileDeleteAccountRemoteDataSourceInterface>(),
      ),
      fenix: true,
    );

    // usecase
    Get.lazyPut<ProfileDeleteAccountUseCaseInterface>(
      () => ProfileDeleteAccountUseCaseImpl(
        Get.find<ProfileDeleteAccountRepositoryInterface>(),
      ),
      fenix: true,
    );

    // presenter
    Get.lazyPut<ProfileDeleteAccountPresenterInterface>(
      () => ProfileDeleteAccountPresenterImpl(),
      fenix: true,
    );

    // controller
    Get.lazyPut<ProfileDeleteAccountControllerInterface>(
      () => ProfileDeleteAccountControllerImpl(
        presenter: Get.find<ProfileDeleteAccountPresenterInterface>(),
        useCase: Get.find<ProfileDeleteAccountUseCaseInterface>(),
      ),
      fenix: true,
    );
  }
}
