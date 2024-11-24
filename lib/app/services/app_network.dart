import 'package:get/state_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppNetwork extends GetxService {
  // ==================================================
  final RxBool isConnectivity = false.obs;

  // ==================================================
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // ==================================================
  void _updateConnectionStatus(
    List<ConnectivityResult> connectivityResult,
  ) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isConnectivity.value = false;
    } else {
      isConnectivity.value = true;
    }
  }
}
