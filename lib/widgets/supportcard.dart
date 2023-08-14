import 'package:byewall/globals.dart';
import 'package:flutter/material.dart';

class SupportCard extends StatelessWidget {
  final double topValue;
  final double bottomValue;
  final VoidCallback? onTap;

  const SupportCard({
    required this.topValue,
    required this.bottomValue,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: paddingTop8,
          bottom: paddingBottom0,
          left: paddingLeft0,
          right: paddingRight0),
      child: Card(
        margin: EdgeInsets.zero,
        //color: cardColor,
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
            padding: EdgeInsets.only(
                left: paddingLeft8,
                top: paddingTop0,
                right: paddingRight0,
                bottom: paddingBottom0),
            child: Icon(Icons.favorite_border_outlined),
          ),
          onTap: onTap,
          title: const Text(
            maxLines: 1,
            'Support the development',
          ),
        ),
      ),
    );
  }
}
