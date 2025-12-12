import 'package:t4g_for_business/features/user_profile/profile_change_password/data/datasource/remote/profile_change_password_remote_datasource.interface.dart';
import '../models/change_password_model.dart';
import 'profile_change_password_repository.interface.dart';

class ProfileChangePasswordRepositoryImpl
    implements ProfileChangePasswordRepositoryInterface {
  ProfileChangePasswordRepositoryImpl(this._remoteDataSource);

  final ProfileChangePasswordRemoteDataSourceInterface _remoteDataSource;

  @override
  Future<void> changePassword(ChangePasswordModel model) async {
    try {
      await _remoteDataSource.changePassword(model);
    } catch (e) {
      throw Exception(e);
    }
  }
}
