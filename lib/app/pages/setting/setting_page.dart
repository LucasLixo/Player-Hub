import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:player/app/shared/utils/slider_shape.dart';
import '../../core/player/player_export.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  int _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _loadSliderValue();
  }

  @override
  void dispose() {
    playerController.getAllSongs();
    super.dispose();
  }

  void _loadSliderValue() async {
    await playerStateController.loadSliderValue();
    setState(() {
      _sliderValue = playerStateController.songIgnoreTime.value;
    });
  }

  void _saveSliderValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('songIgnoreTime', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackgroundDark,
      appBar: AppBar(
        backgroundColor: colorBackgroundDark,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const Icon(
            Icons.arrow_back_ios,
            color: colorWhite,
            size: 26,
          ),
        ),
        title: Text(
          'Configurações',
          style: dynamicStyle(
            20,
            colorWhite,
            FontWeight.normal,
            FontStyle.normal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(
              color: colorWhiteGray,
            ),
            Text(
              'Ignorar Audio Menores que: ${_sliderValue.toString()} segundos.',
              style: dynamicStyle(
                16,
                colorWhite,
                FontWeight.normal,
                FontStyle.normal,
              ),
            ),
            SliderTheme(
              data: const SliderThemeData(
                trackShape: CustomSliderTrackShape(),
              ),
              child: Slider(
                thumbColor: colorWhite,
                inactiveColor: colorGray,
                activeColor: colorWhite,
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
          ],
        ),
      ),
    );
  }
}
