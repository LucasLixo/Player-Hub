import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/services/app_bindings.dart';

class AppObserver extends GetObserver {
  // ==================================================
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      Future.microtask(() {
        _exePushBefore(route.settings.name!);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _exePushAfter(route.settings.name!);
      });
    }
  }

  // ==================================================
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      Future.microtask(() {
        _exePopBefore(route.settings.name!);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _exePopAfter(route.settings.name!);
      });
    }
  }

  // ==================================================
  void _exePushBefore(String routeName) {
    switch (routeName) {
      case AppRoutes.wait:
        return;
      case AppRoutes.error:
        return;
      case AppRoutes.splash:
        return;
      case AppRoutes.home:
        return;
      case AppRoutes.setting:
        return;
      case AppRoutes.details:
        return;
      case AppRoutes.edit:
        // AppBinding().editController();
        return;
      case AppRoutes.search:
        return;
      case AppRoutes.playlist:
        return;
      case AppRoutes.equalizer:
        AppBinding().equalizerController();
        return;
      case AppRoutes.selectionAdd:
        AppBinding().selectionController();
        return;
      case AppRoutes.selectionRemove:
        AppBinding().selectionController();
        return;
    }
  }

  // ==================================================
  void _exePushAfter(String routeName) {
    switch (routeName) {
      case AppRoutes.wait:
        return;
      case AppRoutes.error:
        return;
      case AppRoutes.splash:
        return;
      case AppRoutes.home:
        return;
      case AppRoutes.setting:
        return;
      case AppRoutes.details:
        return;
      case AppRoutes.edit:
        return;
      case AppRoutes.search:
        return;
      case AppRoutes.playlist:
        return;
      case AppRoutes.equalizer:
        return;
      case AppRoutes.selectionAdd:
        return;
      case AppRoutes.selectionRemove:
        return;
    }
  }

  // ==================================================
  void _exePopAfter(String routeName) {
    switch (routeName) {
      case AppRoutes.wait:
        return;
      case AppRoutes.error:
        return;
      case AppRoutes.splash:
        return;
      case AppRoutes.home:
        return;
      case AppRoutes.setting:
        return;
      case AppRoutes.details:
        return;
      case AppRoutes.edit:
        return;
      case AppRoutes.search:
        return;
      case AppRoutes.playlist:
        return;
      case AppRoutes.equalizer:
        return;
      case AppRoutes.selectionAdd:
        return;
      case AppRoutes.selectionRemove:
        return;
    }
  }

  // ==================================================
  void _exePopBefore(String routeName) {
    switch (routeName) {
      case AppRoutes.wait:
        return;
      case AppRoutes.error:
        return;
      case AppRoutes.splash:
        return;
      case AppRoutes.home:
        return;
      case AppRoutes.setting:
        return;
      case AppRoutes.details:
        return;
      case AppRoutes.edit:
        return;
      case AppRoutes.search:
        return;
      case AppRoutes.playlist:
        return;
      case AppRoutes.equalizer:
        return;
      case AppRoutes.selectionAdd:
        return;
      case AppRoutes.selectionRemove:
        return;
    }
  }
}
