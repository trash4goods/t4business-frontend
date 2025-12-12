class DepartmentManagmentUtils {
  static String formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'member':
        return 'Member';
      default:
        return role.substring(0, 1).toUpperCase() +
            role.substring(1).toLowerCase();
    }
  }
}
