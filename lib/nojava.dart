// ignore_for_file: use_build_context_synchronously, library_prefixes
//import 'package:html/parser.dart' as htmlParser;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:provider/provider.dart';

var brightness =
    SchedulerBinding.instance.platformDispatcher.platformBrightness;
bool isLightMode = brightness == Brightness.light;

class BackEventNotifier extends ChangeNotifier {
  bool _isBack = true;

  bool get isBack => _isBack;

  void add(bool value) {
    _isBack = value;
    notifyListeners();
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageNoJava(),
    );
  }
}

class PageNoJava extends StatefulWidget {
  const PageNoJava({Key? key}) : super(key: key);

  @override
  State<PageNoJava> createState() => _PageNoJavaState();
}

class _PageNoJavaState extends State<PageNoJava> {
  late final WebViewController _controller;
  String finalUrl = 'https://flutter.dev';
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(finalUrl));
    AndroidWebViewController.enableDebugging(true);
    (controller.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);

    _controller = controller;
  }

  ThemeMode themeMode = ThemeMode.system;
  final GlobalKey _globalKey = GlobalKey();

  Future<bool> _onBack(BuildContext context) async {
    var canGoBack = await _controller.canGoBack();

    if (canGoBack) {
      _controller.goBack();
      return false;
    } else {
      BackEventNotifier localNotifier =
          Provider.of<BackEventNotifier>(context, listen: false);
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(color: Colors.purple),
          ),
          content: const Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                localNotifier.add(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                localNotifier.add(true);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
      return localNotifier.isBack;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        late Color addressBarColor;
        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // (Optional) If applicable, harmonize custom colors.

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();

          //_isDemoUsingDynamicColors = true; // ignore, only for demo purposes
        }
        return ChangeNotifierProvider(
          create: (context) => BackEventNotifier(),
          child: MaterialApp(
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
            home: WillPopScope(
              onWillPop: () => _onBack(context),
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 0,
                ),
                backgroundColor: Colors.white38,
                key: _globalKey,
                body: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Opacity(
                          opacity: 0.97,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
