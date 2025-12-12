import 'package:t4g_for_business/features/dashboard/data/datasources/firebase_auth.dart';

import '../interface/dashboard.dart';

class DashboardRepositoryImpl implements DashboardRepositoryInterface {
  DashboardRepositoryImpl(this._dataSource);

  final DashboardFirebaseAuthDataSource _dataSource;

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
}
