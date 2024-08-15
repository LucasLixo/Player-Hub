import 'package:get/route_manager.dart';

import 'app_routes.dart';
import 'app_imports.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const DetailsPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.playlist,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return PlaylistPage(
          playlistTitle: args['title'],
          playlistList: args['songs'],
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
  ];
}
