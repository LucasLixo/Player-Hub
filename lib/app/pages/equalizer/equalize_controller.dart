import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:get/get.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/types/app_functions.dart';

class EqualizerController extends GetxController with AppFunctions {
  // ==================================================
  Rx<List<int>?> bandLevelRange = Rxn<List<int>>();
  Rx<List<int>?> bandCenterFrequencies = Rxn<List<int>>();

  // ==================================================
  final PlayerController playerController = Get.find<PlayerController>();
  final AppShared sharedController = Get.find<AppShared>();

  // ==================================================
  @override
  void onInit() {
    super.onInit();

    playerController.audioPlayer.androidAudioSessionIdStream
        .listen((int? id) async {
      await _initializeEqualizer(id ?? 0);
    });
  }

  // ==================================================
  Future<void> _initializeEqualizer(int id) async {
    await EqualizerFlutter.init(id);
    await EqualizerFlutter.open(id);
    await EqualizerFlutter.setAudioSessionId(id);

    await initializeBand();

    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        sharedController.getShared(SharedAttributes.frequency)[i].toInt(),
      );
    }

    await EqualizerFlutter.setEnabled(
      sharedController.getShared(SharedAttributes.equalizeMode) as bool,
    );
  }

  // ==================================================
  Future<void> initializeBand() async {
    try {
      bandLevelRange.value = await EqualizerFlutter.getBandLevelRange();
      bandCenterFrequencies.value = await EqualizerFlutter.getCenterBandFreqs();
    } catch (e) {
      bandLevelRange.value = null;
      bandCenterFrequencies.value = null;
    }
  }

  // ==================================================
  Future<void> toggleEqualizer(bool value) async {
    await initializeBand();
    await sharedController.setShared(
      SharedAttributes.equalizeMode,
      value,
    );
    await EqualizerFlutter.setEnabled(value);
    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        sharedController.getShared(SharedAttributes.frequency)[i].toInt(),
      );
    }
    await showToast(value
        ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
        : "${'setting_equalizer'.tr} ${'app_disable'.tr}");
  }
}
