import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/dashboard/data/models/chart_data.dart';

import '../../../../auth/data/models/product.dart';
import '../../../../auth/data/models/user_auth/user_auth_model.dart';

abstract class DashboardPresenterInterface extends GetxController {
  // global from parent DashboardShell
  GlobalKey<ScaffoldState> get scaffoldKey;
  RxString get currentRoute;
  void onNavigate(String route);
  void onLogout();
  void onToggle();
  // core
  bool get isLoading;
  String? get error;
  int get totalProducts;
  int get totalRecycled;
  List get mostRecycledProducts;
  RxBool get isCollapsed;
  // Date range state for dashboard
  RxString get selectedDateRangeText;
  Rx<DateTimeRange?> get selectedDateRange;

  UserAuthModel? get user;

  void setLoading(bool loading);
  void setError(String? error);
  void setTotalProducts(int count);
  void setTotalRecycled(int count);
  void setMostRecycledProducts(List products);
  Future<void> loadDashboardData();
  List<ProductModel> getMostRecycledProducts();
  List<ChartData> getPieChartData();
  void toggleSidebar();
  // Setters for date range
  void setSelectedDateRange(DateTimeRange? range);
  void setSelectedDateRangeText(String text);
}
