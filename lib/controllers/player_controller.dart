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
  }

  void loadSongs(List<SongModel> songList) {
    songs = songList;
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
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
    playerIndex.value = index;

    await audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(songs[index].uri!),
        tag: MediaItem(
          id: songs[index].id.toString(),
          title: songs[index].displayName,
          artist: songs[index].artist,
          artUri: null,
        ),
      ),
    );
    await audioPlayer.play();
    updatePosition();
  }

  void previousSong() {
    if (playerIndex.value > 0) {
      playSong(playerIndex.value - 1);
    } else {
      playSong(songs.length - 1);
    }
  }

  void nextSong() {
    if (playerIndex.value < songs.length - 1) {
      playSong(playerIndex.value + 1);
    } else {
      playSong(0);
    }
  }
}
