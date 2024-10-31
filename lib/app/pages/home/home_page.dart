import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/shared/widgets/album_list.dart';
import 'package:player_hub/app/shared/widgets/shortcut.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';
import 'package:player_hub/app/shared/widgets/folder_list.dart';
import 'package:helper_hub/src/theme_widget.dart';

class HomePage extends GetView<PlayerController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.current().background,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.current().background,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: InkWell(
            onTap: () async {
              await Get.toNamed(AppRoutes.setting);
            },
            child: Icon(
              Icons.sort_rounded,
              color: AppColors.current().text,
              size: 32,
            ),
          ),
          title: Text(
            AppShared.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            InkWell(
              onTap: () async {
                await Get.toNamed(AppRoutes.playlist, arguments: {
                  'playlistTitle': 'playlist1'.tr,
                  'playlistList': controller.recentList,
                });
              },
              child: Icon(
                Icons.schedule,
                color: AppColors.current().text,
                size: 32,
              ),
            ),
            const Space(),
            InkWell(
              onTap: () async {
                await Get.toNamed(AppRoutes.search);
              },
              child: Icon(
                Icons.search,
                color: AppColors.current().text,
                size: 32,
              ),
            ),
            const Space(),
          ],
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
            indicatorColor: AppColors.current().primary,
            indicatorWeight: 4,
            labelColor: AppColors.current().primary,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            unselectedLabelColor: AppColors.current().textGray,
            tabs: <Tab>[
              Tab(text: 'home_tab1'.tr),
              Tab(text: 'home_tab2'.tr),
              Tab(text: 'home_tab3'.tr),
              Tab(text: 'home_tab4'.tr),
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.songAllList.isEmpty) {
              return TabBarView(
                children: <Widget>[
                  CenterText(title: 'home_not_tab1'.tr),
                  CenterText(title: 'home_not_tab2'.tr),
                  CenterText(title: 'home_not_tab3'.tr),
                  CenterText(title: 'home_not_tab4'.tr),
                ],
              );
            } else {
              return TabBarView(
                children: <Widget>[
                  MusicList(songs: controller.songAllList),
                  FolderList(),
                  AlbumList(
                    albumList: controller.albumList,
                    albumSongs: controller.albumListSongs,
                    isAlbumArtist: false,
                  ),
                  AlbumList(
                    albumList: controller.artistList,
                    albumSongs: controller.artistListSongs,
                    isAlbumArtist: true,
                  ),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Obx(
          () => controller.songAllList.isEmpty
              ? const Space(size: 0)
              : const Shortcut(),
        ),
      ),
    );
  }
}
