import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:player_hub/app/core/enums/array_image_types.dart';
import 'package:player_hub/app/core/enums/query_songs.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/interfaces/visualizer.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';

class PlayerController extends BaseAudioHandler with QueueHandler, SeekHandler {
  // ==================================================
  final RxString songLog = ''.obs;
  // address of sound in list
  final RxInt songIndex = 0.obs;
  final RxInt songSession = 0.obs;
  // state play
  final RxBool isPlaying = false.obs;
  // playback options
  final RxBool isLooping = false.obs;
  final RxBool isShuffle = false.obs;

  // ==================================================
  // position of sound
  final RxString songDuration = ''.obs;
  final RxString songPosition = ''.obs;
  final RxDouble songDurationD = 0.0.obs;
  final RxDouble songPositionD = 0.0.obs;

  // ==================================================
  // playlists
  final RxList<SongModel> songAllList = <SongModel>[].obs;
  final RxList<SongModel> songAppList = <SongModel>[].obs;
  final RxList<SongModel> songList = <SongModel>[].obs;

  final RxList<SongModel> songSearchList = <SongModel>[].obs;
  final RxList<SongModel> songSelectionList = <SongModel>[].obs;

  // ==================================================
  // folder list
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
  // if in recent list
  final RxBool isListRecent = false.obs;
  // recent list
  final RxList<SongModel> recentList = <SongModel>[].obs;
  // current song
  final Rx<SongModel?> currentSong = Rx<SongModel?>(null);
  // current image
  final Rx<Uint8List?> currentImage = Rx<Uint8List?>(null);
  // current image Path
  final Rx<String?> currentImagePath = Rx<String?>(null);

