import 'package:permission_handler/permission_handler.dart';

Future<void> appPermissions() async {
  List<Permission> permissions = [
    Permission.audio,
    Permission.manageExternalStorage,
    Permission.storage,
  ];

  await permissions.request();
}
