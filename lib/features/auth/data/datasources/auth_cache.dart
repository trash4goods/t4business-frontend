import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/app/constants.dart';
import '../../../../utils/helpers/local_storage.dart';
import '../models/user_auth/user_auth_model.dart';

class AuthCacheDataSource {
  AuthCacheDataSource._();

  static final AuthCacheDataSource instance = AuthCacheDataSource._();

  late final Box<UserAuthModel> _userAuthBox;

  Future<void> init() async {
    _userAuthBox = await Hive.openBox<UserAuthModel>(AppConstants.userAuthBoxKey);
  }

  Future<void> saveUserAuth(UserAuthModel userAuth) async {
    try {
      await _userAuthBox.put(AppConstants.tokenKey, userAuth);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserAuthModel?> getUserAuth() async {
    try {
      return _userAuthBox.get(AppConstants.tokenKey);
    } catch (e) {
      rethrow;
    }
  }

    Future<String?> getT4GToken() async {
    try {
      return LocalStorageHelper.getString(AppConstants.t4gTokenKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearUserAuth() async {
    try {
      await _userAuthBox.delete(AppConstants.tokenKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      await _userAuthBox.close();
    } catch (e) {
      rethrow;
    }
  }
}