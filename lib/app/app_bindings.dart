import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PlayerController>(
      PlayerController(),
      permanent: true,
    );
  }
}
