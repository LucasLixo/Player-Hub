import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
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
  }

  void loadSongs(List<SongModel> songList) {
    songs = songList;
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  chargeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong(String? uri, int index) {
    playerIndex.value = index;
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    audioPlayer.play();
    isPlaying.value = true;
    updatePosition();
  }

  previousSong() {
    if (playerIndex.value > 0) {
      playSong(songs[playerIndex.value - 1].uri, playerIndex.value - 1);
    } else {
      playSong(songs[songs.length - 1].uri, songs.length - 1);
    }
  }

  nextSong() {
    if (playerIndex.value < songs.length - 1) {
      playSong(songs[playerIndex.value + 1].uri, playerIndex.value + 1);
    } else {
      playSong(songs[0].uri, 0);
    }
  }
}
