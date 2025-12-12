import 'package:get/get.dart';
import '../../../../../core/services/auth_service.dart';
import '../interface/pending_task_presenter_interface.dart';

class PendingTaskPresenterImpl extends GetxController implements PendingTaskPresenterInterface {
  final RxBool _isLogoutLoading = false.obs;
  final RxMap<String, bool> _taskLoadingStates = <String, bool>{}.obs;

  @override
  String? get currentUserUid {
    return AuthService.instance.user?.uid;
  }

  @override
  RxBool get isLogoutLoading => _isLogoutLoading;

  @override
  RxMap<String, bool> get taskLoadingStates => _taskLoadingStates;

  @override
  void setLogoutLoading(bool loading) {
    _isLogoutLoading.value = loading;
  }

  @override
  void setTaskLoading(String taskType, bool loading) {
    _taskLoadingStates[taskType] = loading;
  }

  @override
  bool isTaskLoading(String taskType) {
    return _taskLoadingStates[taskType] ?? false;
  }

  @override
  void onClose() {
    _taskLoadingStates.clear();
    super.onClose();
  }
}