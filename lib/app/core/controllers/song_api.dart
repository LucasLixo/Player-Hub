import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SongApiStateController extends GetxController {
  RxBool isConect = false.obs;

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    for (var result in connectivityResult) {
      if (result == ConnectivityResult.wifi) {
        isConect.value = true;
        break;
      }
    }
  }
}

class SongApiController extends GetConnect {
  SongApiController() {
    timeout = const Duration(seconds: 30);
    httpClient.baseUrl = 'https://api.genius.com/search?q=';
    httpClient.addRequestModifier(requestModifier);
    httpClient.addResponseModifier(responseModifier);
  }

  FutureOr<Request> requestModifier(Request request) async {
    request.headers.addAll({
      // 'User-Agent': 'CompuServe Classic/1.22',
      'Accept': 'application/json',
      'Host': 'api.genius.com',
      'Authorization': 'Bearer VSUm_yV_uXlIl19p8azsxNjg5IM7TaMsJJYqAaaNzSBetoPGiQ2J-tK1-YfqKwyE',
    });

    return request;
  }

  FutureOr<dynamic> responseModifier(Request request, Response response) async {
    showLogs(request, response);

    return response;
  }

  Future<List<ModelSongApi>> searchSong(String query) async {
    final response = await get(Uri.encodeComponent(query));

    if (response.statusCode == 200) {
      final List<ModelSongApi> songs = [];

      final hits = response.body['response']['hits'];

      for (var hit in hits) {
        final songData = hit['result'];
        songs.add(ModelSongApi.fromJson(songData));
      }

      return songs;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  void showLogs(Request request, Response response) {
    print('\n\n');
    print('========================== REQUEST ==========================');
    print('(${request.method}) => ${request.url}');
    print('HEADERS: ${request.headers}');
    print('');
    print('========================== RESPONSE ==========================');
    print('STATUS CODE: ${response.statusCode}');
    print('STATUS TEXT: ${response.statusText}');
    print('BODY: ${response.body}');
    print('\n\n');
  }
}

class ModelSongApi {
  final String title;
  final String artist;
  final String art;

  ModelSongApi({
    required this.title,
    required this.artist,
    required this.art,
  });

  factory ModelSongApi.fromJson(Map<String, dynamic> json) {
    return ModelSongApi(
      title: json['title'] ?? '',
      artist: json['artist_names'] ?? '',
      art: json['song_art_image_url'] ?? '',
    );
  }
}
