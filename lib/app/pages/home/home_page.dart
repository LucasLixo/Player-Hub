import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/shared/widgets/folder_list.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';
import 'package:playerhub/app/shared/widgets/top_button_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playerStateController = Get.find<PlayerStateController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0.0,
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
                  Row(
                    children: [
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
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TopButtonBar(
                          image: '',
                          color: Colors.orange,
                          text: 'playlist1'.tr,
                          icon: Icons.bookmark_sharp,
                          onTap: () {
                            Get.toNamed(AppRoutes.album, arguments: {
                              'type': 0,
                              'title': 'playlist1'.tr,
                              'album': playerStateController.albumList,
                              'noTitle': 'playlist_not1'.tr,
                            });
                          },
                        ),
                        TopButtonBar(
                          image: '',
                          color: Colors.blue,
                          text: 'playlist2'.tr,
                          icon: Icons.person_sharp,
                          onTap: () {
                            Get.toNamed(AppRoutes.album, arguments: {
                              'type': 1,
                              'title': 'playlist2'.tr,
                              'album': playerStateController.artistList,
                              'noTitle': 'playlist_not2'.tr,
                            });
                          },
                        ),
                        TopButtonBar(
                          image: '',
                          color: Colors.green,
                          text: 'playlist3'.tr,
                          icon: Icons.schedule,
                          onTap: () {
                            Get.toNamed(AppRoutes.playlist, arguments: {
                              'title': 'playlist3'.tr,
                              'songs': playerStateController.recentList,
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  labelStyle: dynamicStyle(
                    fontSize: 18,
                    fontColor: AppColors.text,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                  unselectedLabelStyle: dynamicStyle(
                    fontSize: 18,
                    fontColor: AppColors.text,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 4,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textGray,
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  tabs: <Tab>[
                    Tab(text: 'home_tab1'.tr),
                    Tab(text: 'home_tab2'.tr),
                  ],
                ),
              ),
            ];
          },
          body: Obx(
            () {
              if (playerStateController.songAllList.isEmpty) {
                return TabBarView(
                  children: <Widget>[
                    CenterText(title: 'home_not_tab1'.tr),
                    CenterText(title: 'home_not_tab2'.tr),
                  ],
                );
              } else {
                return TabBarView(
                  children: <Widget>[
                    MusicList(songs: playerStateController.songAllList),
                    const FolderList(),
                  ],
                );
              }
            },
          ),
        ),
        bottomNavigationBar: Obx(
          () => playerStateController.songAllList.isEmpty
              ? const SizedBox.shrink()
              : const SafeArea(child: Shortcut()),
        ),
      ),
    );
  }
}
