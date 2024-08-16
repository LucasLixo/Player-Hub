import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/controllers/player.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../shared/utils/slider_shape.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSliderValue();
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

  void _saveSliderValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('songIgnoreTime', value);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.textGray,
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'setting_mode'.tr,
                  style: dynamicStyle(
                    16,
                    AppColors.text,
                    FontWeight.normal,
                    FontStyle.normal,
                  ),
                ),
                SwitchTheme(
                  data: SwitchThemeData(
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return AppColors.primary;
                      },
                    ),
                    thumbColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return AppColors.text;
                      },
                    ),
                    trackColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return AppColors.primary;
                      },
                    ),
                  ),
                  child: Switch(
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Icon(
                            Icons.dark_mode,
                            color: AppColors.background,
                          );
                        }
                        return Icon(
                          Icons.light_mode,
                          color: AppColors.background,
                        );
                      },
                    ),
                    value: AppColors.isDarkMode.value,
                    focusColor: AppColors.textGray,
                    hoverColor: AppColors.textGray,
                    onChanged: (bool value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isDarkMode', value);
                      AppColors.isDarkMode.value = value;

                      Get.offNamed(AppRoutes.splash);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
