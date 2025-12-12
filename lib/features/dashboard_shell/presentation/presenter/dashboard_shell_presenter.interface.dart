import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DashboardShellPresenterInterface extends GetxController {
  String get currentRoute;
  set currentRoute(String value);

  bool get isCollapsed;
  set isCollapsed(bool value);

  GlobalKey<ScaffoldState> get scaffoldKey;

  void refreshCurrentRoute();
}
  
