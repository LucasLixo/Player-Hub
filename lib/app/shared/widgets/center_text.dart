import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String title;

  const CenterText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
