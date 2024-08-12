import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../shared/utils/subtitle_style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
      body: Center(
        child: Text(
          'Configurações',
          style: subtitleStyle(),
        ),
      ),
    );
  }
}
