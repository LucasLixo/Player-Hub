import 'package:get/route_manager.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/routes/app_imports.dart';
import 'package:flutter/material.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.wait,
      page: () => const SafeArea(child: WaitPage(error: false)),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.error,
      page: () => const SafeArea(child: WaitPage(error: true)),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SafeArea(child: SplashPage()),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const SafeArea(child: HomePage()),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => const SafeArea(child: SettingPage()),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const SafeArea(child: DetailsPage()),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.edit,
      page: () => SafeArea(
          child: EditPage(
        song: Get.arguments['song'],
      )),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SafeArea(
        child: SearchPage(),
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.equalizer,
      page: () => const SafeArea(child: EqualizerPage()),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.playlist,
      page: () => SafeArea(
          child: PlaylistPage(
        playlistTitle: Get.arguments['playlistTitle'],
        playlistList: Get.arguments['playlistList'],
      )),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
  ];
}
