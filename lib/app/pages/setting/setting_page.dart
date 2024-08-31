import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/slider_shape.dart';
import 'package:playerhub/app/shared/utils/switch_theme.dart';
import 'package:playerhub/app/core/app_shared.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  int _sliderValue = AppShared.ignoreTimeValue.value;

  @override
  void dispose() {
    if (_sliderValue != AppShared.ignoreTimeValue.value) {
      AppShared.setIgnoreTime(_sliderValue);
      playerController.getAllSongs();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          'setting_title'.tr,
          style: dynamicStyle(
            20,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'setting_ignore'.trParams({
                'seconds': _sliderValue.toString(),
              }),
              style: dynamicStyle(
                16,
                AppColors.text,
                FontWeight.normal,
                FontStyle.normal,
              ),
            ),
            leading: Icon(
              Icons.music_note,
              color: AppColors.text,
              size: 32,
            ),
            subtitle: SliderTheme(
              data: getSliderTheme(),
              child: Slider(
                thumbColor: AppColors.primary,
                inactiveColor: AppColors.onBackground,
                activeColor: AppColors.primary,
                min: 0,
                max: 120,
                value: _sliderValue.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value.toInt();
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text(
              'setting_mode'.tr,
              style: dynamicStyle(
                16,
                AppColors.text,
                FontWeight.normal,
                FontStyle.normal,
              ),
            ),
            leading: Icon(
              Icons.dark_mode,
              color: AppColors.text,
              size: 32,
            ),
            trailing: SwitchTheme(
              data: getSwitchTheme(),
              child: Switch(
                value: AppShared.darkModeValue.value,
                onChanged: (bool value) async {
                  await AppShared.setDarkMode(value);
                  if (mounted) {
                    Phoenix.rebirth(context);
                  } // Get.offNamed(AppRoutes.splash);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
