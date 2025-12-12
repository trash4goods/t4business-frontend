import 'package:t4g_for_business/features/user_profile/profile_change_password/data/models/change_password_model.dart';

abstract class ProfileChangePasswordUseCaseInterface {
  Future<void> changePassword(ChangePasswordModel model);
}