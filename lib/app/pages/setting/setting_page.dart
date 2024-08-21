import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../core/controllers/player.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../shared/utils/slider_shape.dart';
import '../../shared/utils/switch_shape.dart';
import '../../core/app_shared.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  int _sliderValue = AppShared.ignoreTimeValue.value;

  // bool _equalizerValue = false;

  @override
  void initState() {
    super.initState();
    // _loadEqualizeValue();
  }

  @override
  void dispose() {
    if (_sliderValue != AppShared.ignoreTimeValue.value) {
      AppShared.setIgnoreTime(_sliderValue);
      playerController.getAllSongs();
    }
    super.dispose();
  }

  // void _loadEqualizeValue() async {
  //   await playerStateController.loadEqualizeValue();
  //   setState(() {
  //     _equalizerValue = playerStateController.equalizer.value;
  //   });
  // }

  // void _saveEqualizeValue(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('equalizer', value);
  // }

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
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
                data: const SliderThemeData(
                  trackShape: CustomSliderTrackShape(),
                ),
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
                data: const CustomSwitchShape().getSwitchTheme(),
                child: Switch(
                  value: AppShared.darkModeValue.value,
                  onChanged: (bool value) async {
                    await AppShared.setDarkMode(value);

                    Get.offNamed(AppRoutes.splash);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
