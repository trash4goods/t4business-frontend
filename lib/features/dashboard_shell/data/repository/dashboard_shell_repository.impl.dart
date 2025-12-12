import '../../../../core/app/constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../utils/helpers/local_storage.dart';
import '../../../auth/data/datasources/auth_cache.dart';
import '../../../auth/data/datasources/interface/login_remote_datasource_interface.dart';
import '../datasource/remote/dashboard_shell_remote_datasource.interface.dart';
import 'dashboard_shell_repository.interface.dart';

class DashboardShellRepositoryImpl implements DashboardShellRepositoryInterface {
  final DashboardShellRemoteDataSourceInterface remoteDataSource;
  final LoginRemoteDatasourceInterface loginDataSource;

  DashboardShellRepositoryImpl({required this.remoteDataSource, required this.loginDataSource});

  @override
  Future<void> signOut() async {
    try {
      final token = await LocalStorageHelper.getString(AppConstants.tokenKey);
      if (token != null) {
        await loginDataSource.logout(token);
        await remoteDataSource.signOut();
        await AuthService.instance.logout();
        await AuthCacheDataSource.instance.clearUserAuth();
      } else {
        throw Exception('Sign out failed. token not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}