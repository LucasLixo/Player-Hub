import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/sort_type.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:player_hub/app/shared/widgets/album_list.dart';
import 'package:player_hub/app/shared/widgets/crud_create_playlist.dart';
import 'package:player_hub/app/shared/class/folder_list.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';
import 'package:player_hub/app/shared/class/playlist_list.dart';

class HomePage extends GetView<PlayerController> {
  const HomePage({
    super.key,
  });

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
            systemNavigationBarColor: AppColors.current().surface,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: AppColors.current().brightness,
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
                  'playlistType': SelectionTypes.none,
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
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              Obx(() {
                if (controller.songAppList.isNotEmpty) {
                  return musicList(
                    songs: controller.songAppList,
                    first: ListTile(
                      tileColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      contentPadding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                      ),
                      title: Text(
                        'setting_sort'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Obx(() {
                        return Text(
                          SortType.getTypeTitlebyCode(
                              AppShared.getShared(SharedAttributes.getSongs)),
                          style: Theme.of(context).textTheme.labelMedium,
                        );
                      }),
                      trailing: Obx(() {
                        return PopupMenuButton<int>(
                          icon: Icon(
                            Icons.swap_vert,
                            color: AppColors.current().text,
                            size: 32,
                          ),
                          color: AppColors.current().surface,
                          onSelected: (int code) async {
                            await AppShared.setShared(
                                SharedAttributes.getSongs, code);
                            await controller.getAllSongs();
                          },
                          itemBuilder: (BuildContext context) {
                            return SortType.values.map((sortTypeOption) {
                              return PopupMenuItem<int>(
                                value: sortTypeOption.index,
                                child: Text(
                                  SortType.getTypeTitlebyCode(
                                      sortTypeOption.index),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              );
                            }).toList();
                          },
                        );
                      }),
                    ),
                    selectiontype: SelectionTypes.add,
                  );
                } else {
                  return CenterText(title: 'home_not_tab1'.tr);
                }
              }),
              Obx(() {
                if (controller.folderList.isNotEmpty ||
                    controller.playlistList.isNotEmpty) {
                  return const SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        PlaylistList(),
                        FolderList(),
                      ],
                    ),
                  );
                } else {
                  return CenterText(title: 'home_not_tab2'.tr);
                }
              }),
              Obx(() {
                if (controller.albumList.isNotEmpty &&
                    controller.albumListSongs.isNotEmpty) {
                  return albumList(
                    albumList: controller.albumList,
                    albumSongs: controller.albumListSongs,
                    isAlbumArtist: false,
                  );
                } else {
                  return CenterText(title: 'home_not_tab3'.tr);
                }
              }),
              Obx(() {
                if (controller.artistList.isNotEmpty &&
                    controller.artistListSongs.isNotEmpty) {
                  return albumList(
                    albumList: controller.artistList,
                    albumSongs: controller.artistListSongs,
                    isAlbumArtist: true,
                  );
                } else {
                  return CenterText(title: 'home_not_tab4'.tr);
                }
              }),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => controller.songAppList.isEmpty
              ? const Space(size: 0)
              : const Shortcut(),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final TabController tabController =
                DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: tabController,
              builder: (context, _) {
                return tabController.index == 1
                    ? FloatingActionButton(
                        onPressed: () async {
                          await crudCreatePlaylist();
                        },
                        backgroundColor: AppColors.current().primary,
                        child: Icon(
                          Icons.add,
                          color: AppColors.current().text,
                          size: 32,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
