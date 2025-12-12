import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_auth_model.dart';

import '../../../../../core/app/api_endpoints.dart';
import '../../../../../core/app/api_method.dart';
import '../../../../../core/app/constants.dart';
import '../../../../../core/app/firebase_constants.dart';
import '../../../../../core/services/http_interface.dart';
import '../../../../../utils/helpers/local_storage.dart';
import '../../models/firebase_user_pending_task_model.dart';
import '../interface/login_remote_datasource_interface.dart';

class LoginRemoteDatasourceImpl implements LoginRemoteDatasourceInterface {
  IHttp http;
  LoginRemoteDatasourceImpl(this.http);

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await http
          .requestHttp(
            context: Get.context!,
            method: APIMethod.post,
            endpoint: ApiEndpoints.forgotPassword,
            isDevEnv: true,
            body: {'email': email},
          )
          .then(
            (value) =>
                log('[LoginRemoteDatasourceImpl] response: ${value.response}'),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserAuthModel?> signIn(String email, String password) async {
    try {
      final basicAuth =
          'Basic ${base64.encode(utf8.encode('${email.trim()}:$password'))}';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.login,
        headers: {'Authorization': basicAuth},
        isDevEnv: true,
      );

      if (response.response != null) {
        // save token in the cache
        await LocalStorageHelper.saveString(
          AppConstants.tokenKey,
          response.response['result']['access_token'],
        );
      }

      log('[LoginRemoteDatasourceImpl] response: ${response.response}');
      return response.response != null
          ? UserAuthModel.fromJson(response.response['result'])
          : null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await http
          .requestHttp(
            context: Get.context!,
            method: APIMethod.post,
            endpoint: ApiEndpoints.verifyEmail,
            isDevEnv: true,
            body: {'token': token},
          )
          .then(
            (value) =>
                log('[LoginRemoteDatasourceImpl] response: ${value.response}'),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await http
          .requestHttp(
            context: Get.context!,
            method: APIMethod.delete,
            endpoint: ApiEndpoints.login,
            isDevEnv: true,
            headers: {'Authorization': 'Bearer $token'},
          )
          .then(
            (value) =>
                log('[LoginRemoteDatasourceImpl] response: ${value.response}'),
          );
      await LocalStorageHelper.remove(AppConstants.tokenKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkEmailVerification(String token, String email) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        headers: {'Authorization': 'Bearer $token'},
        endpoint: '${ApiEndpoints.checkEmailVerification}/$email',
        isDevEnv: true,
      );
      return response.response['message'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createPendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection(FirebaseConstants.users)
          .doc(FirebaseConstants.pendingTasks)
          .collection(uid)
          .doc(task.type?.name)
          .set(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection(FirebaseConstants.users)
          .doc(FirebaseConstants.pendingTasks)
          .collection(uid)
          .doc(task.type?.name)
          .update(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> anyTaskPending(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final doc =
          await firestore
              .collection(FirebaseConstants.users)
              .doc(FirebaseConstants.pendingTasks)
              .collection(uid)
              .where('status', isEqualTo: PendingTaskStatus.pending.name)
              .get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final doc =
          await firestore
              .collection(FirebaseConstants.users)
              .doc(FirebaseConstants.pendingTasks)
              .collection(uid)
              .where('status', isEqualTo: PendingTaskStatus.pending.name)
              .get();
      if (doc.docs.isNotEmpty) {
        return doc.docs
            .map((e) => FirebaseUserPendingTaskModel.fromJson(e.data()))
            .toList();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
