import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

void crudSheet(BuildContext context, SongModel song) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                song.title,
                style: titleStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            // ListTile(
            //   tileColor: Colors.transparent,
            //   splashColor: Colors.transparent,
            //   focusColor: Colors.transparent,
            //   title: Text(
            //     'crud_sheet1'.tr,
            //     style: dynamicStyle(
            //       18,
            //       AppColors.text,
            //       FontWeight.normal,
            //       FontStyle.normal,
            //     ),
            //   ),
            //   trailing: Icon(
            //     Icons.playlist_add,
            //     color: AppColors.text,
            //     size: 28,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     _showDialogPlaylist(context, song);
            //   },
            // ),
            ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(
                'crud_sheet3'.tr,
                style: subtitleStyle(),
              ),
              trailing: Icon(
                Icons.edit,
                color: AppColors.text,
                size: 28,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.edit, arguments: {
                  'song': song,
                });
              },
            ),
            // ListTile(
            //   tileColor: Colors.transparent,
            //   splashColor: Colors.transparent,
            //   focusColor: Colors.transparent,
            //   title: Text(
            //     'crud_sheet2'.tr,
            //     style: dynamicStyle(
            //       18,
            //       AppColors.text,
            //       FontWeight.normal,
            //       FontStyle.normal,
            //     ),
            //   ),
            //   trailing: Icon(
            //     Icons.delete,
            //     color: AppColors.text,
            //     size: 28,
            //   ),
            //   onTap: () async {
            //     final file = File(song.data);
            //     if (await file.exists()) {
            //       await file.delete();
            //     }
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        ),
      );
    },
  );
}

// TextEditingController _textController = TextEditingController();
// Future<String?> _showDialogPlaylist(
//     BuildContext context, SongModel song) async {
//   return showDialog<String>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) => Dialog(
//       backgroundColor: AppColors.surface,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             TextField(
//               controller: _textController,
//               focusNode: FocusNode(),
//               style: dynamicStyle(
//                 18,
//                 AppColors.text,
//                 FontWeight.normal,
//                 FontStyle.normal,
//               ),
//               cursorColor: AppColors.text,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.text),
//                 ),
//                 labelText: 'crud_sheet_dialog_3'.tr,
//                 labelStyle: subtitleStyle(),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Obx(() => AppPlaylist.playlistLocal.isEmpty
//                 ? const SizedBox.shrink()
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: AppPlaylist.playlistLocal.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final playlist = AppPlaylist.playlistLocal[index];
// 
//                       return ListTile(
//                         tileColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                         focusColor: Colors.transparent,
//                         title: Text(
//                           playlist.title,
//                           style: titleStyle(),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         onTap: () {
//                           AppPlaylist.addSongsToPlaylist(playlist.title, [song]);
//                           Navigator.of(context).pop();
//                         },
//                       );
//                     },
//                   )),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'crud_sheet_dialog_1'.tr,
//                     style: dynamicStyle(
//                       16,
//                       AppColors.primary,
//                       FontWeight.w600,
//                       FontStyle.normal,
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     String titlePlaylist = _textController.text.trim();
//                     if (titlePlaylist.isNotEmpty) {
//                       AppPlaylist.addPlaylist(
//                         Playlist(title: _textController.text, songs: [song]),
//                       );
//                       _textController.text = '';
//                     }
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'crud_sheet_dialog_2'.tr,
//                     style: dynamicStyle(
//                       16,
//                       AppColors.primary,
//                       FontWeight.w600,
//                       FontStyle.normal,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
