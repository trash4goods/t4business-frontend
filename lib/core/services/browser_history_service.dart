import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';

import '../app/app_routes.dart';
import '../services/auth_service.dart';

/// Service to manage browser back button behavior for protected routes
/// Prevents authenticated users from going back to splash/login pages
class BrowserHistoryService extends GetxService {
  static BrowserHistoryService get to => Get.find();

  // Protected routes where back button should be controlled
  static const List<String> _protectedRoutes = [
    AppRoutes.dashboard,
    AppRoutes.profile,
    AppRoutes.productManagement,
  ];

  // Routes that authenticated users shouldn't access via back button
  static const List<String> _restrictedRoutesWhenAuthenticated = [
    AppRoutes.splash,
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.forgotPassword,
  ];

  bool _isListening = false;
  bool _isHandlingBackButton = false; // Prevent recursive handling
  String? _currentProtectedRoute;
  int _initialHistoryLength = 0;

  @override
  void onInit() {
    super.onInit();
    _initBrowserHistoryControl();
  }

  /// Initialize browser history control for web platform
  void _initBrowserHistoryControl() {
    if (!kIsWeb) return;

    // Store initial history length
    _initialHistoryLength = html.window.history.length;

    _setupPopstateListener();
    _setupAuthStateListener();
  }

