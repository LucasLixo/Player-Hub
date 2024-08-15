import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../routes/app_routes.dart';
import '../../shared/utils/subtitle_style.dart';
import '../../core/controllers/player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    
    _permissionsApp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _permissionsApp() async {
    PermissionStatus audioPermissionStatus = await Permission.audio.request();

    if (audioPermissionStatus.isGranted) {
      _initializeApp();
    } else if (audioPermissionStatus.isDenied) {
      await _showDialogError();
    } else if (audioPermissionStatus.isPermanentlyDenied) {
      await playerStateController.loadSliderValue();
      openAppSettings();
    }
  }

  Future<String?> _showDialogError() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Para continuar, precisamos de acesso aos seus arquivos de áudio.',
                style: subtitleStyle(),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'Tente Novamente',
                  style: dynamicStyle(
                    16,
                    AppColors.primary,
                    FontWeight.w600,
                    FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));

    Get.offNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: Center(
        child: Text(
          constAppTitle,
          style: dynamicStyle(
            32,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
