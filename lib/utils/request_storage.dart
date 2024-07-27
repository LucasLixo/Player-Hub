import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStorage() async {
  AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

  PermissionStatus request;

  switch (build.version.sdkInt) {
    case >= 33:
      request = await Permission.audio.request();
      if (request.isGranted) {
        return true;
      } else {
        return false;
      }
    case >= 30:
      request = await Permission.manageExternalStorage.request();
      if (request.isGranted) {
        return true;
      } else {
        return false;
      }
    default:
      request = await Permission.storage.request();
      if (request.isGranted) {
        return true;
      } else {
        return false;
      }
  }
}
