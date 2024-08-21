import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import './just_audio_background.dart';
import '../../shared/utils/functions/get_artist.dart';
import '../../shared/utils/functions/get_image.dart';

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

  RxInt songIgnoreTime = 50.obs;

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
    songIgnoreTime.value = (prefs.getInt('songIgnoreTime') ?? 50);
  }

  List<SongModel> recentList = <SongModel>[];

  Future<void> updateRecentList(SongModel song) async {
    if (recentList.any((s) => s.id == song.id)) {
      recentList.removeWhere((s) => s.id == song.id);
    }
    recentList.insert(0, song);
  }

  // RxBool equalizer = false.obs;

  // Future<void> loadEqualizeValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   equalizer.value = (prefs.getBool('equalizer') ?? false);
  // }
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
    List<SongModel> songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
    );
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > playerState.songIgnoreTime.value * 1000)
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

    await songLoad(songList, 0);
  }

  Future<void> songLoad(List<SongModel> songList, int index) async {
    playerState.songList.value = songList;

    List<Future<String>> imageFutures = playerState.songList.map((song) {
      return getImage(id: song.id);
    }).toList();
    List<String> images = await Future.wait(imageFutures);

    List<AudioSource> playlist =
        playerState.songList.asMap().entries.map((entry) {
      final song = entry.value;
      final art = images[entry.key];

      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: getArtist(artist: song.artist!),
          artUri: Uri.parse(art),
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

  // void resetPlaylist() {
  //   songLoad(playerState.songAllList, 0);
  // }
  SongModel findSongById(int id) {
    return playerState.songAllList.firstWhere(
      (song) => song.id == id,
    );
  }
}
