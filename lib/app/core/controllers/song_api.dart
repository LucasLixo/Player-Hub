import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiStateController extends GetxController {
  RxBool isConect = false.obs;

  @override
  void onInit() {
    super.onInit();
    var connectivityResult = (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConect.value = true;
    } else {
      isConect.value = false;
    }
  }
}

class ApiController extends GetConnect {
  SongApiController() {
    timeout = const Duration(seconds: 30);
    httpClient.baseUrl = 'https://docs.genius.com/search?q=';
    httpClient.addRequestModifier(requestModifier);
    httpClient.addResponseModifier(responseModifier);
  }

  FutureOr<Request> requestModifier(Request request) async {
    String? token = 'VSUm_yV_uXlIl19p8azsxNjg5IM7TaMsJJYqAaaNzSBetoPGiQ2J-tK1-YfqKwyE';

    request.headers.addAll({
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      'content-type': 'application/json',
    });

    return request;
  }

  FutureOr<dynamic> responseModifier(Request request, Response response) async {
    showLogs(request, response);

    if (response.unauthorized) {}

    return response;
  }

  Future<Response> searchSong(String query) async {
    final response = await get(query);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  void showLogs(Request request, Response response) {
    if (true) {
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
}
