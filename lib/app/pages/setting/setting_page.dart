import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/controllers/player.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../shared/utils/slider_shape.dart';
import '../../shared/utils/switch_shape.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  int _sliderValue = 50;
  int _initialSliderValue = 50;

  // bool _equalizerValue = false;

  @override
  void initState() {
    super.initState();
    _loadSliderValue();
    // _loadEqualizeValue();
  }

  @override
  void dispose() {
    if (_sliderValue != _initialSliderValue) {
      playerController.getAllSongs();
    }
    super.dispose();
  }

  void _loadSliderValue() async {
    await playerStateController.loadSliderValue();
    setState(() {
      _sliderValue = playerStateController.songIgnoreTime.value;
      _initialSliderValue = _sliderValue;
    });
  }

  // void _loadEqualizeValue() async {
  //   await playerStateController.loadEqualizeValue();
  //   setState(() {
  //     _equalizerValue = playerStateController.equalizer.value;
  //   });
  // }

  void _saveSliderValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('songIgnoreTime', value);
  }

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
            Text(
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
            SliderTheme(
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
                  _saveSliderValue(_sliderValue);
                },
              ),
            ),
            SwitchTheme(
              data: const CustomSwitchShape().getSwitchTheme(),
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: Text(
                  'setting_mode'.tr,
                  style: dynamicStyle(
                    16,
                    AppColors.text,
                    FontWeight.normal,
                    FontStyle.normal,
                  ),
                ),
                value: AppColors.isDarkMode.value,
                onChanged: (bool value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isDarkMode', value);
                  AppColors.isDarkMode.value = value;

                  Get.offNamed(AppRoutes.splash);
                },
              ),
            ),
            // SwitchTheme(
            //   data: const CustomSwitchShape().getSwitchTheme(),
            //   child: SwitchListTile(
            //     secondary: const Icon(Icons.equalizer),
            //     title: Text(
            //       'setting_equalizer'.tr,
            //       style: dynamicStyle(
            //         16,
            //         AppColors.text,
            //         FontWeight.normal,
            //         FontStyle.normal,
            //       ),
            //     ),
            //     value: playerStateController.equalizer.value,
            //     onChanged: (bool value) {
            //       _saveEqualizeValue(value);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
