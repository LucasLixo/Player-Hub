import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';

class CenterText extends StatelessWidget {
  final String title;

  const CenterText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: dynamicStyle(
          18,
          AppColors.text,
          FontWeight.normal,
          FontStyle.normal,
        ),
      ),
    );
  }
}
