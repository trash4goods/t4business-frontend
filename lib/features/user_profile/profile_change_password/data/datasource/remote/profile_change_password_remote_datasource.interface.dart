import '../../models/change_password_model.dart';

abstract class ProfileChangePasswordRemoteDataSourceInterface {
  Future<void> changePassword(ChangePasswordModel model);
}