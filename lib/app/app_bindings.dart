import 'package:get/instance_manager.dart';

import 'core/controllers/player.dart';
import 'core/controllers/song_api.dart';

class AppBinding implements Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerStateController>(PlayerStateController());
    Get.put<PlayerController>(PlayerController());
    
    Get.put<ApiStateController>(ApiStateController());
    Get.put<ApiController>(ApiController());
    // Get.lazyPut(() => ApiController());
  }
}
