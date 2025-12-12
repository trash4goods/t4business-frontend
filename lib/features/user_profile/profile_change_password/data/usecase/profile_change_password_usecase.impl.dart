import 'package:t4g_for_business/features/user_profile/profile_change_password/data/repository/profile_change_password_repository.interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_change_password/data/usecase/profile_change_password_usecase.interface.dart';
import '../models/change_password_model.dart';

class ProfileChangePasswordUseCaseImpl
    implements ProfileChangePasswordUseCaseInterface {
  ProfileChangePasswordUseCaseImpl(this._repository);

  final ProfileChangePasswordRepositoryInterface _repository;

  @override
  Future<void> changePassword(ChangePasswordModel model) async {
    try {
      await _repository.changePassword(model);
    } catch (e) {
      throw Exception(e);
    }
  }
}
