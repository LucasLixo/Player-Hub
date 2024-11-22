import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/pages/equalizer/equalize_controller.dart';
import 'package:player_hub/app/pages/selection/selection_controller.dart';
import 'package:player_hub/app/routes/app_routes.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PlayerController>(
      PlayerController(),
      permanent: true,
    );
  }

  void functionByRoute(String route) {
    switch (route) {
      case AppRoutes.equalizer:
        _equalizerController();
        break;
      case AppRoutes.selectionAdd:
      case AppRoutes.selectionRemove:
        _selectionController();
        break;
    }
  }

  void _selectionController() {
    Get.lazyPut<SelectionController>(
      () => SelectionController(),
      fenix: true,
    );
  }

  void _equalizerController() {
    Get.put<EqualizerController>(
      EqualizerController(),
      permanent: true,
    );
  }
}
