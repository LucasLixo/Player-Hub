import 'package:flutter/material.dart';
import 'package:player/app/shared/utils/subtitle_style.dart';
import 'package:player/app/shared/utils/title_style.dart';

import '../../../app/core/app_colors.dart';

class CardApi extends StatelessWidget {
  final String title;
  final String artist;
  final String art;

  const CardApi({
    super.key,
    required this.title,
    required this.artist,
    required this.art,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 110,
        height: 110,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      art,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                color: AppColors.background.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artist,
                      style: subtitleStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
