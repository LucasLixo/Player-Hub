import 'package:audio_service/audio_service.dart';
import 'package:get/instance_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:playerhub/app/core/controllers/just_audio_background.dart';
import 'package:playerhub/app/core/app_shared.dart';

class PlayerStateController extends GetxController {
  RxBool isPlaying = false.obs;
  RxBool isLooping = false.obs;
  RxBool isShuffle = false.obs;

  bool isRecent = false;

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

  RxMap<int, String> imageCache = <int, String>{}.obs;

  List<SongModel> recentList = <SongModel>[];

  Future<void> updateRecentList(SongModel song) async {
    if (recentList.any((s) => s.id == song.id)) {
      recentList.removeWhere((s) => s.id == song.id);
    }
    recentList.insert(0, song);
  }

  late SongModel currentSong;

  SongModel findSongById(int id) {
    return songAllList.firstWhere(
      (song) => song.id == id,
    );
  }
}

class PlayerController extends BaseAudioHandler with QueueHandler, SeekHandler {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  final audioBackground = JustAudioBackground();

  final playerState = Get.put(PlayerStateController());

  PlayerController() {
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        nextSong();
      }
    });
    audioPlayer.playerStateStream.listen((state) {
      playerState.isPlaying.value = state.playing;
    });
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        playerState.songIndex.value = index;
        if (!playerState.isRecent) {
          playerState.updateRecentList(playerState.songList[index]);
        }
      }
    });
    updatePosition();
  }

  Future<void> getAllSongs() async {
    switch (AppShared.defaultGetSongsValue.value) {
      case 0:
        await getAllSongsAdded();
        break;
      case 1:
        await getAllSongsAZ();
        break;
      case 2:
        await getAllSongsDuration();
        break;
    }
  }

  Future<void> getAllSongsAdded() async {
    List<SongModel> songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
    );
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > AppShared.ignoreTimeValue.value * 1000)
        .toList();
    await songAllLoad(songs);
  }

  Future<void> getAllSongsAZ() async {
    List<SongModel> songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.TITLE,
      uriType: UriType.EXTERNAL,
    );
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > AppShared.ignoreTimeValue.value * 1000)
        .toList();
    await songAllLoad(songs);
  }

  Future<void> getAllSongsDuration() async {
    List<SongModel> songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.DURATION,
      uriType: UriType.EXTERNAL,
    );
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > AppShared.ignoreTimeValue.value * 1000)
        .toList();
    await songAllLoad(songs);
  }

  List<SongModel> getSongsFromFolder(String folderPath) {
    return playerState.songList
        .where((song) => song.data.contains(folderPath))
        .toList();
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        playerState.songDuration.value = d.toString().split(".")[0];
        playerState.songDurationD.value = d.inSeconds.toDouble();
      }
    });
    audioPlayer.positionStream.listen((p) {
      playerState.songPosition.value = p.toString().split(".")[0];
      playerState.songPositionD.value = p.inSeconds.toDouble();
    });
  }

  void chargeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  Future<void> songAllLoad(List<SongModel> songList) async {
    playerState.songAllList.value = songList;

    for (var song in songList) {
      playerState.folderList
          .add(song.data.split('/')[song.data.split('/').length - 2]);
    }
    playerState.folderList.value = playerState.folderList.toSet().toList();

    for (var song in songList) {
      if (!playerState.imageCache.containsKey(song.id)) {
        final imagePath = await AppShared.getImage(id: song.id);
        playerState.imageCache[song.id] = imagePath;
      }
    }

    await songLoad(songList, 0);
  }

  Future<void> songLoad(List<SongModel> songList, int index) async {
    playerState.songList.value = songList;

    List<AudioSource> playlist = playerState.songList.map((song) {
      final imagePath = playerState.imageCache[song.id];

      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: AppShared.getArtist(song.id, song.artist!),
          artUri: imagePath != null ? Uri.file(imagePath) : null,
        ),
      );
    }).toList();

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: playlist,
        shuffleOrder: DefaultShuffleOrder(),
      ),
      initialIndex: index,
    );
  }

  Future<void> playSong(int? index) async {
    if (playerState.songIndex.value != index) {
      playerState.songIndex.value = index!;
      await audioPlayer.seek(Duration.zero, index: index);
    }
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    playerState.isPlaying.value = true;
    await audioPlayer.play();
    updatePosition();
  }

  Future<void> pauseSong() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    playerState.isPlaying.value = false;
    await audioPlayer.pause();
  }

  Future<void> nextSong() async {
    if (playerState.songList.isNotEmpty) {
      int currentIndex = playerState.songIndex.value;
      int lastIndex = playerState.songList.length - 1;

      if (currentIndex < lastIndex) {
        await audioBackground.nextSong();
      } else {
        await audioPlayer.seek(Duration.zero, index: 0);
      }
      await audioPlayer.play();
    }
  }

  Future<void> previousSong() async {
    if (playerState.songList.isNotEmpty) {
      int currentIndex = playerState.songIndex.value;

      if (currentIndex > 0) {
        await audioBackground.previousSong();
      } else {
        await audioPlayer.seek(Duration.zero,
            index: playerState.songList.length - 1);
      }
      await audioPlayer.play();
    }
  }

  Future<void> toggleShufflePlaylist() async {
    if (playerState.isShuffle.value) {
      playerState.isShuffle.value = false;
      await audioPlayer.setShuffleModeEnabled(false);
    } else {
      playerState.isShuffle.value = true;
      await audioPlayer.setShuffleModeEnabled(true);
    }
  }

  Future<void> toggleLooping() async {
    if (playerState.isLooping.value) {
      playerState.isLooping.value = false;
      await audioPlayer.setLoopMode(LoopMode.off);
    } else {
      playerState.isLooping.value = true;
      await audioPlayer.setLoopMode(LoopMode.one);
    }
  }
}
