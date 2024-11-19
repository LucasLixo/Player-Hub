import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/pages/selection/selection_controller.dart';
import 'package:player_hub/app/routes/app_routes.dart';

class SelectionRemovePage extends StatefulWidget {
  final String selectionTitle;
  final int selectionIndex;

  const SelectionRemovePage({
    super.key,
    required this.selectionTitle,
    required this.selectionIndex,
  });

  @override
  State<SelectionRemovePage> createState() => _SelectionRemovePageState();
}

class _SelectionRemovePageState extends State<SelectionRemovePage> {
  late SelectionController selectionController;
  late PlayerController playerController;

  @override
  void initState() {
    super.initState();
    // Inicializando os controladores
    selectionController = Get.find<SelectionController>();
    playerController = Get.find<PlayerController>();

    selectionController.selectedItems.clear();

    selectionController.toggleItemSelection(widget.selectionIndex);
  }

  @override
  Widget build(BuildContext context) {
    final RxList<SongModel> currentList =
        playerController.playlistListSongs[widget.selectionTitle]!.obs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        await Get.offAllNamed(AppRoutes.home);
      },
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
              await Get.offAllNamed(AppRoutes.home);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.current().text,
              size: 32,
            ),
          ),
          title: Text(
            AppShared.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: <Widget>[
            Obx(() {
              return InkWell(
                onTap: () {
                  if (selectionController.selectedItems.length ==
                      currentList.length) {
                    selectionController.selectedItems.clear();
                  } else {
                    selectionController.selectedItems.clear();
                    selectionController.selectedItems.addAll(
                      List<int>.generate(
                        currentList.length,
                        (index) => index,
                      ),
                    );
                  }
                },
                child: Icon(
                  selectionController.selectedItems.length == currentList.length
                      ? Icons.clear_all_outlined
                      : Icons.done_all_outlined,
                  size: 32,
                  color: AppColors.current().text,
                ),
              );
            }),
            const Space(),
          ],
        ),
        body: Obx(() {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: currentList.length,
            itemBuilder: (BuildContext context, int index) {
              final SongModel song = currentList[index];

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
                leading: Text(
                  (index + 1).toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  selectionController.toggleItemSelection(index);
                },
                trailing: Obx(() {
                  final bool isSelected = selectionController.isSelected(index);

                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.current().primary
                          : AppColors.current().surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.current().textGray,
                        width: 1,
                      ),
                    ),
                  );
                }),
              );
            },
          );
        }),
        bottomNavigationBar: SafeArea(
          child: Obx(() {
            if (selectionController.selectedItems.isNotEmpty) {
              return Container(
                color: AppColors.current().surface,
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  title: Text(
                    'crud_sheet8'.tr,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  leading: Icon(
                    Icons.remove,
                    color: AppColors.current().text,
                    size: 42,
                  ),
                  onTap: () async {
                    final List<SongModel> selectedSongs =
                        selectionController.getSelectedSongs(currentList);

                    playerController.removeSongsPlaylist(
                      widget.selectionTitle,
                      selectedSongs,
                    );

                    currentList.removeWhere(
                      (song1) =>
                          selectedSongs.any((song2) => song1.id == song2.id),
                    );

                    selectionController.selectedItems.clear();
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}
