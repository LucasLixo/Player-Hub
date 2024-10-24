import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/languages.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/sort_type.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/shared/utils/show_toast.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_widget.dart';

class SettingPage extends GetView<PlayerController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.current().background,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'setting_title'.tr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // build ReloadSongs
            ListTile(
              title: Text(
                "${'setting_reload'.tr} ${'home_tab1'.tr}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: InkWell(
                onTap: () async {
                  await controller.getAllSongs();
                  await showToast("${'setting_reload'.tr} ${'home_tab1'.tr}");
                },
                child: const Icon(
                  Icons.refresh,
                  size: 32,
                ),
              ),
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
                  value: AppShared.getShared(SharedAttributes.ignoreTime)
                      .toDouble(),
                  onChanged: (value) async {
                    await AppShared.setShared(
                        SharedAttributes.ignoreTime, value.toInt());
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
              trailing: InkWell(
                onTap: () async {
                  await Get.toNamed(AppRoutes.equalizer);
                },
                child: Icon(
                  Icons.graphic_eq,
                  color: AppColors.current().text,
                  size: 32,
                ),
              ),
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
                    await Phoenix.rebirth(Get.context!);
                  },
                );
              }),
            ),
            // build SortOptionTile
            ListTile(
              title: Text(
                'setting_sort'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Obx(() {
                return Text(
                  SortType.getTypeTitlebyCode(
                      AppShared.getShared(SharedAttributes.getSongs)),
                  style: Theme.of(context).textTheme.labelMedium,
                );
              }),
              trailing: Obx(() {
                return PopupMenuButton<int>(
                  icon: const Icon(
                    Icons.sort_by_alpha,
                    size: 32,
                  ),
                  color: AppColors.current().surface,
                  onSelected: (int code) async {
                    await AppShared.setShared(SharedAttributes.getSongs, code);
                  },
                  itemBuilder: (BuildContext context) {
                    return SortType.values.map((sortTypeOption) {
                      return PopupMenuItem<int>(
                        value: sortTypeOption.index,
                        child: Text(
                          SortType.getTypeTitlebyCode(sortTypeOption.index),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    }).toList();
                  },
                );
              }),
            ),
            // build LanguageSelectionTile
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
                    await Get.toNamed(AppRoutes.splash);
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
