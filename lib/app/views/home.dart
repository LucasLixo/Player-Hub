import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './inc/list_music.dart';
import './inc/list_folder.dart';
import '../routes/app_routes.dart';
import '../shared/utils/dynamic_style.dart';
import '../core/app_colors.dart';
import '../shared/widgets/shortcut.dart';
import '../core/player/player_export.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final playerController = Get.put(PlayerController());
  final playerStateController = Get.put(PlayerStateController());

  @override
  void initState() {
    super.initState();
    playerController.getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: colorBackgroundDark,
        appBar: AppBar(
          backgroundColor: colorBackgroundDark,
          leading: null,
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.search);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(
                Icons.search,
                color: colorWhite,
                size: 32,
              ),
            ),
          ],
          title: Text(
            'Player Hub',
            style: dynamicStyle(
              20,
              colorWhite,
              FontWeight.normal,
              FontStyle.normal,
            ),
          ),
          bottom: TabBar(
            labelStyle: dynamicStyle(
              18,
              colorWhite,
              FontWeight.normal,
              FontStyle.normal,
            ),
            unselectedLabelStyle: dynamicStyle(
              18,
              colorWhite,
              FontWeight.normal,
              FontStyle.normal,
            ),
            indicatorColor: colorSlider,
            indicatorWeight: 4,
            labelColor: colorSlider,
            unselectedLabelColor: colorWhiteGray,
            tabs: const <Widget>[
              Tab(
                text: 'Musicas',
              ),
              Tab(
                text: 'Pastas',
              ),
            ],
          ),
        ),
        body: Obx(
          () {
            if (playerStateController.songAllList.isEmpty) {
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Sem Músicas',
                      style: dynamicStyle(
                        18,
                        colorWhite,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Sem Pastas',
                      style: dynamicStyle(
                        18,
                        colorWhite,
                        FontWeight.normal,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const TabBarView(
                children: <Widget>[ListMusicView(), ListFolderView()],
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
