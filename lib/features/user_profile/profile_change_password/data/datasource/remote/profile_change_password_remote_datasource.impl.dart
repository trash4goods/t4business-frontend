import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_change_password/data/datasource/remote/profile_change_password_remote_datasource.interface.dart';

import '../../../../../../core/app/api_endpoints.dart';
import '../../../../../../core/app/api_method.dart';
import '../../../../../../core/app/constants.dart';
import '../../../../../../utils/helpers/local_storage.dart';
import '../../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../models/change_password_model.dart';

class ProfileChangePasswordRemoteDataSourceImpl
    implements ProfileChangePasswordRemoteDataSourceInterface {
  ProfileChangePasswordRemoteDataSourceImpl(this._iHttp);

  final IHttp _iHttp;

  @override
  Future<void> changePassword(ChangePasswordModel model) async {
    try {
      // Get current user token for authorization
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final token =
          await LocalStorageHelper.getString(AppConstants.tokenKey) ?? '';

      // Prepare request body
      final body = {
        'old_password': model.oldPassword,
        'new_password': model.newPassword,
      };

      // Make API call
      final response = await _iHttp.requestHttp(
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

        // change firebase user password if succesfully
        await user.updatePassword(model.newPassword);

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: model.newPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await signIn(user.email!, model.newPassword);
      } else {
        throw Exception('Failed to change password: ${response.response}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserAuthModel?> signIn(String email, String password) async {
    try {
      final basicAuth =
          'Basic ${base64.encode(utf8.encode('${email.trim()}:$password'))}';

      final response = await _iHttp.requestHttp(
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
}
