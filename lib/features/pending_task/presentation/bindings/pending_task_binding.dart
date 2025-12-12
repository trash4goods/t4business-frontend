import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/pending_task_service.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/http_interface.dart';
import '../../../../core/services/http_service.dart';
import '../../data/datasources/pending_task_remote_datasource_impl.dart';
import '../../data/datasources/pending_task_remote_datasource_interface.dart';
import '../../data/repositories/implementation/pending_task_repository_impl.dart';
import '../../data/repositories/interface/pending_task_repository_interface.dart';
import '../../domain/usecases/implementation/pending_task_usecase_impl.dart';
import '../../domain/usecases/interface/pending_task_usecase_interface.dart';
import '../controllers/implementation/pending_task_controller_impl.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/implementation/pending_task_presenter_impl.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';

class PendingTaskBinding implements Bindings {
  @override
  void dependencies() {
    // Register HTTP service if not already registered
    if (!Get.isRegistered<IHttp>()) {
      Get.lazyPut<IHttp>(() => HttpService(), fenix: true);
    }

    // Register AuthService if not already registered
    if (!Get.isRegistered<AuthService>()) {
      Get.lazyPut(() => AuthService(), fenix: true);
    }

    Get.lazyPut<PendingTaskRemoteDataSourceInterface>(
      () => PendingTaskRemoteDataSourceImpl(
        http: Get.find<IHttp>(),
        authService: Get.find<AuthService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PendingTaskRepositoryInterface>(
      () => PendingTaskRepositoryImpl(
        remoteDataSource: Get.find<PendingTaskRemoteDataSourceInterface>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PendingTaskUsecaseInterface>(
      () => PendingTaskUsecaseImpl(
        repository: Get.find<PendingTaskRepositoryInterface>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PendingTaskPresenterInterface>(
      () => PendingTaskPresenterImpl(),
      fenix: true,
    );

    Get.lazyPut<PendingTaskService>(() => PendingTaskService(), fenix: true);

    Get.lazyPut<PendingTaskControllerInterface>(
      () => PendingTaskControllerImpl(
        useCase: Get.find<PendingTaskUsecaseInterface>(),
        presenter: Get.find<PendingTaskPresenterInterface>(),
        pendingTaskService: Get.find<PendingTaskService>(),
        authService: Get.find<AuthService>(),
      ),
      fenix: true,
    );
  }
}
