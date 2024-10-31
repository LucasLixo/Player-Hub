import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/shared/utils/show_toast.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';

class EqualizerPage extends GetView<PlayerController> {
  const EqualizerPage({super.key});

  Future<void> _initializeEqualizer(int id) async {
    await EqualizerFlutter.init(id);
    await EqualizerFlutter.open(id);
    await EqualizerFlutter.setAudioSessionId(id);
    for (int i = 0; i < 5; i++) {
      await EqualizerFlutter.setBandLevel(
        i,
        AppShared.getShared(SharedAttributes.frequency)[i].toInt(),
      );
    }
    await EqualizerFlutter.setEnabled(
      AppShared.getShared(SharedAttributes.equalizeMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int? sessionId = controller.audioPlayer.androidAudioSessionId;
    if (sessionId != null) {
      _initializeEqualizer(sessionId);
    }

    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().background,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.current().background,
          statusBarIconBrightness: AppColors.current().brightness,
          systemNavigationBarColor: AppColors.current().background,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.current().text,
            size: 32,
          ),
        ),
        title: Text(
          'setting_equalizer'.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Obx(
            () => Switch(
              value: AppShared.getShared(SharedAttributes.equalizeMode),
              onChanged: (bool value) async {
                await AppShared.setShared(
                  SharedAttributes.equalizeMode,
                  value,
                );
                await EqualizerFlutter.setEnabled(value);
                for (int i = 0; i < 5; i++) {
                  await EqualizerFlutter.setBandLevel(
                    i,
                    AppShared.getShared(SharedAttributes.frequency)[i].toInt(),
                  );
                }
                await showToast(value
                    ? "${'setting_equalizer'.tr} ${'app_enable'.tr}"
                    : "${'setting_equalizer'.tr} ${'app_disable'.tr}");
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
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: InkWell(
              onTap: () async {
                await AppShared.setShared(SharedAttributes.frequency,
                    SharedAttributes.frequency.value);
              },
              child: const Icon(
                Icons.refresh,
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
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  'equalizer_frequency2'.tr,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          FutureBuilder<List<int>>(
            future: EqualizerFlutter.getBandLevelRange(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Space(size: 0);
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Obx(
                    () => CustomEQ(
                      enabled:
                          AppShared.getShared(SharedAttributes.equalizeMode),
                      bandLevelRange: snapshot.data!,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Space(size: 0);
                }
              }
              return const CenterText(title: 'Unexpected state');
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
            return CenterText(title: 'cloud_error1'.tr);
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
          const Space(
            size: 16,
            orientation: Axis.vertical,
          ),
          SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: -1,
              child: Center(
                child: Obx(() {
                  final RxDouble value = RxDouble(
                    AppShared.getShared(SharedAttributes.frequency)[bandId]
                        as double,
                  );

                  EqualizerFlutter.setBandLevel(
                    bandId,
                    value.value.toInt(),
                  );

                  return Slider(
                    thumbColor: AppColors.current().primary,
                    activeColor: AppColors.current().primary,
                    min: min,
                    max: max,
                    value: value.value,
                    onChanged: widget.enabled
                        ? (lowerValue) {
                            value.value = lowerValue;
                            AppShared.sharedMap[SharedAttributes.frequency.name]
                                [bandId] = lowerValue;
                            EqualizerFlutter.setBandLevel(
                              bandId,
                              lowerValue.toInt(),
                            );
                            AppShared.setShared(
                              SharedAttributes.frequency,
                              AppShared
                                  .sharedMap[SharedAttributes.frequency.name],
                            );
                          }
                        : null,
                  );
                }),
              ),
            ),
          ),
          const Space(
            size: 12,
            orientation: Axis.vertical,
          ),
          Text(
            '${freq ~/ 1000} Hz',
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
