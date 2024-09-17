import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';

class TopButtonBar extends StatelessWidget {
  final String image;
  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const TopButtonBar({
    super.key,
    required this.image,
    required this.color,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // image: DecorationImage(
          //   image: NetworkImage(image),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Icon(
                icon,
                color: AppColors.text,
                size: 18,
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Text(
                text,
                style: dynamicStyle(
                  fontSize: 12,
                  fontColor: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
