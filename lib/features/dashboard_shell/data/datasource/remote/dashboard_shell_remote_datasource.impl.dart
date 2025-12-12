import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard_shell_remote_datasource.interface.dart';

class DashboardShellRemoteDataSourceImpl implements DashboardShellRemoteDataSourceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}