import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'dart:async';

class AppStrings {
  static String sharedText = "";
  // Adicione outras constantes de string aqui
}

List<String> history = [];

String provider = 'https://12ft.io/';

class HistoryFunctions {
  static void addHistory(String texto) {
    history.insert(0, texto);
  }

  static void removeHistorico(int index) {
    history.removeAt(index);
  }
}

const double paddingLeft8 = 8;
const double paddingRight8 = 8;
const double paddingBottom8 = 8;
const double paddingTop8 = 8;

const double paddingLeft0 = 0;
const double paddingRight0 = 0;
const double paddingBottom0 = 0;
const double paddingTop0 = 0;

const double paddingLeft20 = 20;
const double paddingRight20 = 20;
const double paddingBottom20 = 20;
const double paddingTop20 = 20;

enum Options {
  twelveFtIo,
  archiveIs,
  removePaywallCom,
  leiaIssoNet,
}

class UrlLauncherFunctions {
  static Future<void> launchURL(
      BuildContext context, String value, String provider) async {
    final theme = Theme.of(context);
    if (provider.isEmpty) {
      provider = 'https://12ft.io/';
    }
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
            'org.mozilla.firefox',
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
