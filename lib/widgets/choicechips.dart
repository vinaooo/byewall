import 'package:byewall/globals.dart';
import 'package:flutter/material.dart';

class ChoicesChips extends StatefulWidget {
  const ChoicesChips({super.key});

  @override
  State<ChoicesChips> createState() => _ChoicesChipsState();
}

class _ChoicesChipsState extends State<ChoicesChips> {
  int _selectedIndex = 0;
  int selectedChoice = -1;

  String _getOptionLabel(int index) {
    switch (Options.values[index]) {
      case Options.twelveFtIo:
        return '12ft.io';
      case Options.archiveIs:
        return 'archive.is';
      case Options.removePaywallCom:
        return 'RemovePaywall.com';
      case Options.leiaIssoNet:
        return 'LeiaIsso.net';
    }
  }

  // bool selectedB = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: paddingLeft8,
              top: paddingTop8,
              right: paddingRight8,
              bottom: paddingBottom0),
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Options.values.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                      paddingLeft0, paddingTop0, 8, paddingBottom0),
                  child: RawChip(
                    showCheckmark: false,
                    label: Text(
                      _getOptionLabel(index),
                      style: const TextStyle(
                        height: 0.9,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    selected: selectedChoice == index,
                    selectedColor: Theme.of(context).colorScheme.surfaceVariant,

                    // backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // side: BorderSide(
                      //     color:
                      //         // selectedB
                      //         Theme.of(context).colorScheme.surfaceVariant
                      //     // : Theme.of(context).colorScheme.outline,
                      //     ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        // selectedB = selected;
                        selectedChoice = selected ? index : -1;
                        _selectedIndex = index;
                        if (_selectedIndex == 0) {
                          provider = 'https://12ft.io/';
                        } else if (_selectedIndex == 1) {
                          provider = 'http://archive.is/newest/';
                        } else if (_selectedIndex == 2) {
                          provider = 'http://Removepaywall.com/';
                        } else if (_selectedIndex == 3) {
                          provider = 'https://www.leiaisso.net/';
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
