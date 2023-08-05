import 'package:flutter/material.dart';

String provider = 'https://12ft.io/';

void onUrlChange(
  TextEditingController urlController,
  String? previousText,
  //FocusNode focusNode
) {
  final text = urlController.text;
  final isPasted = text.length - previousText!.length > 1;
  if (isPasted) {
    //focusNode.requestFocus();
    urlController.selection = TextSelection.fromPosition(
      const TextPosition(offset: 0),
    );
  }
  previousText = text;
}

enum Options {
  twelveFtIo,
  archiveIs,
  removePaywallCom,
  leiaIssoNet,
}
