// core/app/routes/app_routes.dart
class AppRoutes {
  // Prevent instantiation
  const AppRoutes._();

  // guest routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // protected routes
  static const String pendingTasks = '/pending-tasks';
  // dashboard shell and its children
  static const String dashboardShell = '/dashboard-shell';
  static const String dashboard = '$dashboardShell/dashboard';
  static const String productManagement = '$dashboardShell/products';
  static const String marketplaceProducts =
      '$dashboardShell/marketplace-products';
  static const String rewards = '$dashboardShell/rewards';
  static const String profile = '$dashboardShell/profile';
  static const String profileSettings = '$profile/profile-settings';

  // Settings routes
  static const String profileChangePassword = '$profileSettings/change-password';
  static const String deleteAccount = '$profileSettings/delete-account';
  static const String transferOwnership = '$profileSettings/transfer-ownership';
  static const String manageTeam = '$profileSettings/manage-team';
  static const String leaveDepartment = '$profileSettings/leave-department';
  static const String answerInvite = '$profileSettings/answer-invite';
  static const String listPartners = '$profileSettings/list-partners';
  static const String rules = '$dashboardShell/rules';
  static const String rulesV2 = '$dashboardShell/rules';
}
