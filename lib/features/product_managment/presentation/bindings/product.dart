import 'package:get/get.dart';
import '../controllers/implementation/product.dart';
import '../controllers/interface/product.dart';
import '../presenters/implementation/product.dart';
import '../presenters/interface/product.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsControllerInterface>(
      () => ProductsControllerImpl(),
      fenix: true,
    );
    Get.lazyPut<ProductsPresenterInterface>(
      () => ProductsPresenterImpl(Get.find<ProductsControllerInterface>()),
      fenix: true,
    );
  }
}
