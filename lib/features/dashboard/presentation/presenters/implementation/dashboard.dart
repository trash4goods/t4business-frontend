import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../auth/data/models/product.dart';
import '../interface/dashboard.dart';

class DashboardPresenterImpl extends DashboardPresenterInterface {
  DashboardPresenterImpl();

  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();
  final RxInt _totalProducts = 0.obs;
  final RxInt _totalRecycled = 0.obs;
  final RxList _mostRecycledProducts = [].obs;
  final RxBool _isCollapsed = false.obs;
  final RxString _currentRoute = RxString(AppRoutes.dashboard);

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  @override
  RxString get currentRoute => _currentRoute;

  @override
  RxBool get isCollapsed => _isCollapsed;

  @override
  bool get isLoading => _isLoading.value;

  @override
  String? get error => _error.value;

  @override
  int get totalProducts => _totalProducts.value;

  @override
  int get totalRecycled => _totalRecycled.value;

  @override
  List get mostRecycledProducts => _mostRecycledProducts;

  @override
  void setLoading(bool loading) => _isLoading.value = loading;

  @override
  void setError(String? error) => _error.value = error;

  @override
  void setTotalProducts(int count) => _totalProducts.value = count;

  @override
  void setTotalRecycled(int count) => _totalRecycled.value = count;

  @override
  void setMostRecycledProducts(List products) =>
      _mostRecycledProducts.assignAll(products);

  @override
  void toggleSidebar() => _isCollapsed.value = !_isCollapsed.value;

  @override
  Future<void> loadDashboardData() async {
    setLoading(true);

    try {
      // Mock data - replace with Firebase calls
      await Future.delayed(const Duration(seconds: 1));

      final mockProducts = _generateMockProducts();

      setTotalProducts(mockProducts.length);
      setTotalRecycled(
        mockProducts.fold(0, (sum, product) => sum + product.recycledCount),
      );
      setMostRecycledProducts(getMostRecycledProducts());
    } catch (e) {
      setError('Failed to load dashboard data');
    } finally {
      setLoading(false);
    }
  }

  @override
  List<ProductModel> getMostRecycledProducts() {
    final products = _generateMockProducts();
    products.sort((a, b) => b.recycledCount.compareTo(a.recycledCount));
    return products.take(5).toList();
  }

  List<ProductModel> _generateMockProducts() {
    return [
      ProductModel(
        id: 1,
        title: 'Coca-Cola 1L Zero',
        brand: 'Coca-Cola',
        description: 'Sustainable water bottle made from recycled materials',
        headerImage: AppImages.cocaColaCanBarcode,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        barcode: '1234567890',
        category: ['Bottles', 'Eco-friendly'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        recycledCount: 45,
      ),
      ProductModel(
        id: 2,
        title: 'Eco Water Bottle',
        brand: 'Pingo Doce',
        description: 'Sustainable water bottle made from recycled materials',
        headerImage: AppImages.pingoDoceWaterBottleBarcode,
        carouselImage: [AppImages.pingoDoceWaterBottle],
        barcode: '0987654321',
        category: ['Bamboo'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        recycledCount: 32,
      ),
      ProductModel(
        id: 1,
        title: 'Coca-Cola 5L Zero',
        brand: 'Coca-Cola',
        description: 'Sustainable water bottle made from recycled materials',
        headerImage: AppImages.cocaColaCan,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        barcode: '1234567890',
        category: ['Eco-friendly'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        recycledCount: 45,
      ),
    ];
  }
}
