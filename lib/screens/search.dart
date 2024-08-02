import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/controllers/player_export.dart';
import 'package:player/screens/details.dart';
import 'package:player/utils/text_style.dart';
import 'package:player/widgets/shortcut.dart';
import 'package:player/utils/colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late FocusNode _focusNode;
  late TextEditingController _textController;
  late List<SongModel> filteredSongs;
  bool _isDisposed = false;

  final playerStateController = Get.find<PlayerStateController>();

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
    playerStateController.songList = playerStateController.songAllList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playerStateController.resetSongIndex();
    });
    playerStateController.resetSongIndex();
    super.dispose();
  }

  void _filterSongs() {
    var query = _textController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredSongs = [];
      } else {
        filteredSongs = playerStateController.songAllList.where((song) {
          return song.title.toLowerCase().contains(query) ||
              song.artist!.toLowerCase().contains(query);
        }).toList();
        playerStateController.songList = filteredSongs;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();

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
            size: 32,
          ),
        ),
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          style: textStyle(),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredSongs.length,
              itemBuilder: (BuildContext context, int index) {
                var song = filteredSongs[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.transparent,
                    title: Text(
                      song.title.trim(),
                      style: textStyle(fontFamily: bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.artist!.trim(),
                      style: textStyle(fontFamily: regular, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: colorWhite,
                        size: 32,
                      ),
                    ),
                    onTap: () {
                      playerController.playSong(index);
                      Get.to(
                        () => const Details(),
                        transition: Transition.downToUp,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Shortcut(),
          ),
        ],
      ),
    );
  }
}
