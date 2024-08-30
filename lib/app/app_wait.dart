import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppWait extends StatelessWidget {
  const AppWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: Center(
        child: Text(
          AppShared.title,
          style: dynamicStyle(
            32,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
