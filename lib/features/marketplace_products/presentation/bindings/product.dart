import 'package:get/get.dart';
import '../controllers/implementation/product.dart';
import '../controllers/interface/product.dart';
import '../presenters/implementation/product.dart';
import '../presenters/interface/product.dart';

class MarketplaceProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RewardsControllerInterface>(
      () => RewardsControllerImpl(),
      fenix: true,
    );
    Get.lazyPut<RewardsPresenterInterface>(
      () => RewardsPresenterImpl(Get.find<RewardsControllerInterface>()),
      fenix: true,
    );
  }
}
