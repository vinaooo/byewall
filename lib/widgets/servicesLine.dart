import 'dart:io';

import 'package:flutter/material.dart';
import '../options/settings.dart'; // Importe o arquivo que contém a tela de configurações.

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Services:',
            style: Platform.isLinux
                ? Theme.of(context)
                    .textTheme
                    .titleLarge // Usando o estilo de texto do tema atual.
                : const TextStyle(
                    fontSize: 16,
                  ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
