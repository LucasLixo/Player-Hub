import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerStateController extends GetxController {
  RxBool isPlaying = false.obs;
  RxBool isLooping = false.obs;
  RxBool isShuffle = false.obs;

  RxInt songIndex = 0.obs;

  RxString songDuration = ''.obs;
  RxString songPosition = ''.obs;
  RxDouble songDurationD = 0.0.obs;
  RxDouble songPositionD = 0.0.obs;

  RxList<SongModel> songAllList = <SongModel>[].obs;
  RxList<SongModel> songList = <SongModel>[].obs;
  
  RxList<String> folderList = <String>[].obs;

  void resetSongIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songIndex.value = 0;
    });
  }
}
