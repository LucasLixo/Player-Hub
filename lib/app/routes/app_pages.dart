import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:player_hub/app/routes/app_bindings.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/routes/app_imports.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.wait,
      page: () => const WaitPage(error: false),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.error,
      page: () => const WaitPage(error: true),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(
        function: Get.arguments['function'],
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
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
      page: () => EditPage(
        song: Get.arguments['song'],
      ),
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
      name: AppRoutes.equalizer,
      page: () => const EqualizerPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        AppBinding().equalizerController();
      }),
    ),
    GetPage(
      name: AppRoutes.playlist,
      page: () => PlaylistPage(
        playlistTitle: Get.arguments['playlistTitle'],
        playlistList: Get.arguments['playlistList'],
        playlistType: Get.arguments['playlistType'],
        isPlaylist: Get.arguments['isPlaylist'] ?? false,
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.selectionAdd,
      page: () => SelectionAddPage(
        selectionTitle: Get.arguments['selectionTitle'],
        selectionIndex: Get.arguments['selectionIndex'],
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        AppBinding().selectionController();
      }),
    ),
    GetPage(
      name: AppRoutes.selectionRemove,
      page: () => SelectionRemovePage(
        selectionTitle: Get.arguments['selectionTitle'],
        selectionIndex: Get.arguments['selectionIndex'],
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        AppBinding().selectionController();
      }),
    ),
  ];
}
