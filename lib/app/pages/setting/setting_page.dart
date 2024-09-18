import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/show_toast.dart';
import 'package:playerhub/app/shared/utils/slider_shape.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/switch_theme.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final playerController = Get.find<PlayerController>();

  int _sliderValue = AppShared.ignoreTimeValue.value;
  int _sortValue = AppShared.defaultGetSongsValue.value;

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
  void dispose() {
    if (_sliderValue != AppShared.ignoreTimeValue.value ||
        _sortValue != AppShared.defaultGetSongsValue.value) {
      AppShared.setIgnoreTime(_sliderValue);
      AppShared.setDefaultGetSong(_sortValue);
      playerController.getAllSongs();
    }
    super.dispose();
  }

  String getTitleForCode(List<Map<String, dynamic>> list, int code) {
    final item = list.firstWhere(
      (element) => element['code'] == code,
    );
    return item['title'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          'setting_title'.tr,
          style: dynamicStyle(
            fontSize: 20,
            fontColor: AppColors.text,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReloadSongs(),
          _buildIgnoreTimeTile(),
          _buildEqualizer(),
          _buildDarkModeTile(),
          _buildSortOptionTile(),
          _buildLanguageSelectionTile(),
        ],
      ),
    );
  }

  Widget _buildReloadSongs() {
    return ListTile(
      title: Text(
        "${'setting_reload'.tr} ${'home_tab1'.tr}",
        style: titleStyle(),
      ),
      trailing: InkWell(
        onTap: () {
          playerController.getAllSongs();
          showToast("${'setting_reload'.tr} ${'home_tab1'.tr}");
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Icon(
          Icons.refresh,
          color: AppColors.text,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildIgnoreTimeTile() {
    return ListTile(
      title: Text(
        'setting_ignore'.trParams({
          'seconds': _sliderValue.toString(),
        }),
        style: titleStyle(),
      ),
      subtitle: SliderTheme(
        data: getSliderTheme(),
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
          },
        ),
      ),
    );
  }

  Widget _buildEqualizer() {
    return ListTile(
      title: Text(
        'setting_equalizer'.tr,
        style: titleStyle(),
      ),
      trailing: InkWell(
        onTap: () => Get.toNamed(AppRoutes.equalizer),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Icon(
          Icons.graphic_eq,
          color: AppColors.text,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildDarkModeTile() {
    return ListTile(
      title: Text(
        'setting_mode'.tr,
        style: titleStyle(),
      ),
      subtitle: Text(
        AppShared.darkModeValue.value ? 'app_enable'.tr : 'app_disable'.tr,
        style: subtitleStyle(),
      ),
      trailing: SwitchTheme(
        data: getSwitchTheme(),
        child: Obx(
          () => Switch(
            value: AppShared.darkModeValue.value,
            onChanged: (bool value) async {
              await AppShared.setDarkMode(value);
              if (mounted) {
                Phoenix.rebirth(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptionTile() {
    return ListTile(
      title: Text(
        'setting_sort'.tr,
        style: titleStyle(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        getTitleForCode(_sort, _sortValue),
        style: subtitleStyle(),
      ),
      trailing: PopupMenuButton<int>(
        icon: Icon(
          Icons.sort_by_alpha,
          color: AppColors.text,
          size: 32,
        ),
        color: AppColors.surface,
        onSelected: (int code) {
          setState(() {
            _sortValue = code;
          });
        },
        itemBuilder: (BuildContext context) {
          return _sort.map((sortOption) {
            return PopupMenuItem<int>(
              value: sortOption['code'],
              child: Text(
                sortOption['title'],
                style: subtitleStyle(),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildLanguageSelectionTile() {
    return ListTile(
      title: Text(
        'setting_language'.tr,
        style: titleStyle(),
      ),
      subtitle: Obx(
        () {
          if (AppShared.languageChangedValue.value) {
            return Text(
              getTitleForCode(_languages, AppShared.defaultLanguageValue.value),
              style: subtitleStyle(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      trailing: PopupMenuButton<int>(
        icon: Icon(
          Icons.language,
          color: AppColors.text,
          size: 32,
        ),
        color: AppColors.surface,
        onSelected: (int code) {
          AppShared.setDefaultLanguage(code);
        },
        itemBuilder: (BuildContext context) {
          return _languages.map((languageOption) {
            return PopupMenuItem<int>(
              value: languageOption['code'],
              child: Text(
                languageOption['title'],
                style: subtitleStyle(),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
