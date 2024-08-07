import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'player_state.dart';

class PlayerController extends BaseAudioHandler with QueueHandler, SeekHandler {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

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
      }
    });
    updatePosition();
  }

  Future<List<SongModel>> getSongs() async {
    List<SongModel> songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: SongSortType.DATE_ADDED,
      uriType: UriType.EXTERNAL,
    );

    songs = songs.where((song) => song.duration! > 20000).toList();

    return songs;
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
    playerState.songAllList = songList;

    await songLoad(songList);
  }

  Future<void> songLoad(List<SongModel> songList) async {
    playerState.songList = songList;

    List<AudioSource> playlist = playerState.songList.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          artist: song.artist,
        ),
      );
    }).toList();

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: playlist),
      initialIndex: playerState.songIndex.value,
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
      int nextIndex =
          (audioPlayer.currentIndex! + 1) % playerState.songList.length;
      await audioPlayer.seek(Duration.zero, index: nextIndex);
      playerState.songIndex.value = nextIndex;
      await audioPlayer.play();
    }
  }

  Future<void> previousSong() async {
    if (playerState.songList.isNotEmpty) {
      int previousIndex = (audioPlayer.currentIndex! - 1) < 0
          ? playerState.songList.length - 1
          : audioPlayer.currentIndex! - 1;
      await audioPlayer.seek(Duration.zero, index: previousIndex);
      playerState.songIndex.value = previousIndex;
      await audioPlayer.play();
    }
  }

  Future<void> shufflePlaylistToggle() async {
    playerState.isShuffle.value = !playerState.isShuffle.value;
    if (playerState.isShuffle.value) {
      await audioPlayer.setShuffleModeEnabled(true);
    } else {
      await audioPlayer.setShuffleModeEnabled(false);
    }
  }

  Future<void> toggleLooping() async {
    playerState.isLooping.value = !playerState.isLooping.value;
    if (playerState.isLooping.value) {
      await audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await audioPlayer.setLoopMode(LoopMode.off);
    }
  }
}
