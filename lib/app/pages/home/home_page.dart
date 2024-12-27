import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/sort_type.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/shared/class/center_text.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/shared/widgets/album_list.dart';
import 'package:player_hub/app/shared/class/folder_list.dart';
import 'package:player_hub/app/shared/dialog/dialog_text_field.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';
import 'package:player_hub/app/shared/class/playlist_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find<PlayerController>();
    final AppShared sharedController = Get.find<AppShared>();
    final AppChrome chromeController = Get.find<AppChrome>();

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.current().background,
          systemOverlayStyle: chromeController.loadThemeByType(
            ThemeTypes.topOneBottomTwo,
          ),
          leading: GestureDetector(
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
            AppManifest.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await Get.toNamed(AppRoutes.playlist, arguments: {
                  'playlistTitle': 'playlist1'.tr,
                  'playlistList': playerController.recentList,
                  'playlistType': SelectionTypes.add,
                });
              },
              child: Icon(
                Icons.schedule,
                color: AppColors.current().text,
                size: 32,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () async {
                await Get.toNamed(AppRoutes.search);
              },
              child: Icon(
                Icons.search,
                color: AppColors.current().text,
                size: 32,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
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
                if (playerController.songAppList.isNotEmpty) {
                  return musicList(
                    songs: playerController.songAppList,
                    first: ListTile(
                      tileColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      contentPadding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                      ),
                      leading: GestureDetector(
                        onTap: () async {
                          if (playerController.songList !=
                              playerController.songAppList) {
                            await playerController.songLoad(
                                playerController.songAppList, 0);
                          } else {
                            await playerController.playSong(0);
                          }
                          await Get.toNamed(AppRoutes.details);
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.current().surface,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Icon(
                            Icons.play_circle,
                            color: AppColors.current().text,
                            size: 32,
                          ),
                        ),
                      ),
                      title: Text(
                        'setting_sort'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Obx(() {
                        return Text(
                          SortType.getTypeTitlebyCode(sharedController
                              .getShared<int>(SharedAttributes.getSongs)),
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                            await sharedController.setShared(
                                SharedAttributes.getSongs, code);
                            await playerController.getAllSongs();
                          },
                          itemBuilder: (BuildContext context) {
                            return SortType.values.map((sortTypeOption) {
                              return PopupMenuItem<int>(
                                value: sortTypeOption.index,
                                child: Text(
                                  SortType.getTypeTitlebyCode(
                                    sortTypeOption.index,
                                  ),
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
                if (playerController.folderList.isNotEmpty ||
                    playerController.playlistList.isNotEmpty) {
                  return Stack(
                    children: [
                      const Positioned.fill(
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              PlaylistList(),
                              FolderList(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          onPressed: () async {
                            final String? result = await dialogTextField(
                              title: 'crud_sheet6'.tr,
                              description: '',
                            );
                            if (result != null) {
                              await playerController.addPlaylist(result);
                            }
                          },
                          backgroundColor: AppColors.current().primary,
                          child: Icon(
                            Icons.add,
                            color: AppColors.current().text,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CenterText(title: 'home_not_tab2'.tr);
                }
              }),
              Obx(() {
                if (playerController.albumList.isNotEmpty &&
                    playerController.albumListSongs.isNotEmpty) {
                  return albumList(
                    albumList: playerController.albumList,
                    albumSongs: playerController.albumListSongs,
                    isAlbumArtist: false,
                  );
                } else {
                  return CenterText(title: 'home_not_tab3'.tr);
                }
              }),
              Obx(() {
                if (playerController.artistList.isNotEmpty &&
                    playerController.artistListSongs.isNotEmpty) {
                  return albumList(
                    albumList: playerController.artistList,
                    albumSongs: playerController.artistListSongs,
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
          () => playerController.songAppList.isEmpty
              ? const SizedBox.shrink()
              : const Shortcut(),
        ),
      ),
    );
  }
}
