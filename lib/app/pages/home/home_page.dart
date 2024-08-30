import 'package:flutter/src/material/tabs.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/ink_well.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/shared/widgets/folder_list.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';

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
    // Tab(text: 'home_tab3'.tr),
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
            const SizedBox(
              width: 8,
            ),
          ],
          title: Text(
            AppShared.title,
            style: dynamicStyle(
              20,
              AppColors.text,
              FontWeight.normal,
              FontStyle.normal,
            ),
          ),
          bottom: TabBar(
            isScrollable: false,
            dividerColor: Colors.transparent,
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
                  CenterText(title: 'home_not_tab1'.tr),
                  CenterText(title: 'home_not_tab2'.tr),
                  // CenterText(title: 'home_not_tab3'.tr),
                ],
              );
            } else {
              return TabBarView(
                children: <Widget>[
                  MusicList(songs: playerStateController.songAllList),
                  const FolderList(),
                  // const PlaylistList(),
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
