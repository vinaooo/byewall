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
// sdfsdf
// import 'nojava.dart';
import 'package:adwaita/adwaita.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.themeNotifier}) : super(key: key);

  final ValueNotifier<ThemeMode> themeNotifier;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String provider = 'https://12ft.io/';
  int? _value = 0;
  List<String> history = [];
  Map<String, String> tittles = {};
  final TextEditingController urlController = TextEditingController();
  final focusNode = FocusNode();
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
    urlController.addListener(onUrlChange);
  }

  @override
  void dispose() {
    urlController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onUrlChange() {
    final text = urlController.text;
    final isPasted = text.length - previousText!.length > 1;
    if (isPasted) {
      focusNode.requestFocus();
      urlController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 0),
      );
    }
    previousText = text;
  }

  // void _pushPageNoJava(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const PageNoJava()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isLinux
          ? null
          : AppBar(
              title: const Text('ByeWall'),
              centerTitle: true,
            ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Platform.isLinux
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 400,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                          'Support indie devs, prioritize info access over big corps. Help me fund Xbox Gamepass for my kids :-P. \nThanks!',
                          style: TextStyle()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: null, child: Text('Donate')),
                    ],
                  ),
                ],
              )
            : const Text(''),
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Services:',
                        style: Platform.isLinux
                            ? Theme.of(context).textTheme.headlineMedium
                            : const TextStyle(
                                fontSize: 16,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Wrap(
                              spacing: 5.0,
                              children: List<Widget>.generate(
                                4,
                                // 5,
                                (int index) {
                                  String label = '';
                                  switch (index) {
                                    case 0:
                                      label = '12ft.io';
                                      break;
                                    case 1:
                                      label = 'Archive.is';
                                      break;
                                    case 2:
                                      label = 'RemovePaywall.com';
                                      break;
                                    case 3:
                                      label = 'LeiaIsso.net';
                                      break;
                                    // case 4:
                                    //   label = 'noJS';
                                    //   break;
                                  }
                                  return ChoiceChip(
                                    padding: const EdgeInsets.all(0.0),
                                    shape: Platform.isLinux
                                        ? RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          )
                                        : RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                    label: Text(label),
                                    selected: _value == index,
                                    onSelected: (bool selected) {
                                      setState(
                                        () {
                                          _value = selected ? index : null;
                                          if (selected) {
                                            // execute ação com base na opção selecionada
                                            if (_value == 0) {
                                              provider = 'https://12ft.io/';
                                            } else if (_value == 1) {
                                              provider =
                                                  'http://archive.is/newest/';
                                            } else if (_value == 2) {
                                              provider =
                                                  'http://Removepaywall.com/';
                                            } else if (_value == 3) {
                                              provider =
                                                  'https://www.leiaisso.net/';
                                              // } else if (_value == 4) {
                                              //   //nojs
                                              //   valor = _value!;
                                            }
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: false,
                      controller: urlController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        prefixIconConstraints: Platform.isLinux
                            ? const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              )
                            : null,
                        prefixIcon: Platform.isLinux
                            ? const Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: AdwaitaIcon(
                                  AdwaitaIcons.emblem_documents,
                                  color: AdwaitaColors.dark1,
                                ),
                              )
                            : Icon(
                                Icons.article_outlined,
                                color: Platform.isLinux ? Colors.grey : null,
                                size: 26,
                              ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        filled: true,
                        isDense: true,
                        hintText: 'Paste your \'Boring\' URL here...',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        // if (valor == 4) {
                        //   _pushPageNoJava(context);
                        // } else {
                        _launchURL(context, value, provider);
                        addHistory(value);
                        //urlController.clear();
                        // }
                      },
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 8),
                //       child: ElevatedButton(
                //           onPressed: () {
                //             null;
                //             // shortenUrl(urlController.text);
                //             // print(urlController.text);
                //           },
                //           child: const Row(
                //             children: [
                //               Icon(Icons.link),
                //               SizedBox(width: 10),
                //               Text('Shorten URL'),
                //             ],
                //           )),
                //     ),
                //   ],
                // ),

                const SizedBox(
                  height: 20,
                ),

                history.isEmpty
                    ? const Text('')
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                        child: Card(
                          color: Platform.isLinux ? AdwaitaColors.light3 : null,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                    title: FutureBuilder(
                                      future: getTitle(history[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data!.length > 50
                                                ? '${snapshot.data!.substring(0, 40)}...'
                                                : snapshot.data!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
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
                      ),
              ],
            ),
          ),
        ],
      ),
    );
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
