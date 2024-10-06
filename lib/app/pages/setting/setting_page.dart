import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/show_toast.dart';
import 'package:playerhub/app/core/app_shared.dart';

class SettingPage extends GetView<PlayerController> {
  SettingPage({super.key});

  final RxInt _sliderValue = AppShared.ignoreTimeValue;
  final RxInt _sortValue = AppShared.defaultGetSongsValue;

  final List<Map<String, dynamic>> _languages = [
    {'title': 'English', 'code': 0},
    {'title': 'Português', 'code': 1},
    {'title': 'Español', 'code': 2},
  ];

  final List<Map<String, dynamic>> _sort = [
    {'title': 'setting_sort2'.tr, 'code': 0},
    {'title': 'setting_sort1'.tr, 'code': 1},
    {'title': 'setting_sort3'.tr, 'code': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.current().text,
            size: 26,
          ),
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
              onTap: () {
                controller.getAllSongs();
                showToast("${'setting_reload'.tr} ${'home_tab1'.tr}");
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.refresh,
                color: AppColors.current().text,
                size: 36,
              ),
            ),
          ),
          // build IgnoreTimeTile
          Obx(
            () => ListTile(
              title: Text(
                'setting_ignore'.trParams({
                  'seconds': _sliderValue.toString(),
                }),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Slider(
                thumbColor: AppColors.current().primary,
                activeColor: AppColors.current().primary,
                min: 0,
                max: 120,
                value: _sliderValue.toDouble(),
                onChanged: (value) {
                  _sliderValue.value = value.toInt();
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
              onTap: () => Get.toNamed(AppRoutes.equalizer),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.graphic_eq,
                color: AppColors.current().text,
                size: 36,
              ),
            ),
          ),
          // build DarkModeTile
          Obx(
            () => ListTile(
              title: Text(
                'setting_mode'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                AppShared.darkModeValue.value
                    ? 'app_enable'.tr
                    : 'app_disable'.tr,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: Switch(
                value: AppShared.darkModeValue.value,
                onChanged: (bool value) async {
                  await AppShared.setDarkMode(value);
                  // if (Get.isSnackbarOpen) Get.back();
                  await Phoenix.rebirth(Get.context!);
                  // Get.toNamed(AppRoutes.splash);
                },
              ),
            ),
          ),
          // build SortOptionTile
          Obx(
            () => ListTile(
              title: Text(
                'setting_sort'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _getTitleForCode(_sort, _sortValue.value),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: PopupMenuButton<int>(
                icon: Icon(
                  Icons.sort_by_alpha,
                  color: AppColors.current().text,
                  size: 32,
                ),
                color: AppColors.current().surface,
                onSelected: (int code) {
                  _sortValue.value = code;
                },
                itemBuilder: (BuildContext context) {
                  return _sort.map((sortOption) {
                    return PopupMenuItem<int>(
                      value: sortOption['code'],
                      child: Text(
                        sortOption['title'],
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          // build LanguageSelectionTile
          ListTile(
            title: Text(
              'setting_language'.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Obx(
              () {
                if (AppShared.languageChangedValue.value) {
                  return Text(
                    _getTitleForCode(
                        _languages, AppShared.defaultLanguageValue.value),
                    style: Theme.of(context).textTheme.labelMedium,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            trailing: PopupMenuButton<int>(
              icon: Icon(
                Icons.language,
                color: AppColors.current().text,
                size: 32,
              ),
              color: AppColors.current().surface,
              onSelected: (int code) {
                // if (Get.isSnackbarOpen) Get.back();
                Get.toNamed(AppRoutes.splash);
                AppShared.setDefaultLanguage(code);
              },
              itemBuilder: (BuildContext context) {
                return _languages.map((languageOption) {
                  return PopupMenuItem<int>(
                    value: languageOption['code'],
                    child: Text(
                      languageOption['title'],
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleForCode(List<Map<String, dynamic>> list, int code) {
    final item = list.firstWhere(
      (element) => element['code'] == code,
    );
    return item['title'];
  }
}
