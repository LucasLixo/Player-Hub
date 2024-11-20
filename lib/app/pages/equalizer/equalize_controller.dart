import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:get/get.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/types/app_functions.dart';

class EqualizerController extends GetxController with AppFunctions {
  late List<int> bandLevelRange;
  late List<int> bandCenterFrequencies;

  final PlayerController playerController = Get.find<PlayerController>();

  @override
  void onInit() {
    super.onInit();

    _initializeBands();

    playerController.audioPlayer.androidAudioSessionIdStream
        .listen((int? id) async {
      await _initializeEqualizer(id ?? 0);
    });
  }

  Future<void> _initializeBands() async {
    final List<List<int>> dataResults = await Future.wait([
      EqualizerFlutter.getBandLevelRange(),
      EqualizerFlutter.getCenterBandFreqs(),
    ]);
    bandLevelRange = dataResults[0];
    bandCenterFrequencies = dataResults[1];
  }

  Future<void> _initializeEqualizer(int id) async {
    await EqualizerFlutter.init(id);
    await EqualizerFlutter.open(id);
    await EqualizerFlutter.setAudioSessionId(id);

    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        AppShared.getShared(SharedAttributes.frequency)[i].toInt(),
      );
    }

    await EqualizerFlutter.setEnabled(
      AppShared.getShared(SharedAttributes.equalizeMode) as bool,
    );
  }

  Future<void> toggleEqualizer(bool value) async {
    await AppShared.setShared(
      SharedAttributes.equalizeMode,
      value,
    );
    await EqualizerFlutter.setEnabled(value);
    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        AppShared.getShared(SharedAttributes.frequency)[i].toInt(),
      );
    }
    await showToast(value
        ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
        : "${'setting_equalizer'.tr} ${'app_disable'.tr}");
  }
}
