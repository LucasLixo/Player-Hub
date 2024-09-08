import 'package:audio_service/audio_service.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:playerhub/app/core/controllers/just_audio_background.dart';
import 'package:playerhub/app/core/app_shared.dart';

class PlayerStateController extends GetxController {
  // address of sound in list
  RxInt songIndex = 0.obs;
  RxInt songSession = 0.obs;

  // state play
  RxBool isPlaying = false.obs;

  // playback options
  RxBool isLooping = false.obs;
  RxBool isShuffle = false.obs;

  // position of sound
  RxString songDuration = ''.obs;
  RxString songPosition = ''.obs;
  RxDouble songDurationD = 0.0.obs;
  RxDouble songPositionD = 0.0.obs;

  // playlists
  RxList<SongModel> songAllList = <SongModel>[].obs;
  RxList<SongModel> songList = <SongModel>[].obs;

  // folder list
  RxList<String> folderList = <String>[].obs;
  RxMap<String, List<SongModel>> folderListSongs =
      <String, List<SongModel>>{}.obs;

  // image cache
  RxMap<int, String> imageCache = <int, String>{}.obs;

  // if in recent list
  RxBool isListRecent = false.obs;

  // recent list
  List<SongModel> recentList = <SongModel>[];

  // current song
  Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  // current image
  Rx<String?> currentImage = Rx<String?>(null);
}

