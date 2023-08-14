import 'package:flutter/material.dart';

import '../globals.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  // final FocusNode focusNode;
  final void Function(String) onSubmitted;

  const CustomTextField({
    Key? key,
    required this.controller,
    // required this.focusNode,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    // if (AppStrings.sharedText.isNotEmpty) {
    //   widget.controller.text = AppStrings.sharedText;
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (AppStrings.sharedText.isNotEmpty) {
      widget.controller.text = AppStrings.sharedText;
    }
    return Padding(
      padding: const EdgeInsets.only(
          left: paddingLeft8,
          right: paddingRight8,
          top: paddingTop8,
          bottom: paddingBottom0),
      child: TextField(
        //autofocus: false,
        inputFormatters: const [],
        controller: widget.controller,
        maxLines: 1,
        //focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
              left: paddingLeft20,
              top: paddingTop8,
              right: paddingRight20,
              bottom: paddingBottom8),
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSubmitted(widget.controller.text);
            },
            icon: const Icon(
              Icons.arrow_forward,
            ),
          ),
          filled: true,
          isDense: true,
          hintText: 'Paste your \'Boring\' URL here...',
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
