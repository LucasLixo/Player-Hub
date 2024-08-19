import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/widgets/shortcut.dart';
import '../../core/controllers/player.dart';
import '../../core/app_constants.dart';
import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../shared/widgets/music_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    if (playerStateController.songAllList.isEmpty) {
      playerController.getAllSongs();
    }
  }

  static List<Tab> homeTabs = <Tab>[
    Tab(text: 'home_tab1'.tr),
    Tab(text: 'home_tab2'.tr),
    Tab(text: 'home_tab3'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: homeTabs.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
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
                  'title': 'playlist1'.tr,
                  'songs': playerStateController.recentList,
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
            const SizedBox(
              width: 8,
            ),
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
          ],
          title: Text(
            constAppTitle,
            style: dynamicStyle(
              20,
              AppColors.text,
              FontWeight.normal,
              FontStyle.normal,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            labelStyle: dynamicStyle(
              18,
              AppColors.text,
              FontWeight.normal,
              FontStyle.normal,
            ),
            unselectedLabelStyle: dynamicStyle(
              18,
              AppColors.text,
              FontWeight.normal,
              FontStyle.normal,
            ),
            indicatorColor: AppColors.primary,
            indicatorWeight: 4,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textGray,
            tabs: homeTabs,
          ),
        ),
        body: Obx(
          () {
            if (playerStateController.songAllList.isEmpty) {
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: Text(
                      'home_not_tab1'.tr,
                      style: dynamicStyle(
                        18,
                        AppColors.text,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'home_not_tab2'.tr,
                      style: dynamicStyle(
                        18,
                        AppColors.text,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'home_not_tab3'.tr,
                      style: dynamicStyle(
                        18,
                        AppColors.text,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return TabBarView(
                children: <Widget>[
                  MusicList(songs: playerStateController.songAllList),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: playerStateController.folderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var title = playerStateController.folderList[index];
                      var songs = playerController.getSongsFromFolder(title);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: AppColors.surface,
                          title: Text(
                            title,
                            style: titleStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            songs.length.toString(),
                            style: subtitleStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Icon(
                            Icons.folder,
                            color: AppColors.text,
                            size: 32,
                          ),
                          onTap: () {
                            Get.toNamed(AppRoutes.playlist, arguments: {
                              'title': title,
                              'songs': songs,
                            });
                          },
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Text(
                      'home_not_tab3'.tr,
                      style: dynamicStyle(
                        18,
                        AppColors.text,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Obx(
          () => playerStateController.songAllList.isEmpty
              ? const SizedBox.shrink()
              : const Shortcut(),
        ),
      ),
    );
  }
}
