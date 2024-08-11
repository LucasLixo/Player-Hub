import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/widgets/shortcut.dart';
import '../../core/player/player_export.dart';
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
            constAppTitle,
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
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: ListTile(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: colorBackground,
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
                          leading: const Icon(
                            Icons.folder,
                            color: colorWhite,
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