class PlayerController extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _audioQuery = OnAudioQuery();
  final _audioBackground = JustAudioBackground();

  final audioPlayer = AudioPlayer();

  // PlayerStateController
  final _playerState = Get.find<PlayerStateController>();

  PlayerController() {
    // nextSong
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        nextSong();
      }
    });
    // pause or play
    audioPlayer.playerStateStream.listen((state) {
      _playerState.isPlaying.value = state.playing;
      if (_playerState.songSession.value == 0) {
        _playerState.songSession.value = audioPlayer.androidAudioSessionId ?? 0;
      }
    });
    // update index by list songs
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _playerState.songIndex.value = index;
        if (_playerState.songList.isNotEmpty) {
          // define current song
          _playerState.currentSong.value = _playerState.songList[index];
          // define current image
          if (_playerState.imageCache
              .containsKey(_playerState.currentSong.value!.id)) {
            _playerState.currentImage.value =
                _playerState.imageCache[_playerState.currentSong.value!.id];
          } else {
            _playerState.currentImage.value = null;
          }
          // refresh recent list
          if (!_playerState.isListRecent.value) {
            if (_playerState.recentList
                .any((s) => s.id == _playerState.songList[index].id)) {
              _playerState.recentList
                  .removeWhere((s) => s.id == _playerState.songList[index].id);
            }
            _playerState.recentList.insert(0, _playerState.songList[index]);
          }
        } else {
          _playerState.currentSong.value = null;
        }
      }
    });
    updatePosition();
  }

  // update position
  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        _playerState.songDuration.value = d.toString().split(".")[0];
        _playerState.songDurationD.value = d.inSeconds.toDouble();
      }
    });
    audioPlayer.positionStream.listen((p) {
      _playerState.songPosition.value = p.toString().split(".")[0];
      _playerState.songPositionD.value = p.inSeconds.toDouble();
    });
  }

  // charge duration in seconds
  void chargeDurationInSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  // Get Songs
  Future<void> getAllSongs() async {
    await pauseSong();
    _playerState.songIndex.value = 0;
    List<SongModel> songs = [];
    switch (AppShared.defaultGetSongsValue.value) {
      // by date added
      case 0:
        songs = await _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
        );
        break;
      // by A to Z
      case 1:
        songs = await _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.TITLE,
          uriType: UriType.EXTERNAL,
        );
        break;
      // by duration
      case 2:
        songs = await _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DURATION,
          uriType: UriType.EXTERNAL,
        );
        break;
    }

    // remove songs by duration
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > AppShared.ignoreTimeValue.value * 1000)
        .toList();
    await songAllLoad(songs);
  }

  // songs defined in state
  Future<void> songAllLoad(List<SongModel> songList) async {
    _playerState.songAllList.value = songList;

    for (var song in songList) {
      _playerState.folderList
          .add(song.data.split('/')[song.data.split('/').length - 2]);
    }
    _playerState.folderList.value = _playerState.folderList.toSet().toList();

    // folders list in songs
    _playerState.folderListSongs.clear();
    for (var folder in _playerState.folderList) {
      List<SongModel> songsInFolder =
          songList.where((song) => song.data.contains(folder)).toList();
      _playerState.folderListSongs[folder] = songsInFolder;
    }

    // image cache
    for (var song in songList) {
      if (!_playerState.imageCache.containsKey(song.id)) {
        final imagePath = await AppShared.getImage(id: song.id);
        _playerState.imageCache[song.id] = imagePath;
      }
    }

    await songLoad(songList, 0);
  }

  // defined songs in background
  Future<void> songLoad(List<SongModel> songList, int index) async {
    _playerState.songList.value = songList;

    List<AudioSource> playlist = _playerState.songList.map((song) {
      final imagePath = _playerState.imageCache[song.id];
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

    // mode playlist
    switch (AppShared.playlistModeValue.value) {
      // mode loop playlist
      case 0:
        await modeShfflePlaylist();
        break;
      // mode loop song
      case 1:
        await modeLoopPlaylist();
        break;
      // mode shuffle
      case 2:
        await modeLoopSong();
        break;
    }
  }

  // define play in current song
  Future<void> playSong(int? index) async {
    if (_playerState.songIndex.value != index) {
      _playerState.songIndex.value = index!;
      await audioPlayer.seek(Duration.zero, index: index);
    }
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    _playerState.isPlaying.value = true;
    await audioPlayer.play();
    updatePosition();
  }

  // define pause in current song
  Future<void> pauseSong() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    _playerState.isPlaying.value = false;
    await audioPlayer.pause();
  }

  // define next song in current song
  Future<void> nextSong() async {
    if (_playerState.songList.isNotEmpty) {
      int currentIndex = _playerState.songIndex.value;
      int lastIndex = _playerState.songList.length - 1;

      if (currentIndex < lastIndex) {
        await _audioBackground.nextSong();
      } else {
        await audioPlayer.seek(Duration.zero, index: 0);
      }
      await audioPlayer.play();
    }
  }

  // define previous song in current song
  Future<void> previousSong() async {
    if (_playerState.songList.isNotEmpty) {
      int currentIndex = _playerState.songIndex.value;

      if (currentIndex > 0) {
        await _audioBackground.previousSong();
      } else {
        await audioPlayer.seek(Duration.zero,
            index: _playerState.songList.length - 1);
      }
      await audioPlayer.play();
    }
  }

  Future<void> modeLoopPlaylist() async {
    _playerState.isLooping.value = false;
    _playerState.isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  Future<void> modeLoopSong() async {
    _playerState.isLooping.value = true;
    _playerState.isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.one);
  }

  Future<void> modeShfflePlaylist() async {
    _playerState.isLooping.value = false;
    _playerState.isShuffle.value = true;
    await audioPlayer.setShuffleModeEnabled(true);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // toggle play and pause
  Future<void> togglePlayPause() async {
    if (_playerState.isPlaying.value) {
      await pauseSong();
    } else {
      await playSong(_playerState.songIndex.value);
    }
  }

  Future<void> togglePlaylist() async {
    switch (AppShared.playlistModeValue.value) {
      // mode loop playlist
      case 0:
        await modeLoopPlaylist();
        AppShared.setPlaylistMode(1);
        break;
      // mode loop song
      case 1:
        await modeLoopSong();
        AppShared.setPlaylistMode(2);
        break;
      // mode shuffle
      case 2:
        await modeShfflePlaylist();
        AppShared.setPlaylistMode(0);
        break;
    }
  }
}
