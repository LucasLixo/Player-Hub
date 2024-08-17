import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app/core/controllers/song_api.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/app_colors.dart';

class CloudPage extends StatefulWidget {
  final int songId;
  final String songTitle;

  const CloudPage({
    super.key,
    required this.songId,
    required this.songTitle,
  });

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  final apiController = Get.find<ApiController>();

  late FocusNode _focusNode;
  late TextEditingController _textController;

  late List<ModelSongApi>? metadataResults;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController(text: widget.songTitle);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();

    super.dispose();
  }

  Future<void> fetchSongData() async {
    metadataResults = await apiController.searchSong(_textController.text);
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
        actions: [
          InkWell(
            onTap: () async {
              await fetchSongData();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.refresh,
              color: AppColors.text,
              size: 32,
            ),
          ),
        ],
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.songId.toString(),
              style: titleStyle(),
            ),
            Text(
              widget.songTitle,
              style: titleStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
