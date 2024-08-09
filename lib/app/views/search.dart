import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../shared/utils/dynamic_style.dart';
import '../shared/widgets/music_list.dart';
import '../core/app_colors.dart';
import '../core/player/player_export.dart';
import '../shared/widgets/shortcut.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late FocusNode _focusNode;
  late TextEditingController _textController;
  late List<SongModel> filteredSongs;

  bool _isDisposed = false;

  final playerStateController = Get.find<PlayerStateController>();
  final playerController = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _focusNode.requestFocus();
      }
    });

    filteredSongs = [];
    _textController.addListener(_filterSongs);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _focusNode.dispose();
    _textController.dispose();
    // playerStateController.songList = playerStateController.songAllList;
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
      backgroundColor: colorBackgroundDark,
      appBar: AppBar(
        backgroundColor: colorBackgroundDark,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const Icon(
            Icons.arrow_back_ios,
            color: colorWhite,
            size: 26,
          ),
        ),
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          style: dynamicStyle(
            18,
            colorWhite,
            FontWeight.normal,
            FontStyle.normal,
          ),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: MusicList(songs: filteredSongs),
              ),
            ),
            const Shortcut(),
          ],
        ),
      ),
    );
  }
}
