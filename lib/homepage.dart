import 'dart:convert';
import 'dart:io' show Platform;
import 'package:byewall/widgets/historycard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';

import 'widgets/servicesline.dart';
import 'options/donations.dart';
import 'widgets/customtext.dart';
import 'widgets/supportcard.dart';
import 'widgets/choicechips.dart';
import 'globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.themeNotifier}) : super(key: key);

  final ValueNotifier<ThemeMode> themeNotifier;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, String> tittles = {};
  final TextEditingController urlController = TextEditingController();
  //final focusNode = FocusNode();
  int valor = 0;
  String? previousText = '';

  String title = '';

  Future<String> getTitle(String url) async {
    if (tittles.containsKey(url)) {
      return tittles[url]!;
    }
    String title = '';
    try {
      if (await canLaunchUrlString(url)) {
        final response = await http.get(Uri.parse(url));
        final document = parse(utf8.decode(response.bodyBytes));
        title = document.querySelector('title')!.text;
        tittles[url] = title;
      }
    } catch (e) {
      debugPrint('Error getting title: $e');
    }
    return title;
  }

  @override
  void initState() {
    super.initState();
    // urlController.addListener(
    //     () => onUrlChange(urlController, previousText /*, focusNode*/));
  }

  @override
  void dispose() {
    urlController.dispose();
    //focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isLinux || Platform.isMacOS || Platform.isWindows
          ? null
          : AppBar(
              title: const Text('ByeWall'),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Donations'),
                      ),
                      // Adicione mais itens do menu aqui, se necessário
                    ];
                  },
                  onSelected: (value) {
                    // Lidar com a seleção do menu aqui
                    if (value == 1) {
                      // Lógica para a opção 1
                    } else if (value == 2) {
                      // Lógica para a opção 2
                    }
                  },
                ),
              ],
            ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Column(
              children: [
                Platform.isAndroid ? const Card() : const Services(),
                const ChoicesChips(),
                CustomTextField(
                  controller: urlController,
                  // focusNode: focusNode,
                  onSubmitted: (value) {
                    _handleUrlSubmission(value);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: paddingLeft8,
                          top: paddingTop0,
                          right: paddingRight8,
                          bottom: paddingBottom0),
                      child: Column(
                        children: [
                          SupportCard(
                            topValue: 10,
                            bottomValue: history.isEmpty ? 10 : 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DonationsScreen()),
                              );
                            },
                          ),
                          HistoryCard(
                            history: history,
                            provider: provider,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleUrlSubmission(String value) {
    UrlLauncherFunctions.launchURL(context, value, provider);
    setState(() {
      HistoryFunctions.addHistory(value);
    });
  }
}
