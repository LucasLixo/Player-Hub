import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/types/app_manifest.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:share_plus/share_plus.dart';

mixin AppWidgets {
  // ==================================================
  Widget musicList({
    required List<SongModel> songs,
    ListTile? first,
  }) {
    final PlayerController controller = Get.find<PlayerController>();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: songs.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return first ?? const SizedBox.shrink();
        }

        final int myIndex = index - 1;
        final SongModel song = songs[myIndex];

        return ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
          title: Text(
            AppShared.getTitle(
              song.id,
              song.title,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            AppShared.getArtist(song.id, song.artist!),
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: FutureBuilder<Uint8List>(
            future: AppManifest.getImageArray(id: song.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError ||
                  !snapshot.hasData) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              }
            },
          ),
          trailing: InkWell(
            onTap: () async {
              await crudMusic(
                song: song,
              );
            },
            child: Icon(
              Icons.more_vert,
              color: AppColors.current().text,
            ),
          ),
          onTap: () async {
            if (controller.songList != songs) {
              await controller.songLoad(songs, myIndex);
            } else {
              await controller.playSong(myIndex);
            }
            await Get.toNamed(AppRoutes.details);
          },
        );
      },
    );
  }

  // ==================================================
  Widget folderList() {
    final PlayerController controller = Get.find<PlayerController>();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: controller.folderList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'home_tab5'.tr,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        final int myIndex = index - 1;
        final String title = controller.folderList[myIndex];
        final List<SongModel>? songs = controller.folderListSongs[title];

        return ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            songs!.length.toString(),
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: FutureBuilder<Uint8List>(
            future: AppManifest.getImageArray(id: songs[0].id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError ||
                  !snapshot.hasData) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              }
            },
          ),
          trailing: Obx(() {
            List<String> listFolderIgnore =
                AppShared.getShared(SharedAttributes.ignoreFolder)
                    as List<String>;

            final RxBool isIgnored = listFolderIgnore.contains(title).obs;

            return InkWell(
              child: Icon(
                isIgnored.value ? Icons.visibility_off : Icons.visibility,
                color: AppColors.current().text,
                size: 32,
              ),
              onTap: () async {
                if (isIgnored.value) {
                  listFolderIgnore.remove(title);
                } else {
                  listFolderIgnore.add(title);
                }
                await AppShared.setShared(
                  SharedAttributes.ignoreFolder,
                  listFolderIgnore,
                );
                await controller.songAllLoad(controller.songAllList);
                controller.songList.clear();
                controller.songList.addAll(controller.songAllList);
              },
            );
          }),
          onTap: () async {
            await Get.toNamed(AppRoutes.playlist, arguments: {
              'playlistTitle': title,
              'playlistList': songs,
            });
          },
        );
      },
    );
  }

  // ==================================================
  Future<void> crudMusic({
    required SongModel song,
  }) async {
    Future<void> sharedFiles() async {
      final ShareResult result = await Share.shareXFiles(
        [XFile(song.data, name: song.displayNameWOExt)],
        text: AppShared.getTitle(song.id, song.title),
      );

      if (result.status == ShareResultStatus.success) {}
    }

    await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: AppColors.current().background,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Space(
                size: 12,
                orientation: Axis.vertical,
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Text(
                  song.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Space(
                size: 12,
                orientation: Axis.vertical,
              ),
              ListTile(
                tileColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                title: Text(
                  'crud_sheet3'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Icon(
                  Icons.edit,
                  color: AppColors.current().text,
                  size: 28,
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await Get.toNamed(AppRoutes.edit, arguments: {
                    'song': song,
                  });
                },
              ),
              ListTile(
                tileColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                title: Text(
                  'crud_sheet4'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Icon(
                  Icons.share,
                  color: AppColors.current().text,
                  size: 28,
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await sharedFiles();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================
  Future<void> crudPlaylist({
    required String folder,
  }) async {
    await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: AppColors.current().background,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Space(
                size: 12,
                orientation: Axis.vertical,
              ),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Text(
                  folder,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Space(
                size: 12,
                orientation: Axis.vertical,
              ),
              const ListTile(
                tileColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================
  Widget albumList({
    required List<AlbumModel> albumList,
    required Map<String, List<SongModel>> albumSongs,
    required bool isAlbumArtist,
  }) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: albumSongs.length,
      itemBuilder: (BuildContext context, int index) {
        final artist = albumList[index].artist! == '<unknown>' ? '' : '';
        final title = isAlbumArtist
            ? (artist.isNotEmpty ? artist : albumList[index].album)
            : albumList[index].album;
        final songs = albumSongs[albumList[index].album];

        return ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          minVerticalPadding: 4.0,
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            songs!.length.toString(),
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: FutureBuilder<Uint8List>(
            future: AppManifest.getImageArray(
              id: songs[0].id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              }
            },
          ),
          onTap: () async {
            await Get.toNamed(AppRoutes.playlist, arguments: {
              'playlistTitle': title,
              'playlistList': songs,
            });
          },
        );
      },
    );
  }

  // ==================================================
  Widget playlistMode() {
    final PlayerController controller = Get.find<PlayerController>();

    return InkWell(
      onTap: () async {
        await controller.togglePlaylist();
      },
      child: Obx(() {
        IconData icon;
        switch (AppShared.getShared(SharedAttributes.playlistMode)) {
          case 0:
            icon = Icons.shuffle;
            break;
          case 1:
            icon = Icons.repeat;
            break;
          case 2:
            icon = Icons.repeat_one;
            break;
          default:
            icon = Icons.error;
        }

        return Icon(
          icon,
          size: 30,
          color: Colors.white,
        );
      }),
    );
  }

  // ==================================================
  Widget playlistSheet() {
    final PlayerController controller = Get.find<PlayerController>();

    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          context: Get.context!,
          backgroundColor: AppColors.current().background,
          builder: (BuildContext context) {
            return Obx(() {
              final songList = controller.songList;
              final songIndex = controller.songIndex.value;

              if (songList.isEmpty) {
                return const Space(size: 0);
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: songList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final song = songList[index];

                    return ListTile(
                      tileColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      contentPadding:
                          const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 2.0),
                      title: Text(
                        AppShared.getTitle(song.id, song.title),
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        AppShared.getArtist(song.id, song.artist!),
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: songIndex == index
                          ? Icon(
                              Icons.music_note,
                              color: AppColors.current().text,
                              size: 32,
                            )
                          : const Space(size: 0),
                      leading: FutureBuilder<Uint8List>(
                        future: AppManifest.getImageArray(
                          id: song.id,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              width: 50.0,
                              height: 50.0,
                            );
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const SizedBox(
                              width: 50.0,
                              height: 50.0,
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: 50.0,
                                height: 50.0,
                              ),
                            );
                          }
                        },
                      ),
                      onTap: () async {
                        await controller.playSong(index);
                      },
                    );
                  },
                ),
              );
            });
          },
        );
      },
      child: const Icon(
        Icons.queue_music,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
