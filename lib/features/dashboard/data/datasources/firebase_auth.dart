import 'package:firebase_auth/firebase_auth.dart';

class DashboardFirebaseAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
