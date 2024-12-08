import 'package:flutter/material.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/types/app_functions.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:player_hub/app/pages/equalizer/equalize_controller.dart';

class EqualizerPage extends StatelessWidget with AppFunctions {
  const EqualizerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final EqualizerController equalizerController =
        Get.find<EqualizerController>();
    final AppShared sharedController = Get.find<AppShared>();

    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().background,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
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
        actions: <Widget>[
          Obx(() {
            return Switch(
              value: sharedController
                  .getShared<bool>(SharedAttributes.equalizeMode),
              onChanged: (bool value) async {
                await equalizerController.toggleEqualizer(value);
              },
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (equalizerController.bandLevelRange.value != null &&
              equalizerController.bandCenterFrequencies.value != null) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'setting_reset'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      await sharedController.setShared(
                        SharedAttributes.frequency,
                        SharedAttributes.frequency.value,
                      );
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 32,
                      color: AppColors.current().text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                Obx(() {
                  return _customEQ(
                    context,
                    enabled: sharedController
                        .getShared<bool>(SharedAttributes.equalizeMode),
                    bandLevelRange: equalizerController.bandLevelRange.value!,
                  );
                })
              ],
            );
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _customEQ(
    BuildContext context, {
    required bool enabled,
    required List<int> bandLevelRange,
  }) {
    final EqualizerController equalizerController =
        Get.find<EqualizerController>();

    int bandId = 0;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              equalizerController.bandCenterFrequencies.value!.map((freq) {
            return _buildSliderBand(
              context,
              enabled: enabled,
              freq: freq,
              bandId: bandId++,
              minLevel: bandLevelRange[0].toDouble(),
              maxLevel: bandLevelRange[1].toDouble(),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSliderBand(
    BuildContext context, {
    required bool enabled,
    required int freq,
    required int bandId,
    required double minLevel,
    required double maxLevel,
  }) {
    final AppShared sharedController = Get.find<AppShared>();

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
                  final RxDouble result = sharedController
                      .getShared<List<double>>(
                          SharedAttributes.frequency)[bandId]
                      .obs;

                  EqualizerFlutter.setBandLevel(
                    bandId,
                    result.value.toInt(),
                  );

                  return Slider(
                    thumbColor: AppColors.current().primary,
                    activeColor: AppColors.current().primary,
                    min: minLevel,
                    max: maxLevel,
                    value: result.value,
                    onChanged: enabled
                        ? (lowerValue) {
                            result.value = lowerValue;
                            List<double> listBand = List.from(sharedController
                                .sharedMap[SharedAttributes.frequency.name]);

                            listBand[bandId] = lowerValue;

                            EqualizerFlutter.setBandLevel(
                              bandId,
                              lowerValue.toInt(),
                            );

                            sharedController.setShared(
                              SharedAttributes.frequency,
                              listBand,
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
