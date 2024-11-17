import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistTitle;
  final List<SongModel> playlistList;
  final SelectionTypes playlistType;

  const PlaylistPage({
    super.key,
    required this.playlistTitle,
    required this.playlistList,
    required this.playlistType,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PlayerController playerController = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerController.isListRecent.value = true;
    }
  }

  @override
  void dispose() {
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerController.isListRecent.value = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          widget.playlistTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: musicList(
            songs: widget.playlistList,
            selectiontype: widget.playlistType,
            selectionTitle: widget.playlistTitle,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => playerController.songList.isEmpty
            ? const Space(size: 0)
            : const Shortcut(),
      ),
    );
  }
}
