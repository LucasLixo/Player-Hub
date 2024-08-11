import 'package:get/instance_manager.dart';

import '../../core/player/player_export.dart';

class PlaylistBinding extends Bindings {
  
  @override
  void dependencies() {
    Get.put<PlayerController>(PlayerController());
  }
}
