import 'package:get/route_manager.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/routes/app_imports.dart';

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
      name: AppRoutes.edit,
      page: () {
        return EditPage(
          song: Get.arguments['song'],
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
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
        return PlaylistPage(
          playlistTitle: Get.arguments['title'],
          playlistList: Get.arguments['songs'],
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
  ];
}
