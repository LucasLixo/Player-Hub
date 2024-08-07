import 'package:get/get.dart';

import 'app_routes.dart';
import 'app_imports.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.listMusic,
      page: () => const ListMusicView(),
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const DetailsView(),
      transitionDuration: const Duration(milliseconds: 350),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      transitionDuration: const Duration(milliseconds: 350),
      transition: Transition.rightToLeft,
    ),
  ];
}
