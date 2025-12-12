import 'package:get/get.dart';
import '../../../../core/services/http_interface.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../data/datasource/remote/product_management_remote_datasource.impl.dart';
import '../../data/datasource/remote/product_management_remote_datasource.interface.dart';
import '../../data/repository/product_management_repository.impl.dart';
import '../../data/repository/product_management_repository.interface.dart';
import '../../data/usecase/product_management_usecase.impl.dart';
import '../../data/usecase/product_management_usecase.interface.dart';
import '../controllers/implementation/product.dart';
import '../controllers/interface/product.dart';
import '../presenters/implementation/product.dart';
import '../presenters/interface/product.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    // Data layer dependencies
    Get.lazyPut<ProductManagementRemoteDatasourceInterface>(
      () => ProductManagementRemoteDatasourceImpl(Get.find<IHttp>()),
      fenix: true,
    );

    Get.lazyPut<ProductManagementRepositoryInterface>(
      () => ProductManagementRepositoryImpl(
        Get.find<ProductManagementRemoteDatasourceInterface>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProductManagementUseCaseInterface>(
      () => ProductManagementUseCaseImpl(
        Get.find<ProductManagementRepositoryInterface>(),
      ),
      fenix: true,
    );

    // Presentation layer dependencies
    Get.lazyPut<ProductsControllerInterface>(
      () =>
          ProductsControllerImpl(Get.find<ProductManagementUseCaseInterface>()),
      fenix: true,
    );
    Get.lazyPut<ProductsPresenterInterface>(
      () => ProductsPresenterImpl(
        controller: Get.find<ProductsControllerInterface>(),
        dashboardShellController: Get.find<DashboardShellControllerInterface>(),
      ),
      fenix: true,
    );
  }
}
