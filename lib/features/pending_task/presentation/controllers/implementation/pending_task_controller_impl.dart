import 'dart:developer';
import 'package:get/get.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../utils/helpers/local_storage.dart';
import '../../../../auth/data/models/firebase_user_pending_task_model.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/navigation.dart';
import '../../../../../core/services/pending_task_service.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../domain/usecases/interface/pending_task_usecase_interface.dart';
import '../../presenters/interface/pending_task_presenter_interface.dart';
import '../interface/pending_task_controller_interface.dart';

class PendingTaskControllerImpl implements PendingTaskControllerInterface {
  final PendingTaskUsecaseInterface useCase;
  final PendingTaskPresenterInterface presenter;
  final PendingTaskService pendingTaskService;
  final AuthService authService;

  PendingTaskControllerImpl({
    required this.useCase,
    required this.presenter,
    required this.pendingTaskService,
    required this.authService,
  });

  @override
  Stream<List<FirebaseUserPendingTaskModel>> get pendingTasksStream {
    final uid = presenter.currentUserUid;
    if (uid == null) {
      log('--> [PendingTaskController] No user UID found');
      return Stream.value([]);
    }
    return useCase.getPendingTasksStream(uid);
  }

  @override
  Future<void> completeTask(String taskType) async {
    try {
      presenter.setTaskLoading(taskType, true);

      final uid = presenter.currentUserUid;
      if (uid == null) {
        throw Exception('User not found');
      }

      await useCase.completeTask(uid, taskType);

      // Clear cache so next check will fetch fresh data
      try {
        final pendingTaskService = Get.find<PendingTaskService>();
        pendingTaskService.clearCache(uid);
        log('--> [PendingTaskController] Cache cleared for user $uid');
      } catch (e) {
        log('--> [PendingTaskController] Failed to clear cache: $e');
      }

      _showSuccess('Task completed successfully');
      log('--> [PendingTaskController] Task $taskType completed');
    } catch (e) {
      _showError('Failed to complete task: ${e.toString()}');
      log('--> [PendingTaskController] Error completing task: $e');
    } finally {
      presenter.setTaskLoading(taskType, false);
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      presenter.setTaskLoading('setPassword', true);

      final uid = presenter.currentUserUid;
      if (uid == null) {
        throw Exception('User not found');
      }

      final token =
          await LocalStorageHelper.getString(AppConstants.tokenKey) ?? '';

      // Change password
      await useCase.changePassword(oldPassword, newPassword, token);

      // Change password in firebase
      await authService.changePassword(oldPassword, newPassword);

      // Mark setPassword task as completed
      await useCase.completeTask(uid, 'setPassword');

      // Clear cache so next check will fetch fresh data
      try {
        pendingTaskService.clearCache(uid);
        log('--> [PendingTaskController] Cache cleared for user $uid');
      } catch (e) {
        log('--> [PendingTaskController] Failed to clear cache: $e');
      }

      _showSuccess('Password changed successfully');
      log('--> [PendingTaskController] Password changed and task completed');

      // Navigate to dashboard
      NavigationService.offAll(AppRoutes.dashboardShell);
    } catch (e) {
      _showError('Failed to change password: ${e.toString()}');
      log('--> [PendingTaskController] Error changing password: $e');
    } finally {
      presenter.setTaskLoading('setPassword', false);
    }
  }

  @override
  Future<void> logout() async {
    try {
      presenter.setLogoutLoading(true);

      await useCase.logout();

      // Clear all cache on logout
      try {
        final pendingTaskService = Get.find<PendingTaskService>();
        pendingTaskService.clearCache();
        log('--> [PendingTaskController] All cache cleared on logout');
      } catch (e) {
        log('--> [PendingTaskController] Failed to clear cache on logout: $e');
      }

      // Navigate to login
      NavigationService.offAll(AppRoutes.login);

      _showSuccess('Logged out successfully');
      log('--> [PendingTaskController] User logged out');
    } catch (e) {
      _showError('Failed to logout: ${e.toString()}');
      log('--> [PendingTaskController] Error during logout: $e');
    } finally {
      presenter.setLogoutLoading(false);
    }
  }

  void _showSuccess(String message) =>
      SnackbarServiceHelper.showSuccess(message, position: SnackPosition.TOP);

  void _showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );
}
