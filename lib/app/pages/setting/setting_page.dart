import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/languages.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
// import 'package:player_hub/app/core/enums/sort_type.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final PlayerController controller = Get.find<PlayerController>();

  final RxBool isEdited = false.obs;

  @override
  void dispose() {
    if (isEdited.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.getAllSongs();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'setting_title'.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // build ReloadSongs
            ListTile(
              title: Text(
                "${'setting_reload'.tr} ${'home_tab1'.tr}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Icon(
                Icons.refresh,
                color: AppColors.current().text,
                size: 32,
              ),
              onTap: () async {
                await controller.getAllSongs();
              },
            ),
            // build IgnoreTimeTile
            Obx(
              () => ListTile(
                title: Text(
                  'setting_ignore'.trParams({
                    'seconds': AppShared.getShared(SharedAttributes.ignoreTime)
                        .toString(),
                  }),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Slider(
                  thumbColor: AppColors.current().primary,
                  activeColor: AppColors.current().primary,
                  min: 0,
                  max: 120,
                  value:
                      (AppShared.getShared(SharedAttributes.ignoreTime) as int)
                          .toDouble(),
                  onChanged: (value) async {
                    await AppShared.setShared(
                      SharedAttributes.ignoreTime,
                      value.toInt(),
                    );
                    isEdited.value = true;
                  },
                ),
              ),
            ),
            // build Equalizer
            ListTile(
              title: Text(
                'setting_equalizer'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Obx(() {
                return Text(
                  AppShared.getShared(SharedAttributes.equalizeMode)
                      ? 'app_enable'.tr
                      : 'app_disable'.tr,
                  style: Theme.of(context).textTheme.labelMedium,
                );
              }),
              trailing: Icon(
                Icons.graphic_eq,
                color: AppColors.current().text,
                size: 32,
              ),
              onTap: () async {
                await Get.toNamed(AppRoutes.equalizer);
              },
            ),
            // build DarkModeTile
            ListTile(
              title: Text(
                'setting_mode'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Obx(() {
                return Text(
                  AppShared.getShared(SharedAttributes.darkMode)
                      ? 'app_enable'.tr
                      : 'app_disable'.tr,
                  style: Theme.of(context).textTheme.labelMedium,
                );
              }),
              trailing: Obx(() {
                return Switch(
                  value: AppShared.getShared(SharedAttributes.darkMode),
                  onChanged: (bool value) async {
                    await AppShared.setShared(SharedAttributes.darkMode, value);
                    await AppShared.loadTheme(isRebirth: true);
                  },
                );
              }),
            ),
            ListTile(
              title: Text(
                'setting_language'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Obx(() {
                if (AppShared.getShared(SharedAttributes.changeLanguage)) {
                  return Text(
                    AppLanguages.getLanguagesTitleByCode(
                      AppShared.getShared(SharedAttributes.defaultLanguage),
                    ),
                    style: Theme.of(context).textTheme.labelMedium,
                  );
                } else {
                  return const Space(size: 0);
                }
              }),
              trailing: Obx(() {
                return PopupMenuButton<int>(
                  icon: Icon(
                    Icons.language,
                    color: AppColors.current().text,
                    size: 32,
                  ),
                  color: AppColors.current().surface,
                  onSelected: (int code) async {
                    await AppShared.setShared(
                        SharedAttributes.defaultLanguage, code);
                    await AppShared.setShared(
                        SharedAttributes.changeLanguage, true);

                    await Get.toNamed(AppRoutes.splash, arguments: {
                      'function': () async {
                        await Future.wait([
                          Future.delayed(const Duration(seconds: 1)),
                          AppShared.updatedLocale(),
                        ]);
                      },
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return AppLanguages.values.map((appLanguagesOption) {
                      return PopupMenuItem<int>(
                        value: appLanguagesOption.code,
                        child: Text(
                          appLanguagesOption.title,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    }).toList();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