  // ==================================================
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

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
    songSession.value = audioPlayer.androidAudioSessionId ?? 0;
  }

  // ==================================================
  Future<void> _updateInterfaceVisualizer(SongModel song) async {
    final int songId = song.id;

    final String songTitle = AppShared.getTitle(songId, song.title);
    final String songArtist = AppShared.getArtist(songId, song.artist!);
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
  // update position
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
  // charge duration in seconds
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
  // update playlist
  Future<void> _initPlaylist() async {
    playlistList.clear();
    playlistList.assignAll(
        AppShared.getShared(SharedAttributes.listAllPlaylist) as List<String>);

    playlistListSongs.clear();
    for (int index = 0; index < playlistList.length; index++) {
      final String title = playlistList[index];
      playlistListSongs[title] = _getSongsFromIds(AppShared.getPlaylist(title));
    }
  }

  Future<void> _updatePlaylistList() async {
    await AppShared.setShared(
      SharedAttributes.listAllPlaylist,
      playlistList.toList(),
    );
  }

  Future<void> _updatePlaylistListSongs(String title) async {
    await AppShared.setPlaylist(
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

    // Adiciona a busca de músicas baseado no tipo de ordenação selecionado
    switch (AppShared.getShared(SharedAttributes.getSongs) as int) {
      // Por data adicionada
      case 0:
        songQuery = QuerySongs.getQuerySongs(
          _audioQuery,
          QuerySongs.dateAdded,
        );
        break;
      // Por ordem alfabética (A a Z)
      case 1:
        songQuery = QuerySongs.getQuerySongs(
          _audioQuery,
          QuerySongs.title,
        );
        break;
      // Por duração
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

    // Adiciona a busca de álbuns
    Future<List<AlbumModel>> albumQuery = _audioQuery.queryAlbums(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: AlbumSortType.ALBUM,
      uriType: UriType.EXTERNAL,
    );
    futures.add(albumQuery);

    // Adiciona a busca de artistas
    Future<List<AlbumModel>> artistQuery = _audioQuery.queryAlbums(
      ignoreCase: true,
      orderType: OrderType.DESC_OR_GREATER,
      sortType: AlbumSortType.ARTIST,
      uriType: UriType.EXTERNAL,
    );
    futures.add(artistQuery);
    futures.add(pauseSong());

    // Executa todas as operações em paralelo
    final results = await Future.wait(futures);

    // Extraindo os resultados
    songs.addAll(results[0] as List<SongModel>);
    albumList.value = results[1] as List<AlbumModel>;
    artistList.value = results[2] as List<AlbumModel>;

    songAllList.value = songs;

    await _initPlaylist();

    await songAllLoad(songs);
  }

  // ==================================================
  Future<void> songAllLoad(List<SongModel> songList) async {
    // Otimiza a criação de 'folderList', 'folderListSongs', 'albumListSongs' e 'artistListSongs' paralelamente
    Set<String> folderSet = {};
    Map<String, List<SongModel>> folderSongsMap = {};
    Map<String, List<SongModel>> albumSongsMap = {};
    Map<String, List<SongModel>> artistSongsMap = {};

    // Processa álbuns e artistas paralelamente
    await Future.wait([
      Future(() async {
        // Processa as músicas para pastas
        folderListSongs.clear();
        for (var song in songList) {
          String folderName = song.data.split('/').reversed.skip(1).first;
          folderSet.add(folderName);
          folderSongsMap.update(folderName, (s) => [...s, song],
              ifAbsent: () => [song]);
        }
        folderList.value = folderSet.toList();
        folderListSongs.addAll(folderSongsMap);
      }),
      // Processamento de cache de imagens em paralelo para reduzir o tempo de execução
      Future(() async {
        for (var song in songList) {
          if (!_imageCache.containsKey(song.id)) {
            _imageCache[song.id] = await AppManifest.getImageFile(
              id: song.id,
              type: ArrayImageTypes.high,
            );
          }
          songLog.value = AppShared.getTitle(song.id, song.title);
        }
      }),
      // Processamento de álbuns
      Future(() async {
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
      }),
      // Processamento de artistas
      Future(() async {
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
      }),
    ]);

    songLog.value = '';

    // Remove músicas com base em duração e pastas ignoradas
    int ignoreTime = AppShared.getShared(SharedAttributes.ignoreTime) as int;
    List<String> ignoreFolder =
        AppShared.getShared(SharedAttributes.ignoreFolder) as List<String>;

    songList = songList.where((song) {
      if (ignoreFolder.contains(song.data.split('/').reversed.skip(1).first) ||
          (song.duration != null && song.duration! < (ignoreTime * 1000))) {
        return false;
      } else {
        return true;
      }
    }).toList();

    // Atualiza a lista de todas as músicas no estado
    songAppList.value = songList;

    // Carrega as músicas
    await songLoad(songList, 0);
  }

  // ==================================================
  // defined songs in background
  Future<void> songLoad(
    List<SongModel> songListLoaded, [
    int index = 0,
  ]) async {
    // Atualiza a lista de músicas no estado
    songList.clear();
    songList.addAll(songListLoaded);

    // Cria a playlist de fontes de áudio em um único passo
    List<AudioSource> playlist = List.generate(songList.length, (i) {
      final SongModel song = songList[i];
      final String? imagePath = _imageCache[song.id];
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: AppShared.getTitle(song.id, song.title),
          artist: AppShared.getArtist(song.id, song.artist!),
          artUri: imagePath != null ? Uri.file(imagePath) : null,
        ),
      );
    });

    // Define a playlist no player
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: playlist,
        shuffleOrder: DefaultShuffleOrder(),
      ),
      initialIndex: index,
    );

    await handleCurrentIndex(index);

    // Modo de playlist (Loop, Shuffle, etc)
    switch (AppShared.getShared(SharedAttributes.playlistMode) as int) {
      // Modo loop playlist
      case 0:
        await modeShufflePlaylist();
        break;
      // Modo loop song
      case 1:
        await modeLoopPlaylist();
        break;
      // Modo shuffle
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
  // Controle de play e pause (para reutilização)
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
  // Definir reprodução da música atual
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
  // Pausar música atual
  Future<void> pauseSong() async {
    _setPlaybackState(
      isPlaying: false,
      controls: [MediaControl.play],
    );
    await audioPlayer.pause();
  }

  // ==================================================
  // Próxima música
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
  // Música anterior
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
  // Modo loop para a playlist
  Future<void> modeLoopPlaylist() async {
    isLooping.value = false;
    isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // ==================================================
  // Modo loop para uma música
  Future<void> modeLoopSong() async {
    isLooping.value = true;
    isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.one);
  }

  // ==================================================
  // Modo shuffle para a playlist
  Future<void> modeShufflePlaylist() async {
    isLooping.value = false;
    isShuffle.value = true;
    await audioPlayer.setShuffleModeEnabled(true);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // ==================================================
  // Alterna entre play e pause
  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await pauseSong();
    } else {
      await playSong(songIndex.value);
    }
  }

  // ==================================================
  // Alterna entre modos da playlist (loop, shuffle)
  Future<void> togglePlaylist() async {
    switch (AppShared.getShared(SharedAttributes.playlistMode) as int) {
      case 0:
        await modeLoopPlaylist();
        AppShared.setShared(SharedAttributes.playlistMode, 1);
        break;
      case 1:
        await modeLoopSong();
        AppShared.setShared(SharedAttributes.playlistMode, 2);
        break;
      case 2:
        await modeShufflePlaylist();
        AppShared.setShared(SharedAttributes.playlistMode, 0);
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
    }
  }

  Future<void> removePlaylist(String title) async {
    if (playlistList.contains(title)) {
      playlistList.remove(title);
      playlistListSongs.remove(title);
      await _updatePlaylistList();
      await _updatePlaylistListSongs(title);
    }
  }

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

  Future<void> removeSongsPlaylist(String title, List<SongModel> songs) async {
    if (playlistListSongs.containsKey(title)) {
      playlistListSongs[title]
          ?.removeWhere((song) => songs.any((s) => s.id == song.id));
      await _updatePlaylistListSongs(title);
    }
  }
}
