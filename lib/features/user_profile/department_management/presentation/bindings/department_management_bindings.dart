import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';

import '../../data/datasource/remote/department_managment_remote_datasource.impl.dart';
import '../../data/datasource/remote/department_managment_remote_datasource.interface.dart';
import '../../data/repository/department_managment_repository.impl.dart';
import '../../data/repository/department_managment_repository.interface.dart';
import '../../data/usecase/department_managment_usecase.impl.dart';
import '../../data/usecase/department_managment_usecase.interface.dart';
import '../controller/department_management_controller.impl.dart';
import '../controller/department_management_controller.interface.dart';
import '../presenter/department_management_presenter.impl.dart';
import '../presenter/department_management_presenter.interface.dart';

class DepartmentManagementBindings extends Bindings {
  @override
  void dependencies() {
    // Remote datasource
    Get.lazyPut<DepartmentManagmentRemoteDatasourceInterface>(
      () => DepartmentManagmentRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    // repository
    Get.lazyPut<DepartmentManagmentRepositoryInterface>(
      () => DepartmentManagmentRepositoryImpl(
        Get.find<DepartmentManagmentRemoteDatasourceInterface>(),
      ),
      fenix: true,
    );

    // UseCase
    Get.lazyPut<DepartmentManagmentUseCaseInterface>(
      () => DepartmentManagmentUseCaseImpl(
        Get.find<DepartmentManagmentRepositoryInterface>(),
      ),
      fenix: true,
    );

    // Presenter
    Get.lazyPut<DepartmentManagementPresenterInterface>(
      () => DepartmentManagementPresenterImpl(
        Get.find<DepartmentManagmentUseCaseInterface>(),
      ),
      fenix: true,
    );

    // Controller
    Get.lazyPut<DepartmentManagementControllerInterface>(
      () => DepartmentManagementControllerImpl(
        Get.find<DepartmentManagementPresenterInterface>(),
        Get.find<DepartmentManagmentUseCaseInterface>(),
      ),
      fenix: true,
    );
  }
}
