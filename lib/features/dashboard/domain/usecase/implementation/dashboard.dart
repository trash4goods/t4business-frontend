import '../../../data/repositories/interface/dashboard.dart';
import '../interface/dashboard.dart';

class DashboardUsecaseImpl implements DashboardUsecaseInterface {
  DashboardUsecaseImpl(this._repository);
  final DashboardRepositoryInterface _repository;

  @override
  Future<void> signOut() async {
    try {
      await _repository.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
}
