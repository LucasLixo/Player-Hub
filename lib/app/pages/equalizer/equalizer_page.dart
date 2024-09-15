import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/shared/utils/show_toast.dart';
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
  // final playerStateController = Get.find<PlayerStateController>();

  final RxBool _equalizerMode = AppShared.equalizerModeValue.value.obs;

  @override
  void initState() {
    super.initState();
    final sessionId = playerController.audioPlayer.androidAudioSessionId;
    if (sessionId != null) {
      _initializeEqualizer(sessionId);
    }
  }

  Future<void> _initializeEqualizer(int id) async {
    await EqualizerFlutter.init(id);
    await EqualizerFlutter.open(id);
    await EqualizerFlutter.setAudioSessionId(id);
    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        AppShared.frequencyValue[i].toInt(),
      );
    }
    await EqualizerFlutter.setEnabled(_equalizerMode.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
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
          Obx(
            () => SwitchTheme(
              data: getSwitchTheme(),
              child: Switch(
                value: _equalizerMode.value,
                onChanged: (bool value) async {
                  await AppShared.setEqualizerMode(value);
                  EqualizerFlutter.setEnabled(value);
                  _equalizerMode.value = value;

                  if (mounted) {
                    showToast(value
                        ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
                        : "${'setting_equalizer'.tr} ${'app_disable'.tr}");
                  }
                },
              ),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Obx(
                    () => CustomEQ(
                      enabled: _equalizerMode.value,
                      bandLevelRange: snapshot.data!,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox.shrink();
                  // return CenterText(title: 'Error: ${snapshot.error}');
                } else {
                  return const SizedBox.shrink();
                  // return const CenterText(title: 'No data available');
                }
              } else {
                return const CenterText(title: 'Unexpected state');
              }
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
            child: RotatedBox(
              quarterTurns: -1,
              child: SliderTheme(
                data: getSliderTheme(),
                child: Center(
                  child: Obx(() {
                    final RxDouble value = AppShared.frequencyValue[bandId].obs;

                    return Slider(
                      thumbColor: AppColors.primary,
                      inactiveColor: AppColors.onBackground,
                      activeColor: AppColors.primary,
                      min: min,
                      max: max,
                      value: value.value,
                      onChanged: widget.enabled
                          ? (lowerValue) {
                              value.value = lowerValue;
                              AppShared.frequencyValue[bandId] = lowerValue;
                              EqualizerFlutter.setBandLevel(
                                bandId,
                                lowerValue.toInt(),
                              );
                              AppShared.setAllFrequency(
                                  AppShared.frequencyValue);
                            }
                          : null,
                    );
                  }),
                ),
              ),
            ),
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
