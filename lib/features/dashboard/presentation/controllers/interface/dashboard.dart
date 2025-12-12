abstract class DashboardControllerInterface {
  void refreshData();
  // Sidebar functionality
  void toggleSidebar();
  Future<void> logout();
  void navigateToPage(String route);
}
