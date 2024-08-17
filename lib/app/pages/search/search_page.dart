import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../shared/widgets/music_list.dart';
import '../../core/app_colors.dart';
import '../../core/controllers/player.dart';
import '../../shared/widgets/shortcut.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  late FocusNode _focusNode;
  late TextEditingController _textController;
  late List<SongModel> filteredSongs;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    filteredSongs = [];
    _textController.addListener(_filterSongs);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playerStateController.resetSongIndex();
      playerController.resetPlaylist();
    });
    super.dispose();
  }

  void _filterSongs() async {
    var query = _textController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredSongs = [];
      } else {
        filteredSongs = playerStateController.songAllList.where((song) {
          return song.title.toLowerCase().contains(query) ||
              song.artist!.toLowerCase().contains(query);
        }).toList();
      }
    });

    await playerController.songLoad(filteredSongs);
  }

  void _hideKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          style: dynamicStyle(
            18,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          cursorColor: AppColors.text,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.text),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: MusicList(songs: filteredSongs),
        ),
      ),
      bottomNavigationBar: Obx(
        () => playerStateController.songAllList.isEmpty
            ? const SizedBox.shrink()
            : const Shortcut(),
      ),
    );
  }
}
