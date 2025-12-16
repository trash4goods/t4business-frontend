import '../app/app_routes.dart';
import '../../features/auth/data/datasources/auth_cache.dart';

class MunicipalityUtils {
  static Future<bool> isMunicipalityUser() async {
    final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
    return cachedUser?.profile?.userPartnersDepartments?.any(
      (dept) => dept.department?.departmentType == "municipality"
    ) ?? false;
  }

  static List<String> getAllowedRoutes() {
    return [AppRoutes.rewards, AppRoutes.profile];
  }

  static List<String> getRestrictedRoutes() {
    return [
      AppRoutes.dashboard, 
      AppRoutes.productManagement, 
      AppRoutes.rulesV2
    ];
  }

  static String getDefaultRoute() {
    return AppRoutes.rewards;
  }

  static bool isRouteAllowed(String route) {
    return getAllowedRoutes().contains(route);
  }

  static bool isRouteRestricted(String route) {
    return getRestrictedRoutes().contains(route);
  }
}