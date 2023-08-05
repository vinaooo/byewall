import 'dart:io';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double topValue;
  final double bottomValue;
  final VoidCallback? onTap;

  const CustomCard({
    required this.topValue,
    required this.bottomValue,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Platform.isLinux ? AdwaitaColorsV.light3 : null,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topValue),
          topRight: Radius.circular(topValue),
          bottomLeft: Radius.circular(bottomValue),
          bottomRight: Radius.circular(bottomValue),
        ),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topValue),
            topRight: Radius.circular(topValue),
            bottomLeft: Radius.circular(bottomValue),
            bottomRight: Radius.circular(bottomValue),
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Icon(Icons.favorite_border_outlined),
        ),
        onTap: onTap,
        title: const Text(
          maxLines: 1,
          'Support the development',
        ),
      ),
    );
  }
}

class AdwaitaColorsV {
  static const Color light3 = Color(0xFFEDEDED);
}
