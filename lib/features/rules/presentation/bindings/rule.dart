import 'package:get/get.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../controllers/implementation/rule.dart';
import '../controllers/interface/rule.dart';
import '../presenters/implementation/rule.dart';
import '../presenters/interface/rule.dart';

class RulesBinding extends Bindings {
  @override
  void dependencies() {
    // Register controller first
    Get.lazyPut<RulesControllerInterface>(
      () => RulesControllerImpl(),
      fenix: true,
    );
    
    // Register presenter with controller dependency
    Get.lazyPut<RulesPresenterInterface>(
      () => RulesPresenterImpl(
        controller: Get.find<RulesControllerInterface>(),
        dashboardShellController: Get.find<DashboardShellControllerInterface>(),
      ),
      fenix: true,
    );
  }
}
