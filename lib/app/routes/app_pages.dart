import 'package:get/get.dart';
import 'app_routes.dart';
import 'app_imports.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const DetailsView(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.playlist,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return PlaylistView(
          playlistTitle: args['title'],
          playlistList: args['songs'],
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeft,
    ),
  ];
}
