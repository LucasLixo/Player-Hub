import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/pages/selection/selection_controller.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/shared/widgets/crud_add_playlist.dart';

class SelectionPage extends StatefulWidget {
  final SelectionTypes selectionType;
  final String? selectionTitle;
  final int selectionIndex;
  final List<SongModel> selectionList;

  const SelectionPage({
    super.key,
    required this.selectionType,
    required this.selectionTitle,
    required this.selectionIndex,
    required this.selectionList,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  late SelectionController controller;
  late PlayerController playerController;

  @override
  void initState() {
    super.initState();
    // Inicializando os controladores
    controller = Get.find<SelectionController>();
    playerController = Get.find<PlayerController>();

    controller.selectedItems.clear();
    controller.selectionList.clear();

    // Atualizando o estado inicial
    controller.selectionList.value = widget.selectionList;
    controller.toggleItemSelection(widget.selectionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().surface,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.current().surface,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
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
            return Text(
              controller.selectedItems.length.toString(),
              style: Theme.of(context).textTheme.headlineLarge,
            );
          }),
          const Space(size: 24),
        ],
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: widget.selectionList.length,
        itemBuilder: (BuildContext context, int index) {
          final SongModel song = widget.selectionList[index];

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
              controller.toggleItemSelection(index);
            },
            trailing: Obx(() {
              final bool isSelected = controller.isSelected(index);

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
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(() {
          return Container(
            color: controller.selectedItems.isNotEmpty
                ? AppColors.current().primary
                : AppColors.current().surface,
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: Text(
                widget.selectionType == SelectionTypes.add
                    ? 'crud_sheet1'.tr
                    : 'crud_sheet8'.tr,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              leading: Icon(
                widget.selectionType == SelectionTypes.add
                    ? Icons.add
                    : Icons.remove,
                color: AppColors.current().text,
                size: 42,
              ),
              onTap: () async {
                if (widget.selectionType == SelectionTypes.add) {
                  await crudAddPlaylist(songs: controller.getSelectedSongs());
                  Get.back();
                }
                if (widget.selectionType == SelectionTypes.remove &&
                    widget.selectionTitle != null) {
                  playerController.removeSongsPlaylist(
                    widget.selectionTitle!,
                    controller.getSelectedSongs(),
                  );
                  Get.back();
                }
                await Get.toNamed(AppRoutes.splash, arguments: {
                  'function': () async {
                    await Future.delayed(const Duration(seconds: 1));
                  },
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
