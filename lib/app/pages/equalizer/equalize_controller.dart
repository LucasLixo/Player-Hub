import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/types/app_functions.dart';

class EqualizerController extends GetxController with AppFunctions {
  // ==================================================
  final Rx<List<int>?> bandLevelRange = Rxn<List<int>>();
  final Rx<List<int>?> bandCenterFrequencies = Rxn<List<int>>();

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
  @override
  void onReady() {
    super.onReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeBand();
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
        sharedController
            .getShared<List<double>>(SharedAttributes.frequency)[i]
            .toInt(),
      );
    }

    await EqualizerFlutter.setEnabled(
      sharedController.getShared<bool>(SharedAttributes.equalizeMode),
    );
  }

  // ==================================================
  Future<void> initializeBand() async {
    if (bandLevelRange.value == null) {
      try {
        bandLevelRange.value = await EqualizerFlutter.getBandLevelRange();
      } catch (e) {
        bandLevelRange.value = null;
      }
    }
    if (bandCenterFrequencies.value == null) {
      try {
        bandCenterFrequencies.value =
            await EqualizerFlutter.getCenterBandFreqs();
      } catch (e) {
        bandCenterFrequencies.value = null;
      }
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
        sharedController
            .getShared<List<double>>(SharedAttributes.frequency)[i]
            .toInt(),
      );
    }
    await showToast(value
        ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
        : "${'setting_equalizer'.tr} ${'app_disable'.tr}");
  }
}
