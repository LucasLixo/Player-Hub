import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/widgets/album_list.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/shared/widgets/folder_list.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';

class HomePage extends GetView<PlayerStateController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.setting);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.sort_rounded,
              color: AppColors.text,
              size: 32,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.playlist, arguments: {
                  'playlistTitle': 'playlist1'.tr,
                  'playlistList': controller.recentList,
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.schedule,
                color: AppColors.text,
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.search);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.search,
                color: AppColors.text,
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
          ],
          title: Text(
            AppShared.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
            indicatorColor: AppColors.primary,
            indicatorWeight: 4,
            labelColor: AppColors.primary,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            unselectedLabelColor: AppColors.textGray,
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
                  const FolderList(),
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
              ? const SizedBox.shrink()
              : const SafeArea(
                  child: Shortcut(),
                ),
        ),
      ),
    );
  }
}
