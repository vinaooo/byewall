import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/scheduler.dart';

var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
bool isLightMode = brightness == Brightness.light;

const _brandBlue = Color(0xFF1E88E5);

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String provider = 'https://12ft.io/';
  int? _value = 0;
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        lightColorScheme = lightDynamic.harmonized();
        // (Optional) Customize the scheme as desired. For example, one might
        // want to use a brand color to override the dynamic [ColorScheme.secondary].
        lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
        // (Optional) If applicable, harmonize custom colors.

        // Repeat for the dark color scheme.
        darkColorScheme = darkDynamic.harmonized();
        darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);

        //_isDemoUsingDynamicColors = true; // ignore, only for demo purposes
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.dark,
        );
      }

      return MaterialApp(
        themeMode: themeMode,
        theme: ThemeData(
          colorScheme: lightDynamic ??
              Theme.of(context)
                  .colorScheme
                  .copyWith(brightness: Brightness.light),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ??
              Theme.of(context)
                  .colorScheme
                  .copyWith(brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('ByeWall'),
            centerTitle: true,
          ),
          bottomNavigationBar: const BottomAppBar(
            height: 100,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text('Services:',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Row(
                        children: [
                          Wrap(
                            spacing: 5.0,
                            children: List<Widget>.generate(
                              3,
                              (int index) {
                                String label = '';
                                switch (index) {
                                  case 0:
                                    label = '12ft.io';
                                    break;
                                  case 1:
                                    label = 'archive.is';
                                    break;
                                  case 2:
                                    label = 'E outro';
                                    break;
                                }
                                return ChoiceChip(
                                  padding: const EdgeInsets.all(0.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  label: Text(label),
                                  selected: _value == index,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _value = selected ? index : null;
                                      if (selected) {
                                        // execute ação com base na opção selecionada
                                        if (_value == 0) {
                                          provider = 'https://12ft.io/';
                                          print('Item 0 selecionado!');
                                        } else if (_value == 1) {
                                          provider =
                                              'http://archive.is/newest/';
                                          print('Item 1 selecionado!');
                                        } else if (_value == 2) {
                                          provider = 'http://453412348.com/';
                                          print('Item 2 selecionado!');
                                        }
                                      }
                                    });
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.article_outlined,
                              size: 26,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                            filled: true,
                            isDense: true,
                            hintText: 'Paste your \'Boring\' URL here...',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          onSubmitted: (value) =>
                              _launchURL(context, value, provider),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                              onPressed: null,
                              child: Row(
                                children: [
                                  Icon(Icons.link),
                                  SizedBox(width: 10),
                                  Text('Shorten URL'),
                                ],
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: isLightMode ? 0 : 1,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('History:',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
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
      debugPrint(e.toString());
    }
  }
}
