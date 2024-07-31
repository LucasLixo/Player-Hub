import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/components/style_text.dart';
import 'package:player/utils/const.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
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
          focusNode: _focusNode,
          style: styleText(),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: null,
          ),
        ),
      ),
      body: const Center(),
    );
  }
}
