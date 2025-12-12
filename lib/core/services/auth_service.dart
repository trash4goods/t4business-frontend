import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/auth/domain/entities/user.dart';
import 'browser_history_service.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();

  final _firebaseuser = Rxn<User>();
  final _isAuthenticated = RxBool(false);

  bool get isAuthenticated => _isAuthenticated.value;
  User? get user => _firebaseuser.value;

  Future<AuthService> init() async {
    _firebaseuser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Critical: Listen to user changes and update authentication status
    _firebaseuser.listen((User? user) {
      _isAuthenticated.value = user != null;
      log(
        'AuthService state changed - authenticated: ${_isAuthenticated.value}',
      );
      if (user != null) {
        log('User authenticated: ${user.uid}');
      } else {
        log('User signed out');
      }
    });

    log('AuthService initialized with user: ${_firebaseuser.value?.uid}');
    return this;
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Reset browser history protection on logout
      try {
        final historyService = BrowserHistoryService.to;
        historyService.resetProtection();
      } catch (e) {
        log('Failed to reset browser history protection: $e');
      }
    } catch (e) {
      log('Logout error: $e');
      rethrow;
    }
  }

  Future<UserEntity?> execute(String email, String password) async {
    try {
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(
        email: response.user?.email ?? '',
        token: await response.user?.getIdToken(),
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserCredential?> signInWithGoogle(String email) async {
    try {
      // For web, use signInWithPopup with proper error handling
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Add required scopes
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final UserCredential result = await FirebaseAuth.instance.signInWithPopup(
        googleProvider,
      );

      // Check if user is allowed (implement your business logic here)
      if (result.user != null) {
        // Add your validation logic here to check if user is allowed
        // For now, we'll allow all Google sign-ins
        return result;
      }

      return null;
    } catch (e) {
      log('Google sign-in error: $e');

      // Handle specific error cases
      if (e.toString().contains('popup-closed-by-user')) {
        throw Exception('Sign-in was cancelled by user');
      } else if (e.toString().contains('popup-blocked')) {
        throw Exception('Popup was blocked by browser');
      }

      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
