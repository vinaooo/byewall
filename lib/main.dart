import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/scheduler.dart';
import 'package:adwaita/adwaita.dart';

import 'homepage.dart';

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
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
// asdsdasdasd
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

        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              themeMode: themeMode,
              theme: Platform.isLinux
                  ? AdwaitaThemeData.light()
                  : ThemeData(
                      colorScheme: lightDynamic ??
                          Theme.of(context)
                              .colorScheme
                              .copyWith(brightness: Brightness.light),
                      useMaterial3: true,
                    ),
              darkTheme: Platform.isLinux
                  ? AdwaitaThemeData.dark()
                  : ThemeData(
                      colorScheme: darkDynamic ??
                          Theme.of(context)
                              .colorScheme
                              .copyWith(brightness: Brightness.dark),
                      useMaterial3: true,
                    ),
              home: HomePage(themeNotifier: themeNotifier),
            );
          },
        );
      },
    );
  }
}
