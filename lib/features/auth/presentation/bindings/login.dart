// features/auth/presentation/bindings/login_binding.dart
import 'package:get/get.dart';

import '../../data/datasources/firebase_auth.dart';
import '../../data/repositories/implementation/login.dart';
import '../../data/repositories/interface/login.dart';
import '../../domain/usecases/implementation/login.dart';
import '../../domain/usecases/interface/login.dart';
import '../controllers/implementation/login.controller.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/implementation/login.presenter.dart';
import '../presenters/interface/login.presenter.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseAuthDataSource());
    Get.lazyPut<LoginRepositoryInterface>(
      () => LoginRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<LoginUseCaseInterface>(
      () => LoginUseCaseImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<LoginControllerInterface>(
      () => LoginControllerImpl(
        useCase: Get.find<LoginUseCaseInterface>(),
        presenter: Get.find<LoginPresenterInterface>(),
      ),
      fenix: true,
    );
    Get.lazyPut<LoginPresenterInterface>(
      () => LoginPresenterImpl(),
      fenix: true,
    );
  }
}
