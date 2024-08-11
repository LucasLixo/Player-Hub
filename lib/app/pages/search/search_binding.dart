import 'package:get/instance_manager.dart';

import '../../core/player/player_export.dart';

class SearchBinding extends Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerStateController>(PlayerStateController());
    Get.put<PlayerController>(PlayerController());
  }
}
