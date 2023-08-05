import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:adwaita/adwaita.dart';

import 'widgets/servicesLine.dart';
import 'options/donations.dart';
import 'functions.dart';
import 'widgets/text.dart';
import 'widgets/supportCard.dart';
import 'widgets/choicechips.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.themeNotifier}) : super(key: key);

  final ValueNotifier<ThemeMode> themeNotifier;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> history = [];
  Map<String, String> tittles = {};
  final TextEditingController urlController = TextEditingController();
  //final focusNode = FocusNode();
  int valor = 0;
  String? previousText = '';

  void addHistory(String texto) {
    setState(() {
      history.insert(0, texto);
    });
  }

  void _removeHistorico(int index) {
    setState(() {
      history.removeAt(index);
    });
  }

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
    urlController.addListener(
        () => onUrlChange(urlController, previousText /*, focusNode*/));
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
            ),
      // bottomNavigationBar: BottomAppBar(
      //   height: 120,
      //   child: Platform.isLinux || Platform.isMacOS || Platform.isWindows
      //       ? const Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             SizedBox(
      //               width: 400,
      //               child: Padding(
      //                 padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      //                 child: Text(
      //                     'Support indie devs, prioritize info access over big corps. Help me fund Xbox Gamepass for my kids :-P. \nThanks!',
      //                     style: TextStyle()),
      //               ),
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 ElevatedButton(onPressed: null, child: Text('Donate')),
      //               ],
      //             ),
      //           ],
      //         )
      //       : const Text(''),
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Services(),
                const SizedBox(
                  height: 20,
                ),
                ChoicesChips(),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: urlController,
                      // focusNode: focusNode,
                      onSubmitted: (value) {
                        _handleUrlSubmission(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Column(
                      children: [
                        CustomCard(
                          topValue: 10,
                          bottomValue: history.isEmpty ? 10 : 0,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DonationsScreen()),
                            );
                          },
                        ),
                        Card(
                          margin: EdgeInsets.zero,
                          color: Platform.isLinux ? AdwaitaColors.light3 : null,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: history.isNotEmpty
                                ? const Radius.circular(10)
                                : Radius.zero,
                            bottomRight: history.isNotEmpty
                                ? const Radius.circular(10)
                                : Radius.zero,
                          )

                              // BorderRadius.circular(8),
                              ),
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: history.length,
                                // _historico.length > 10
                                //     ? 10
                                //     : _historico.length,
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    key: ValueKey(history[index]),
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.zero,
                                      topRight: Radius.zero,
                                      bottomLeft: index == history.length - 1
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                      bottomRight: index == history.length - 1
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                    )),
                                    title: FutureBuilder(
                                      future: getTitle(history[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            // snapshot.data!.length > 50
                                            //     ? '${snapshot.data!.substring(0, 40)}...'
                                            //     :
                                            snapshot.data!,
                                            // style: const TextStyle(
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                            maxLines: 1,
                                          );
                                        } else {
                                          return const Text(
                                            'Carregando...',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    onTap: () {
                                      _launchURL(
                                        context,
                                        history[index],
                                        provider,
                                      );
                                    },
                                    trailing: Platform.isLinux
                                        ? IconButton(
                                            onPressed: () {},
                                            icon: const AdwaitaIcon(
                                                AdwaitaIcons.copy),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              Share.share(
                                                  '$provider${history[index]}');
                                            },
                                            icon: const Icon(Icons.share),
                                          ),
                                    leading: IconButton(
                                      icon: Platform.isLinux
                                          ? const AdwaitaIcon(
                                              AdwaitaIcons.edit_delete)
                                          : const Icon(
                                              Icons.delete_forever_outlined),
                                      onPressed: () {
                                        _removeHistorico(index);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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
    _launchURL(context, value, provider);
    addHistory(value);
  }

  Future<void> _launchURL(
      BuildContext context, String value, String provider) async {
    final theme = Theme.of(context);
    String freeUrl = "$provider$value";
    try {
      await launch(
        freeUrl,
        customTabsOption: CustomTabsOption(
          // toolbarColor: theme.primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: theme.primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      final uri = Uri.parse(freeUrl);
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
      } else {
        throw 'Could not launch $freeUrl';
      }
      debugPrint(e.toString());
    }
  }
}
