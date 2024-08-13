import 'package:get/instance_manager.dart';

import '../../core/player/player_export.dart';

class SplashBinding extends Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerStateController>(PlayerStateController());
  }
}
