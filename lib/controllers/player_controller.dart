import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  RxInt playerIndex = 0.obs;
  RxBool isPlaying = false.obs;

  RxString duration = ''.obs;
  RxString position = ''.obs;

  RxDouble max = 0.0.obs;
  RxDouble value = 0.0.obs;

  List<SongModel> songs = [];

  RxBool shufflePlaylist = false.obs;

  RxBool isLooping = false.obs;
  RxBool isShuffle = false.obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        nextSong();
      }
    });
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        playerIndex.value = index;
      }
    });
    updatePosition();
  }

  Future<void> loadSongs(List<SongModel> songList) async {
    songs = songList;

    List<AudioSource> playlist = songs.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.displayName,
          artist: song.artist,
        ),
      );
    }).toList();

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: playlist),
      initialIndex: playerIndex.value,
    );
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        duration.value = d.toString().split(".")[0];
        max.value = d.inSeconds.toDouble();
      }
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  void chargeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  Future<void> playSong(int index) async {
    if (playerIndex.value != index) {
      playerIndex.value = index;
      await audioPlayer.seek(Duration.zero, index: index);
    }
    await audioPlayer.play();
    isPlaying.value = true;
    updatePosition();
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  Future<void> nextSong() async {
    if (songs.isNotEmpty) {
      await audioPlayer.seekToNext();
    }
  }

  Future<void> previousSong() async {
    if (songs.isNotEmpty) {
      await audioPlayer.seekToPrevious();
    }
  }

  Future<void> shufflePlaylistToggle() async {
    isShuffle.value = !isShuffle.value;
    if (isShuffle.value) {
      await audioPlayer.setShuffleModeEnabled(true);
    } else {
      await audioPlayer.setShuffleModeEnabled(false);
    }
  }

  void toggleLooping() {
    isLooping.value = !isLooping.value;
    if (isLooping.value) {
      audioPlayer.setLoopMode(LoopMode.one);
    } else {
      audioPlayer.setLoopMode(LoopMode.off);
    }
  }
}
