import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/app_routes.dart';
import 'dashboard_shell_presenter.interface.dart';

class DashboardShellPresenterImpl extends DashboardShellPresenterInterface {
  DashboardShellPresenterImpl();
  
  final _isCollapsed = RxBool(false);
  final _currentRoute = RxString(AppRoutes.dashboard);

  @override
  String get currentRoute => _currentRoute.value;
  @override
  set currentRoute(String value) => _currentRoute.value = value;

  @override
  void refreshCurrentRoute() => _currentRoute.refresh();

  @override
  bool get isCollapsed => _isCollapsed.value;
  @override
  set isCollapsed(bool value) => _isCollapsed.value = value;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => GlobalKey<ScaffoldState>();
}
  