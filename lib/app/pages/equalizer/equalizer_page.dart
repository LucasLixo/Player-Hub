import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/shared/utils/my_toastification.dart';
import 'package:playerhub/app/shared/utils/slider_shape.dart';
import 'package:playerhub/app/shared/utils/switch_theme.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({super.key});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  bool _equalizerMode = AppShared.equalizerModeValue.value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: InkWell(
          onTap: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          'setting_equalizer'.tr,
          style: dynamicStyle(
            fontSize: 20,
            fontColor: AppColors.text,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
        actions: [
          SwitchTheme(
            data: getSwitchTheme(),
            child: Switch(
              value: _equalizerMode,
              onChanged: (bool value) async {
                await AppShared.setEqualizerMode(value);
                EqualizerFlutter.setEnabled(value);
                setState(() {
                  _equalizerMode = value;
                });
                if (mounted) {
                  myToastification(
                    context: context,
                    title: value
                        ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
                        : "${'setting_equalizer'.tr} ${'app_disable'.tr}",
                    icon: Icons.graphic_eq,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'setting_reset'.tr,
              style: titleStyle(),
            ),
            trailing: InkWell(
              onTap: () {
                AppShared.frequencyValue[0] = 3.0;
                AppShared.frequencyValue[1] = 0.0;
                AppShared.frequencyValue[2] = 0.0;
                AppShared.frequencyValue[3] = 0.0;
                AppShared.frequencyValue[4] = 3.0;
                AppShared.setAllFrequency(AppShared.frequencyValue);
                myToastification(
                  context: context,
                  title: 'setting_reset'.tr,
                  icon: Icons.refresh,
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.refresh,
                color: AppColors.text,
                size: 36,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'equalizer_frequency1'.tr,
                  style: titleStyle(),
                ),
                Text(
                  'equalizer_frequency2'.tr,
                  style: titleStyle(),
                ),
              ],
            ),
          ),
          FutureBuilder<List<int>>(
            future: EqualizerFlutter.getBandLevelRange(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return CustomEQ(
                    enabled: _equalizerMode,
                    bandLevelRange: snapshot.data!,
                  );
                } else if (snapshot.hasError) {
                  return CenterText(title: 'Error: ${snapshot.error}');
                }
              }
              return CenterText(title: 'Error: ${snapshot.error}');
            },
          ),
        ],
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ({
    super.key,
    required this.enabled,
    required this.bandLevelRange,
  });

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  State<CustomEQ> createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  late Future<List<int>> fetchCenterBandFreqs;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchCenterBandFreqs = EqualizerFlutter.getCenterBandFreqs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: fetchCenterBandFreqs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            int bandId = 0;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.map((freq) {
                    return _buildSliderBand(freq, bandId++);
                  }).toList(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return CenterText(title: 'Error: ${snapshot.error}');
          }
        }
        return CenterText(title: 'cloud_error1'.tr);
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 250,
            child: Obx(() {
              double value = AppShared.frequencyValue[bandId];

              return RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: getSliderTheme(),
                  child: Center(
                    child: Slider(
                      thumbColor: AppColors.primary,
                      inactiveColor: AppColors.onBackground,
                      activeColor: AppColors.primary,
                      min: min,
                      max: max,
                      value: value,
                      onChanged: widget.enabled
                          ? (lowerValue) {
                              AppShared.frequencyValue[bandId] = lowerValue;
                              EqualizerFlutter.setBandLevel(
                                bandId,
                                lowerValue.toInt(),
                              );
                              setState(() {
                                value = lowerValue;
                              });
                              AppShared.setAllFrequency(
                                  AppShared.frequencyValue);
                            }
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${freq ~/ 1000} Hz',
            style: subtitleStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
