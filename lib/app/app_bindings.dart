import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class AppBinding implements Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerStateController>(PlayerStateController(), permanent: true);
    Get.put<PlayerController>(PlayerController(), permanent: true);
  }
}
