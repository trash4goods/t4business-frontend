import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DashboardShellControllerInterface {
  void navigateToPage(String route);
  void toggleSidebar();
  void logout();
  void handleMobileNavigation(String route);

  GlobalKey<ScaffoldState> get scaffoldKey;

  RxString get currentRoute;
}