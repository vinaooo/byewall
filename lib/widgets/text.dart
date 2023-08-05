import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextField(
      //autofocus: false,
      controller: controller,
      //focusNode: focusNode,
      decoration: InputDecoration(
        hintMaxLines: 1,
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        suffixIcon: IconButton(
          onPressed: () {
            onSubmitted(controller.text);
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
      onSubmitted: onSubmitted,
    );
  }
}