  /// Setup auth state listener to handle authentication changes
  void _setupAuthStateListener() {
    try {
      User? previousUser;

      // Listen to Firebase auth state changes directly
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        final isAuthenticated = user != null;
        final wasAuthenticated = previousUser != null;

        print(
          'BrowserHistory: Auth state changed - authenticated: $isAuthenticated (was: $wasAuthenticated)',
        );

        // Only clear protection if user actually logged out (was authenticated, now not)
        if (wasAuthenticated && !isAuthenticated) {
          print('BrowserHistory: User logged out, clearing protection');
          _clearProtectionAndHistory();
        }

        previousUser = user;
      });
    } catch (e) {
      print('BrowserHistory: Failed to setup auth listener: $e');
    }
  }

  /// Clear all protection and clean browser history
  void _clearProtectionAndHistory() {
    if (!kIsWeb) return;

    print('BrowserHistory: Clearing protection and cleaning history');

    // Reset tracking variables
    _currentProtectedRoute = null;
    _isHandlingBackButton = false;

    // Get the current actual route
    final currentRoute = _getCurrentRouteFromBrowser();

    // Replace current state to clean up any polluted history
    html.window.history.replaceState(null, '', currentRoute);

    print('BrowserHistory: History cleaned, protection cleared');
  }

  /// Setup popstate listener for browser back button
  void _setupPopstateListener() {
    if (!kIsWeb || _isListening) return;

    html.window.onPopState.listen((event) {
      _handleBackButtonPress();
    });

    _isListening = true;
    print('BrowserHistory: Popstate listener enabled');
  }

  /// Handle browser back button press
  void _handleBackButtonPress() {
    // Prevent recursive handling
    if (_isHandlingBackButton) return;
    _isHandlingBackButton = true;

    // Get current route from browser location instead of Get.currentRoute
    final currentRoute = _getCurrentRouteFromBrowser();

    try {
      final authService = Get.find<AuthService>();

      print('BrowserHistory: Back button pressed on route $currentRoute');
      print(
        'BrowserHistory: User authenticated: ${authService.isAuthenticated}',
      );

      // If user is authenticated and on a protected route
      if (authService.isAuthenticated && _isProtectedRoute(currentRoute)) {
        print(
          'BrowserHistory: Preventing back navigation from protected route',
        );

        // Prevent the back navigation by pushing the current route forward
        html.window.history.pushState(null, '', currentRoute);

        // Show a user-friendly message
        _showBackNavigationWarning();

        _isHandlingBackButton = false;
        return;
      }

      // If user is authenticated but tries to go back to restricted routes
      if (authService.isAuthenticated &&
          _isRestrictedRouteWhenAuthenticated(currentRoute)) {
        print(
          'BrowserHistory: Redirecting authenticated user away from $currentRoute',
        );

        // Prevent the navigation and redirect to dashboard
        html.window.history.pushState(null, '', AppRoutes.dashboard);

        // Use a delayed navigation to avoid conflicts
        Future.delayed(const Duration(milliseconds: 10), () {
          Get.offAllNamed(AppRoutes.dashboard);
        });

        _isHandlingBackButton = false;
        return;
      }

      // CRITICAL FIX: If user is NOT authenticated but tries to access protected routes
      if (!authService.isAuthenticated && _isProtectedRoute(currentRoute)) {
        print(
          'BrowserHistory: Blocking unauthenticated access to protected route $currentRoute',
        );

        // Prevent the navigation and redirect to login
        html.window.history.pushState(null, '', AppRoutes.login);

        // Use a delayed navigation to avoid conflicts
        Future.delayed(const Duration(milliseconds: 10), () {
          Get.offAllNamed(AppRoutes.login);
        });

        _isHandlingBackButton = false;
        return;
      }
    } catch (e) {
      print('BrowserHistory: Error checking auth state: $e');
      // If we can't determine auth state, be safe and allow navigation
    }

    _isHandlingBackButton = false;
  }

  /// Get current route from browser location
  String _getCurrentRouteFromBrowser() {
    if (!kIsWeb) return '';

    final location = html.window.location;
    String route = location.pathname ?? '';

    // Handle empty or root routes
    if (route.isEmpty || route == '/') {
      // Check if we're actually on a specific route based on URL hash or other indicators
      final hash = location.hash;
      if (hash.isNotEmpty && hash.startsWith('#')) {
        route = hash.substring(1); // Remove the # symbol
      } else {
        route = AppRoutes.splash; // Default to splash for root
      }
    }

    print(
      'BrowserHistory: Current browser route: $route (pathname: ${location.pathname}, hash: ${location.hash})',
    );
    return route;
  }

  /// Enable back button protection by setting up proper navigation state
  void enableBackButtonProtection() {
    if (!kIsWeb) return;

    final authService = Get.find<AuthService>();
    if (!authService.isAuthenticated) return;

    final currentRoute = _getCurrentRouteFromBrowser();
    _currentProtectedRoute = currentRoute;

    print('BrowserHistory: Enabling back button protection for $currentRoute');

    // Only enable if we're actually on a protected route
    if (_isProtectedRoute(currentRoute)) {
      // Add a history entry to prevent going back
      html.window.history.pushState(null, '', currentRoute);
    }
  }

  /// Show warning when user tries to navigate back from protected route
  void _showBackNavigationWarning() {
    Get.snackbar(
      'Navigation Restricted',
      'Use the app navigation to move between pages',
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Check if route is protected
  bool _isProtectedRoute(String route) {
    return _protectedRoutes.any(
      (protectedRoute) => route.startsWith(protectedRoute),
    );
  }

  /// Check if route should be restricted for authenticated users
  bool _isRestrictedRouteWhenAuthenticated(String route) {
    return _restrictedRoutesWhenAuthenticated.any(
      (restrictedRoute) => route.startsWith(restrictedRoute),
    );
  }

  /// Force navigation to dashboard if user tries to access restricted routes
  void handleRestrictedRouteAccess(String route) {
    final authService = Get.find<AuthService>();

    if (authService.isAuthenticated &&
        _isRestrictedRouteWhenAuthenticated(route)) {
      print(
        'BrowserHistory: Redirecting authenticated user from $route to dashboard',
      );
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  /// Reset history protection (useful when logging out)
  void resetProtection() {
    _clearProtectionAndHistory();
    print('BrowserHistory: Protection reset');
  }

  @override
  void onClose() {
    _isListening = false;
    super.onClose();
  }
}
