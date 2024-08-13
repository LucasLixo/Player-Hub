import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerStateController extends GetxController {
  RxBool isPlaying = false.obs;
  RxBool isLooping = false.obs;
  RxBool isShuffle = false.obs;

  RxInt songIndex = 0.obs;

  RxString songDuration = ''.obs;
  RxString songPosition = ''.obs;
  RxDouble songDurationD = 0.0.obs;
  RxDouble songPositionD = 0.0.obs;

  RxInt songIgnoreTime = 0.obs;

  RxList<SongModel> songAllList = <SongModel>[].obs;
  RxList<SongModel> songList = <SongModel>[].obs;

  RxList<String> folderList = <String>[].obs;

  void resetSongIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songIndex.value = 0;
    });
  }

  Future<void> loadSliderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    songIgnoreTime.value = (prefs.getInt('songIgnoreTime') ?? 0);
  }
}
