// core/services/navigation_service.dart
import 'package:get/get.dart';

class NavigationService {
  NavigationService._();

  static Future<T?> to<T>(String route, {dynamic arguments}) async {
    return Get.rootDelegate.toNamed<T>(route, arguments: arguments);
  }

  static Future<T?> offAll<T>(String route, {dynamic arguments}) async {
    return Get.rootDelegate.offAndToNamed<T>(route, arguments: arguments);
  }

  static Future<T?> off<T>(String route, {dynamic arguments}) async {
    return Get.rootDelegate.offNamed<T>(route, arguments: arguments);
  }

  static void back<T>({T? result}) {
    Get.rootDelegate.popRoute(result: result);
  }
}
