import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/pages/selection/selection_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PlayerController>(
      PlayerController(),
      permanent: true,
    );
    /* Get.put<EqualizerController>(
      EqualizerController(),
      permanent: true,
    ); */
  }

  void selectionController() {
    Get.lazyPut<SelectionController>(
      () => SelectionController(),
      fenix: true,
    );
  }
}
