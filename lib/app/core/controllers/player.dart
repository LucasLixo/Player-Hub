import 'package:audio_service/audio_service.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/visualizer_music.dart';

class PlayerStateController extends GetxController {
  // log
  RxString songLog = ''.obs;

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
  RxList<AlbumModel> albumList = <AlbumModel>[].obs;
  RxList<AlbumModel> artistList = <AlbumModel>[].obs;

  //
  RxMap<String, List<SongModel>> folderListSongs =
      <String, List<SongModel>>{}.obs;
  RxMap<String, List<SongModel>> albumListSongs =
      <String, List<SongModel>>{}.obs;
  RxMap<String, List<SongModel>> artistListSongs =
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
  final audioPlayer = AudioPlayer();
  final _playerState = Get.find<PlayerStateController>();

  PlayerController() {
    // Ouve o estado de processamento do áudio para avançar para a próxima música
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) nextSong();
    });

    // Ouve o estado do player para atualizar a variável de reprodução e sessão de áudio
    audioPlayer.playerStateStream.listen(_handlePlayerState);

    // Ouve o índice atual do player para definir a música atual e atualizar a imagem/cabeçalho
    audioPlayer.currentIndexStream.listen(handleCurrentIndex);

    // Atualiza a posição de reprodução da música
    updatePosition();
  }

  void _handlePlayerState(PlayerState state) {
    _playerState.isPlaying.value = state.playing;
    _playerState.songSession.value = audioPlayer.androidAudioSessionId ?? 0;
  }

  void _updateVisualizerMusic(SongModel song) {
    final songId = song.id;
    final songTitle = AppShared.getTitle(songId, song.title);
    final songArtist = AppShared.getArtist(songId, song.artist!);
    String? image = _playerState.imageCache[songId];

    updateHeadline(
      VisualizerMusic(
        headlineTitle: songTitle,
        headlineSubtitle: songArtist,
        headlineImage: image,
      ),
    );

    _playerState.currentImage.value = image;
  }

  void _updateRecentList(SongModel song) {
    if (_playerState.isListRecent.value) return;

    final recentList = _playerState.recentList;
    recentList.removeWhere((s) => s.id == song.id);
    recentList.insert(0, song);
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

  void handleCurrentIndex(int? index) {
    if (_playerState.songList.isEmpty) {
      _playerState.currentSong.value = null;
      return;
    }
    if (index == null) {
      _playerState.currentSong.value =
          _playerState.songList[_playerState.songIndex.value];
      return;
    }

    _playerState.songIndex.value = index;
    final currentSong = _playerState.songList[index];
    _playerState.currentSong.value = currentSong;

    _updateVisualizerMusic(currentSong);
    _updateRecentList(currentSong);
  }

  // Get Songs
  Future<void> getAllSongs() async {
    _playerState.songIndex.value = 0;
    List<SongModel> songs = [];

    // Paralelizando as consultas que não dependem entre si
    List<Future> futures = [];

    // Adiciona a busca de músicas baseado no tipo de ordenação selecionado
    Future<List<SongModel>> songQuery;
    switch (AppShared.defaultGetSongsValue.value) {
      // Por data adicionada
      case 0:
        songQuery = _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
        );
        break;
      // Por ordem alfabética (A a Z)
      case 1:
        songQuery = _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.TITLE,
          uriType: UriType.EXTERNAL,
        );
        break;
      // Por duração
      case 2:
        songQuery = _audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DURATION,
          uriType: UriType.EXTERNAL,
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
    songs = results[0] as List<SongModel>;
    _playerState.albumList.value = results[1] as List<AlbumModel>;
    _playerState.artistList.value = results[2] as List<AlbumModel>;

    // Remove músicas por duração
    songs = songs
        .where((song) =>
            song.duration != null &&
            song.duration! > AppShared.ignoreTimeValue.value * 1000)
        .toList();

    await songAllLoad(songs); // Carrega todas as músicas filtradas
  }

  Future<void> songAllLoad(List<SongModel> songList) async {
    // Atualiza a lista de todas as músicas no estado
    _playerState.songAllList.value = songList;

    // Otimiza a criação de 'folderList', 'folderListSongs', 'albumListSongs' e 'artistListSongs' paralelamente
    Set<String> folderSet = {};
    Map<String, List<SongModel>> folderSongsMap = {};
    Map<String, List<SongModel>> albumSongsMap = {};
    Map<String, List<SongModel>> artistSongsMap = {};

    // Processa álbuns e artistas paralelamente
    await Future.wait([
      // Processamento de cache de imagens em paralelo para reduzir o tempo de execução
      Future(() async {
        for (var song in songList) {
          if (!_playerState.imageCache.containsKey(song.id)) {
            final imagePath = await AppShared.getImageFile(id: song.id);
            _playerState.imageCache[song.id] = imagePath;
          }
          _playerState.songLog.value = AppShared.getTitle(song.id, song.title);
        }
      }),
      // Processa as músicas para pastas
      Future(() async {
        _playerState.folderListSongs.clear();
        for (var song in songList) {
          String folderName = song.data.split('/').reversed.skip(1).first;
          folderSet.add(folderName);
          folderSongsMap.update(folderName, (songs) => [...songs, song],
              ifAbsent: () => [song]);
        }
        _playerState.folderList.value = folderSet.toList();
        _playerState.folderListSongs.addAll(folderSongsMap);
      }),
      // Processamento de álbuns
      Future(() async {
        _playerState.albumListSongs.clear();
        for (var album in _playerState.albumList) {
          int albumId = album.id;
          List<SongModel> albumSongs =
              await queryAudiosFromAlbum(albumId: albumId);
          albumSongsMap.update(
              album.album, (songs) => [...songs, ...albumSongs],
              ifAbsent: () => albumSongs);
        }
        _playerState.albumListSongs.addAll(albumSongsMap);
      }),
      // Processamento de artistas
      Future(() async {
        _playerState.artistListSongs.clear();
        for (var artist in _playerState.artistList) {
          int artistId = artist.id;
          List<SongModel> artistSongs = await queryAudiosFromAlbum(
              albumId: artistId); // Corrija se necessário
          artistSongsMap.update(
              artist.album, (songs) => [...songs, ...artistSongs],
              ifAbsent: () => artistSongs);
        }
        _playerState.artistListSongs.addAll(artistSongsMap);
      }),
    ]);

    // Carrega as músicas
    await songLoad(songList, 0);
  }

  // defined songs in background
  Future<void> songLoad(List<SongModel> songList, int index) async {
    // Atualiza a lista de músicas no estado
    _playerState.songList.value = songList;

    // Cria a playlist de fontes de áudio em um único passo
    List<AudioSource> playlist = List.generate(songList.length, (i) {
      final song = songList[i];
      final imagePath = _playerState.imageCache[song.id];
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

    handleCurrentIndex(index);

    // Modo de playlist (Loop, Shuffle, etc)
    switch (AppShared.playlistModeValue.value) {
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

  Future<List<SongModel>> queryAudiosFromAlbum({
    required int albumId,
  }) async {
    return await _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      albumId,
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.TITLE,
    );
  }

  // Controle de play e pause (para reutilização)
  Future<void> _setPlaybackState({
    required bool isPlaying,
    required List<MediaControl> controls,
  }) async {
    playbackState.add(playbackState.value.copyWith(
      playing: isPlaying,
      controls: controls,
    ));
    _playerState.isPlaying.value = isPlaying;
  }

  // Definir reprodução da música atual
  Future<void> playSong(int? index) async {
    if (_playerState.songIndex.value != index) {
      _playerState.songIndex.value = index!;
      await audioPlayer.seek(Duration.zero, index: index);
    }
    await _setPlaybackState(
      isPlaying: true,
      controls: [MediaControl.pause],
    );
    await audioPlayer.play();
    updatePosition();
  }

  // Pausar música atual
  Future<void> pauseSong() async {
    await _setPlaybackState(
      isPlaying: false,
      controls: [MediaControl.play],
    );
    await audioPlayer.pause();
  }

  // Próxima música
  Future<void> nextSong() async {
    if (_playerState.songList.isNotEmpty) {
      int currentIndex = _playerState.songIndex.value;
      int lastIndex = _playerState.songList.length - 1;

      if (currentIndex < lastIndex) {
        await audioPlayer.seekToNext();
      } else {
        await audioPlayer.seek(Duration.zero, index: 0);
      }
      await audioPlayer.play();
    }
  }

  // Música anterior
  Future<void> previousSong() async {
    if (_playerState.songList.isNotEmpty) {
      int currentIndex = _playerState.songIndex.value;

      if (currentIndex > 0) {
        await audioPlayer.seekToPrevious();
      } else {
        await audioPlayer.seek(Duration.zero,
            index: _playerState.songList.length - 1);
      }
      await audioPlayer.play();
    }
  }

  // Modo loop para a playlist
  Future<void> modeLoopPlaylist() async {
    _playerState.isLooping.value = false;
    _playerState.isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // Modo loop para uma música
  Future<void> modeLoopSong() async {
    _playerState.isLooping.value = true;
    _playerState.isShuffle.value = false;
    await audioPlayer.setShuffleModeEnabled(false);
    await audioPlayer.setLoopMode(LoopMode.one);
  }

  // Modo shuffle para a playlist
  Future<void> modeShufflePlaylist() async {
    _playerState.isLooping.value = false;
    _playerState.isShuffle.value = true;
    await audioPlayer.setShuffleModeEnabled(true);
    await audioPlayer.setLoopMode(LoopMode.off);
  }

  // Alterna entre play e pause
  Future<void> togglePlayPause() async {
    if (_playerState.isPlaying.value) {
      await pauseSong();
    } else {
      await playSong(_playerState.songIndex.value);
    }
  }

  // Alterna entre modos da playlist (loop, shuffle)
  Future<void> togglePlaylist() async {
    switch (AppShared.playlistModeValue.value) {
      case 0:
        await modeLoopPlaylist();
        AppShared.setPlaylistMode(1);
        break;
      case 1:
        await modeLoopSong();
        AppShared.setPlaylistMode(2);
        break;
      case 2:
        await modeShufflePlaylist();
        AppShared.setPlaylistMode(0);
        break;
    }
  }
}
