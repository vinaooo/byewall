import 'dart:io';

import 'package:byewall/globals.dart';
import 'package:flutter/material.dart';
import '../options/settings.dart'; // Importe o arquivo que contém a tela de configurações.

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: paddingLeft8, top: paddingTop8),
      child: SizedBox(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Services:',
              style: Platform.isLinux
                  ? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      fontSize: 16,
                    ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(width: 0, color: Colors.transparent),
              ),
              child: const Icon(Icons.settings),
            )
            // IconButton(

            // onPressed: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const SettingsScreen(),
            //     ),
            //   );
            // },
            //   icon: const Icon(Icons.settings),
            // ),
          ],
        ),
      ),
    );
  }
}
