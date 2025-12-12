import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/app/api_endpoints.dart';
import '../../../../core/app/api_method.dart';
import '../../../../core/app/firebase_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/http_interface.dart';
import '../../../auth/data/models/firebase_user_pending_task_model.dart';
import 'pending_task_remote_datasource_interface.dart';

class PendingTaskRemoteDataSourceImpl
    implements PendingTaskRemoteDataSourceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final IHttp http;
  final AuthService authService;

  PendingTaskRemoteDataSourceImpl({
    required this.http,
    required this.authService,
  });

  @override
  Stream<List<FirebaseUserPendingTaskModel>> getPendingTasksStream(String uid) {
    return _firestore
        .collection(FirebaseConstants.users)
        .doc(FirebaseConstants.pendingTasks)
        .collection(uid)
        .snapshots()
        .map((snapshot) {
          log(
            '--> [PendingTaskRemoteDataSource] Got ${snapshot.docs.length} pending tasks',
          );
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['type'] = doc.id;
            return FirebaseUserPendingTaskModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> updateTaskStatus(
    String uid,
    String taskType,
    PendingTaskStatus status,
  ) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(FirebaseConstants.pendingTasks)
          .collection(uid)
          .doc(taskType)
          .update({'status': status.name});

      log(
        '--> [PendingTaskRemoteDataSource] Updated task $taskType status to ${status.name}',
      );
    } catch (e) {
      log('--> [PendingTaskRemoteDataSource] Error updating task status: $e');
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    try {
      // Prepare request body
      final body = {
        'old_password': oldPassword,
        'new_password': newPassword,
      };

      // Make API call
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: ApiEndpoints.changePassword,
        body: body,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        isDevEnv: true,
        isAuthenticationRequired: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('--> [PendingTaskRemoteDataSource] Password changed successfully');
      } else {
        throw Exception('Failed to change password: ${response.response}');
      }
    } catch (e) {
      log('--> [PendingTaskRemoteDataSource] Error changing password: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Use AuthService to handle logout
      await authService.logout();

      log('--> [PendingTaskRemoteDataSource] User logged out successfully');
    } catch (e) {
      log('--> [PendingTaskRemoteDataSource] Error during logout: $e');
      rethrow;
    }
  }
}
