import 'package:get/get.dart';

abstract class PendingTaskPresenterInterface extends GetxController {
  String? get currentUserUid;
  RxBool get isLogoutLoading;
  RxMap<String, bool> get taskLoadingStates;
  
  void setLogoutLoading(bool loading);
  void setTaskLoading(String taskType, bool loading);
  bool isTaskLoading(String taskType);
}