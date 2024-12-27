import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/ignores_load.dart';
import 'package:player_hub/app/core/enums/image_quality.dart';
import 'package:player_hub/app/core/enums/query_songs.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/updated_load.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/interfaces/visualizer.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/core/types/app_functions.dart';

class PlayerController extends BaseAudioHandler
    with QueueHandler, SeekHandler, AppFunctions {
  // ==================================================
  final AppShared sharedController = Get.find<AppShared>();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  // ==================================================
  final RxString songLog = ''.obs;
  // Address of sound in list
  final RxInt songIndex = 0.obs;

  // State play
  final RxBool isPlaying = false.obs;
  // Playback options
  final RxBool isLooping = false.obs;
  final RxBool isShuffle = false.obs;

  // ==================================================
  // Position of sound
  final RxString songDuration = ''.obs;
  final RxString songPosition = ''.obs;
  final RxDouble songDurationD = 0.0.obs;
  final RxDouble songPositionD = 0.0.obs;

  // ==================================================
  // Playlists
  final RxList<SongModel> songAllList = <SongModel>[].obs;
  final RxList<SongModel> songAppList = <SongModel>[].obs;
  final RxList<SongModel> songList = <SongModel>[].obs;

  final RxList<SongModel> songSearchList = <SongModel>[].obs;
  final RxList<SongModel> songSelectionList = <SongModel>[].obs;

  // ==================================================
  // Folder list
  final RxList<String> playlistList = <String>[].obs;
  final RxList<String> folderList = <String>[].obs;
  final RxList<AlbumModel> albumList = <AlbumModel>[].obs;
  final RxList<AlbumModel> artistList = <AlbumModel>[].obs;

  // ==================================================
  final RxMap<String, List<SongModel>> playlistListSongs =
      <String, List<SongModel>>{}.obs;
  final RxMap<String, List<SongModel>> folderListSongs =
      <String, List<SongModel>>{}.obs;
  final RxMap<String, List<SongModel>> albumListSongs =
      <String, List<SongModel>>{}.obs;
  final RxMap<String, List<SongModel>> artistListSongs =
      <String, List<SongModel>>{}.obs;

  // ==================================================
  final RxMap<int, String> _imageCache = <int, String>{}.obs;

  // ==================================================
  // If in recent list
  final RxBool isListRecent = false.obs;
  // Recent list
  final RxList<SongModel> recentList = <SongModel>[].obs;
  // Current song
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  // Current image
  final Rx<Uint8List?> currentImage = Rx<Uint8List?>(null);
  // Current image Path
  final Rx<String?> currentImagePath = Rx<String?>(null);

  // ==================================================
  PlayerController() {
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) nextSong();
    });
    audioPlayer.playerStateStream.listen(_handlePlayerState);
    audioPlayer.currentIndexStream.listen(handleCurrentIndex);
    _updatePosition();
  }

  // ==================================================
  void _handlePlayerState(PlayerState state) {
    isPlaying.value = state.playing;
  }

  // ==================================================
  Future<bool> requestPermissions() async {
    return await _audioQuery.checkAndRequest(
      retryRequest: false,
    );
  }

  // ==================================================
  Future<void> _updateInterfaceVisualizer(SongModel song) async {
    final int songId = song.id;

    final String songTitle = sharedController.getTitle(songId, song.title);
    final String songArtist = sharedController.getArtist(songId, song.artist!);
    final String? image = _imageCache[songId];

    InterfaceVisualizer visualizerMusic = InterfaceVisualizer(
      headlineTitle: songTitle,
      headlineSubtitle: songArtist,
      headlineImage: image,
    );
    await visualizerMusic.updateHeadline();

    currentImagePath.value = image;
    if (image != null) {
      currentImage.value = await File(image).readAsBytes();
    }
  }

  // ==================================================
  void _updateRecentList(SongModel song) {
    if (isListRecent.value) return;

    recentList.removeWhere((s) => s.id == song.id);
    recentList.insert(0, song);
  }

  // ==================================================
  // Update position
  void _updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        songDuration.value = d.toString().split(".")[0];
        songDurationD.value = d.inSeconds.toDouble();
      }
    });
    audioPlayer.positionStream.listen((p) {
      songPosition.value = p.toString().split(".")[0];
      songPositionD.value = p.inSeconds.toDouble();
    });
  }

  // ==================================================
  // Charge duration in seconds
  Future<void> chargeDurationInSeconds(int seconds) async {
    await audioPlayer.seek(Duration(seconds: seconds));
  }

  Future<void> handleCurrentIndex(int? index) async {
    if (songList.isEmpty) {
      currentSong.value = null;
      return;
    }
    if (index == null) {
      currentSong.value = songList[songIndex.value];
      return;
    }

    songIndex.value = index;
    currentSong.value = songList[index];

    if (currentSong.value != null) {
      await _updateInterfaceVisualizer(currentSong.value!);
      _updateRecentList(currentSong.value!);
    }
  }

  // ==================================================
  // Update playlist
  Future<void> _initPlaylist() async {
    playlistList.clear();
    playlistList.assignAll(sharedController
        .getShared<List<String>>(SharedAttributes.listAllPlaylist));

    playlistListSongs.clear();
    for (int index = 0; index < playlistList.length; index++) {
      final String title = playlistList[index];
      playlistListSongs[title] =
          _getSongsFromIds(sharedController.getPlaylist(title));
    }
  }

  Future<void> _updatePlaylistList() async {
    await sharedController.setShared(
      SharedAttributes.listAllPlaylist,
      playlistList.toList(),
    );
  }

  Future<void> _updatePlaylistListSongs(String title) async {
    await sharedController.setPlaylist(
        title, _getIdsFromSongs(playlistListSongs[title] ?? <SongModel>[]));
  }

  // ==================================================
  // Utils
  List<int> _getIdsFromSongs(List<SongModel> songs) {
    return songs.map((song) => song.id).toList();
  }

  List<SongModel> _getSongsFromIds(List<int> ids) {
    return songAllList.where((song) => ids.contains(song.id)).toList();
  }

  // ==================================================
  // Get Songs
  Future<void> getAllSongs() async {
    songIndex.value = 0;

    final List<SongModel> songs = [];
    final List<Future> futures = [];
    late Future<List<SongModel>> songQuery;

    // Adds music search based on the selected sorting type
    switch (sharedController.getShared<int>(SharedAttributes.getSongs)) {
      // By date added
      case 0:
        songQuery = QuerySongs.getQuerySongs(
          _audioQuery,
          QuerySongs.dateAdded,
        );
        break;
        // By alphabetical order (A to Z)
      case 1:
        songQuery = QuerySongs.getQuerySongs(
          _audioQuery,
          QuerySongs.title,
        );
        break;
        // By duration
      case 2:
        songQuery = QuerySongs.getQuerySongs(
          _audioQuery,
          QuerySongs.duration,
        );
        break;
      default:
        songQuery = Future.value([]);
    }
    futures.add(songQuery);

    // Add album search
    Future<List<AlbumModel>> albumQuery = _audioQuery.queryAlbums(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: AlbumSortType.ALBUM,
      uriType: UriType.EXTERNAL,
    );
    futures.add(albumQuery);

    // Add artist search
    Future<List<AlbumModel>> artistQuery = _audioQuery.queryAlbums(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: AlbumSortType.ARTIST,
      uriType: UriType.EXTERNAL,
    );
    futures.add(artistQuery);
    futures.add(pauseSong());

    // Perform all operations in parallel
    final List<dynamic> results = await Future.wait(futures);

    // Extract results
    songs.addAll(results[0] as List<SongModel>);
    albumList.value = results[1] as List<AlbumModel>;
    artistList.value = results[2] as List<AlbumModel>;

    songAllList.value = songs;

    await _initPlaylist();

    await songAllLoad(
      songs,
      typeLoad: UpdatedTypeLoad.values,
      typeInore: IgnoresLoad.values,
    );
  }

  // ==================================================
  Future<void> songAllLoad(
    List<SongModel> songList, {
    required List<UpdatedTypeLoad> typeLoad,
    required List<IgnoresLoad> typeInore,
  }) async {
    // Optimize created 'folderList', 'folderListSongs', 'albumListSongs' e 'artistListSongs' paralelamente
    final Set<String> folderSet = {};
    final Map<String, List<SongModel>> folderSongsMap = {};
    final Map<String, List<SongModel>> albumSongsMap = {};
    final Map<String, List<SongModel>> artistSongsMap = {};

    // Futures
    final List<Future> futures = [];

    for (var type in typeLoad) {
      switch (type) {
        case UpdatedTypeLoad.folder:
          futures.add(Future(() async {
            folderListSongs.clear();
            for (var song in songList) {
              String folderName = song.data.split('/').reversed.skip(1).first;
              folderSet.add(folderName);
              folderSongsMap.update(folderName, (s) => [...s, song],
                  ifAbsent: () => [song]);
            }
            folderList.value = folderSet.toList();
            folderListSongs.addAll(folderSongsMap);
          }));
          break;
        case UpdatedTypeLoad.image:
          futures.add(Future(() async {
            for (var song in songList) {
              if (!_imageCache.containsKey(song.id)) {
                _imageCache[song.id] = await AppManifest.getImageFile(
                  id: song.id,
                  type: ImageQuality.high,
                );
              }
              songLog.value = song.displayName;
            }
            songLog.value = '';
          }));
          break;
        case UpdatedTypeLoad.album:
          futures.add(Future(() async {
            albumListSongs.clear();
            for (var album in albumList) {
              int albumId = album.id;
              List<SongModel> albumSongs = await queryAudiosFromAlbum(
                albumId: albumId,
                type: 0,
              );
              albumSongsMap.update(
                  album.album, (songs) => [...songs, ...albumSongs],
                  ifAbsent: () => albumSongs);
            }
            albumListSongs.addAll(albumSongsMap);
          }));
          break;
        case UpdatedTypeLoad.artist:
          futures.add(Future(() async {
            artistListSongs.clear();
            for (var artist in artistList) {
              int artistId = artist.id;
              List<SongModel> artistSongs = await queryAudiosFromAlbum(
                albumId: artistId,
                type: 1,
              );
              artistSongsMap.update(
                  artist.album, (songs) => [...songs, ...artistSongs],
                  ifAbsent: () => artistSongs);
            }
            artistListSongs.addAll(artistSongsMap);
          }));
          break;
      }
    }

    // Processes albums and artists in parallel
    await Future.wait(futures);

    // Removes songs based on duration and ignored folders
    for (var type in typeInore) {
      switch (type) {
        case IgnoresLoad.duration:
          final int ignoreTime =
              sharedController.getShared<int>(SharedAttributes.ignoreTime);
          songList = songList.where((song) {
            if (song.duration != null && song.duration! < (ignoreTime * 1000)) {
              return false;
            }
            return true;
          }).toList();
          break;
        case IgnoresLoad.folders:
          final List<String> ignoreFolder = sharedController
              .getShared<List<String>>(SharedAttributes.ignoreFolder);
          songList = songList.where((song) {
            if (ignoreFolder
                .contains(song.data.split('/').reversed.skip(1).first)) {
              return false;
            }
            return true;
          }).toList();
          break;
      }
    }

    // Updates the list of all songs in the state
    songAppList.value = songList;

    // Load musics
    await songLoad(songList, 0);
  }

  // ==================================================
  // defined songs in background
  Future<void> songLoad(
    List<SongModel> songListLoaded, [
    int index = 0,
  ]) async {
    // Updates the playlist in the current state
    songList.clear();
    songList.addAll(songListLoaded);

    // Creates the playlist from audio sources in one step
    List<AudioSource> playlist = List.generate(songList.length, (i) {
      final SongModel song = songList[i];
      final String? imagePath = _imageCache[song.id];
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: sharedController.getTitle(song.id, song.title),
          artist: sharedController.getArtist(song.id, song.artist!),
          artUri: imagePath != null ? Uri.file(imagePath) : null,
        ),
      );
    });

    // Sets the playlist in the player
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: playlist,
        shuffleOrder: DefaultShuffleOrder(),
      ),
      initialIndex: index,
    );

    await handleCurrentIndex(index);

    // Playlist mode (Loop, Shuffle, etc)
    switch (sharedController.getShared<int>(SharedAttributes.playlistMode)) {
      // Mode loop playlist
      case 0:
        await modeShufflePlaylist();
        break;
      // Mode loop song
      case 1:
        await modeLoopPlaylist();
        break;
      // Mode shuffle
      case 2:
        await modeLoopSong();
        break;
    }
  }

  // ==================================================
  Future<List<SongModel>> queryAudiosFromAlbum({
    required int albumId,
    required int type,
  }) async {
    switch (type) {
      case 0:
        return await _audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          albumId,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.ALBUM,
        );
      case 1:
        return await _audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          albumId,
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.ARTIST,
        );
      default:
        return <SongModel>[];
    }
  }

  // ==================================================
  // Play and pause control (for reuse)
  void _setPlaybackState({
    required bool isPlaying,
    required List<MediaControl> controls,
  }) {
    playbackState.add(playbackState.value.copyWith(
      playing: isPlaying,
      controls: controls,
    ));
    isPlaying = isPlaying;
  }

  // ==================================================
  // Set playback of current song
  Future<void> playSong(int? index) async {
    if (songIndex.value != index) {
      songIndex.value = index!;
      await audioPlayer.seek(Duration.zero, index: index);
    }
    _setPlaybackState(
      isPlaying: true,
      controls: [MediaControl.pause],
    );
    await audioPlayer.play();
    _updatePosition();
  }

  // ==================================================
  // Pause current song
  Future<void> pauseSong() async {
    _setPlaybackState(
      isPlaying: false,
      controls: [MediaControl.play],
    );
    await audioPlayer.pause();
  }

  // ==================================================
  // Next song
  Future<void> nextSong() async {
    if (songList.isNotEmpty) {
      int currentIndex = songIndex.value;
      int lastIndex = songList.length - 1;

      if (currentIndex < lastIndex) {
        if (isLooping.value) {
          await audioPlayer.seek(Duration.zero, index: currentIndex + 1);
        } else {
          await audioPlayer.seekToNext();
        }
      } else {
        await audioPlayer.seek(Duration.zero, index: 0);
      }
      await audioPlayer.play();
    }
  }

  // ==================================================
  // Previous song
  Future<void> previousSong() async {
    if (songList.isNotEmpty) {
      int currentIndex = songIndex.value;
      int lastIndex = songList.length - 1;

      if (currentIndex > 0) {
        if (isLooping.value) {
          await audioPlayer.seek(Duration.zero, index: currentIndex - 1);
        } else {
          await audioPlayer.seekToPrevious();
        }
      } else {
        await audioPlayer.seek(Duration.zero, index: lastIndex);
      }
      await audioPlayer.play();
    }
  }

  // ==================================================
  // Loop mode for the playlist
  Future<void> modeLoopPlaylist() async {
    isLooping.value = false;
    isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // ==================================================
  // Loop mode for a song
  Future<void> modeLoopSong() async {
    isLooping.value = true;
    isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.one);
  }

  // ==================================================
  // Shuffle mode for the playlist
  Future<void> modeShufflePlaylist() async {
    isLooping.value = false;
    isShuffle.value = true;
    await audioPlayer.setShuffleModeEnabled(true);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // ==================================================
  // Toggles between play and pause
  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await pauseSong();
    } else {
      await playSong(songIndex.value);
    }
  }

  // ==================================================
  // Switch between playlist modes (loop, shuffle)
  Future<void> togglePlaylist() async {
    switch (sharedController.getShared<int>(SharedAttributes.playlistMode)) {
      case 0:
        await modeLoopPlaylist();
        sharedController.setShared(SharedAttributes.playlistMode, 1);
        break;
      case 1:
        await modeLoopSong();
        sharedController.setShared(SharedAttributes.playlistMode, 2);
        break;
      case 2:
        await modeShufflePlaylist();
        sharedController.setShared(SharedAttributes.playlistMode, 0);
        break;
    }
  }

  // ==================================================
  Future<void> addPlaylist(String title) async {
    if (!playlistList.contains(title)) {
      playlistList.add(title);
      playlistListSongs.putIfAbsent(title, () => <SongModel>[]);
      await _updatePlaylistList();
      await _updatePlaylistListSongs(title);
    } else {
      await showToast('playlist2'.tr);
    }
  }

  // ==================================================
  Future<void> removePlaylist(String title) async {
    if (playlistList.contains(title)) {
      playlistList.remove(title);
      playlistListSongs.remove(title);
      await _updatePlaylistList();
      await _updatePlaylistListSongs(title);
    }
  }

  // ==================================================
  Future<void> renamePlaylist(String oldTitle, String newTitle) async {
    if (playlistList.contains(oldTitle)) {
      playlistList.remove(oldTitle);
      playlistList.add(newTitle);

      playlistListSongs[newTitle] =
          playlistListSongs[oldTitle] ?? <SongModel>[];
      playlistListSongs.remove(oldTitle);

      await sharedController.deletePlaylist(oldTitle);
      await _updatePlaylistList();
      await _updatePlaylistListSongs(newTitle);
    }
  }

  // ==================================================
  Future<void> addSongsPlaylist(String title, List<SongModel> songs) async {
    if (!playlistList.contains(title)) {
      await addPlaylist(title);
    }

    final existingSongs = playlistListSongs[title];
    if (existingSongs != null) {
      for (var song in songs) {
        if (!existingSongs.any((s) => s.id == song.id)) {
          existingSongs.add(song);
        }
      }
      await _updatePlaylistListSongs(title);
    }
  }

  // ==================================================
  Future<void> removeSongsPlaylist(String title, List<SongModel> songs) async {
    if (playlistListSongs.containsKey(title)) {
      playlistListSongs[title]
          ?.removeWhere((song) => songs.any((s) => s.id == song.id));
      await _updatePlaylistListSongs(title);
    }
  }
}
