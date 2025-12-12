import 'package:t4g_for_business/features/dashboard/data/datasources/firebase_auth.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../utils/helpers/local_storage.dart';
import '../../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../interface/dashboard.dart';

class DashboardRepositoryImpl implements DashboardRepositoryInterface {
  DashboardRepositoryImpl(this._loginDataSource);

  final LoginRemoteDatasourceInterface _loginDataSource;

  @override
  Future<void> signOut() async {
    try {
      final token = await LocalStorageHelper.getString(AppConstants.tokenKey);
      if (token != null) {
        await _loginDataSource.logout(token);
      } else {
        throw Exception('Sign out failed. token not found');
      }
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
}
