import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app/shared/utils/title_style.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../core/controllers/song_api.dart';
import '../../shared/widgets/card_api.dart';

class EditPage extends StatefulWidget {
  final int songId;
  final String songTitle;

  const EditPage({
    super.key,
    required this.songId,
    required this.songTitle,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final songApiController = Get.find<SongApiController>();

  late FocusNode _focusNode;
  late TextEditingController _textController;

  RxList<ModelSongApi> metadataResults = <ModelSongApi>[].obs;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _textController = TextEditingController(text: widget.songTitle);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> fetchSongData() async {
    metadataResults.value =
        await songApiController.searchSong(_textController.text);
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
        child: Obx(() {
          if (metadataResults.isEmpty) {
            return Center(
              child: Text(
                'cloud_error1'.tr,
                style: titleStyle(),
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: metadataResults.length,
              itemBuilder: (context, index) {
                final song = metadataResults[index];
                return CardApi(
                  title: song.title,
                  artist: song.artist,
                  art: song.art,
                );
              },
            );
          }
        }),
      ),
    );
  }
}
