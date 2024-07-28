import 'package:permission_handler/permission_handler.dart';

Future<bool> requestNotifications() async {
  PermissionStatus request;

  request = await Permission.notification.request();

  if (request.isGranted) {
    return true;
  } else {
    return true;
  }
}
