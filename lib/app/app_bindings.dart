import 'package:get/instance_manager.dart';

import './core/controllers/player.dart';

class AppBinding implements Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerStateController>(PlayerStateController());
    Get.put<PlayerController>(PlayerController());
  }
}
