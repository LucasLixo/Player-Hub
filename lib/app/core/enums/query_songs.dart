import 'package:on_audio_query/on_audio_query.dart';

enum QuerySongs {
  // ==================================================
  dateAdded,
  title,
  duration;

  // ==================================================
  static Future<List<SongModel>> getQuerySongs(
    OnAudioQuery audioQuery,
    QuerySongs querySongs,
  ) async {
    switch (querySongs) {
      case QuerySongs.dateAdded:
        return audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
        );
      case QuerySongs.title:
        return audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.TITLE,
          uriType: UriType.EXTERNAL,
        );
      case QuerySongs.duration:
        return audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.DESC_OR_GREATER,
          sortType: SongSortType.DURATION,
          uriType: UriType.EXTERNAL,
        );
      default:
        throw ArgumentError('Index must be between QuerySongs');
    }
  }
}
