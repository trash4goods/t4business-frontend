import '../repository/dashboard_shell_repository.interface.dart';
import 'dashboard_shell_usecase.interface.dart';

class DashboardShellUsecaseImpl implements DashboardShellUsecaseInterface {
  final DashboardShellRepositoryInterface repository;
  DashboardShellUsecaseImpl(this.repository);
  
  @override
  Future<void> signOut() async {
    try {
      await repository.signOut();
    } catch (e) {
      rethrow;
    }
  }
}