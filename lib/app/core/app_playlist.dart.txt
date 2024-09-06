import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Playlist {
  final String title;
  final List<SongModel> songs;

  Playlist({required this.title, required this.songs});

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      title: map['title'] as String,
      songs: [],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}

mixin AppPlaylist on GetxController {
  static RxList<Playlist> playlistLocal = <Playlist>[].obs;

  static void addPlaylist(Playlist playlist) {
    playlistLocal.add(playlist);
  }

  static void removePlaylist(String title) {
    playlistLocal.removeWhere((playlist) => playlist.title == title);
  }

  static void addSongsToPlaylist(String title, List<SongModel> newSongs) {
    final playlistIndex =
        playlistLocal.indexWhere((playlist) => playlist.title == title);
    if (playlistIndex != -1) {
      final updatedPlaylist = playlistLocal[playlistIndex];
      updatedPlaylist.songs.addAll(newSongs);
      playlistLocal[playlistIndex] = Playlist(
        title: updatedPlaylist.title,
        songs: updatedPlaylist.songs,
      );
    }
  }
}
