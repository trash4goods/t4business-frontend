import 'package:get/get.dart';

import '../../../../auth/data/models/product.dart';

abstract class DashboardPresenterInterface extends GetxController {
  bool get isLoading;
  String? get error;
  int get totalProducts;
  int get totalRecycled;
  List get mostRecycledProducts;
  RxString get currentRoute;
  RxBool get isCollapsed;

  void setLoading(bool loading);
  void setError(String? error);
  void setTotalProducts(int count);
  void setTotalRecycled(int count);
  void setMostRecycledProducts(List products);
  Future<void> loadDashboardData();
  List<ProductModel> getMostRecycledProducts();
  void toggleSidebar();
}
