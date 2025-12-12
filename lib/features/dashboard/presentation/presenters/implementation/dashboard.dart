import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import 'package:t4g_for_business/core/app/themes/app_colors.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../auth/data/datasources/auth_cache.dart';
import '../../../../auth/data/models/product.dart';
import 'package:t4g_for_business/features/dashboard/data/models/chart_data.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../controllers/interface/dashboard.dart';
import '../interface/dashboard.dart';

class DashboardPresenterImpl extends DashboardPresenterInterface {
  DashboardPresenterImpl({required this.dashboardShellController});

  final DashboardShellControllerInterface dashboardShellController;

  final RxBool _isLoading = false.obs;
  final _user = Rxn<UserAuthModel>();
  final RxnString _error = RxnString();
  final RxInt _totalProducts = 0.obs;
  final RxInt _totalRecycled = 0.obs;
  final RxList _mostRecycledProducts = [].obs;
  final RxBool _isCollapsed = false.obs;
  final RxString _currentRoute = RxString(AppRoutes.dashboard);
  // Date range state
  final RxString _selectedDateRangeText = 'Last 30 days'.obs;
  final Rx<DateTimeRange?> _selectedDateRange = Rx<DateTimeRange?>(null);

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late RxString currentRoute = _currentRoute;
  @override
  void onNavigate(String value) => dashboardShellController.handleMobileNavigation(value);
  @override
  void onLogout() => dashboardShellController.logout();
  @override
  void onToggle() => dashboardShellController.toggleSidebar();
  
  @override
  void onInit() {
    super.onInit();
    scaffoldKey = dashboardShellController.scaffoldKey;
    dashboardShellController.currentRoute.value = currentRoute.value;
    loadDashboardData();
  }

  @override
  UserAuthModel? get user => _user.value;

  @override
  RxBool get isCollapsed => _isCollapsed;

  @override
  RxString get selectedDateRangeText => _selectedDateRangeText;

  @override
  Rx<DateTimeRange?> get selectedDateRange => _selectedDateRange;

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
  void setSelectedDateRange(DateTimeRange? range) =>
      _selectedDateRange.value = range;

  @override
  void setSelectedDateRangeText(String text) =>
      _selectedDateRangeText.value = text;

  @override
  Future<void> loadDashboardData() async {
    setLoading(true);

    try {
      _user.value =
          await AuthCacheDataSource.instance.getUserAuth() as UserAuthModel;

      log(
        '[DashboardPresenterImpl] user: ${_user.value?.toJson() ?? 'No user found'}',
      );
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

  @override
  List<ChartData> getPieChartData() {
    final products = getMostRecycledProducts();
    final categoryColors = <String, Color>{
      'Bottles': AppColors.primary,
      'Electronics': const Color(0xFF10B981),
      'Stationery': const Color(0xFFF59E0B),
      'Eco-friendly': const Color(0xFF8B5CF6),
      'Bamboo': const Color(0xFFF97316),
      'Paper': const Color(0xFF06B6D4),
    };
    return products.map((product) {
      final category =
          product.category.isNotEmpty ? product.category.first : 'Other';
      final color = categoryColors[category] ?? AppColors.secondary;
      return ChartData(
        label: product.title,
        value: product.recycledCount.toDouble(),
        color: color,
        category: category,
      );
    }).toList();
  }
}
