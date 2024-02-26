// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../provider/app.settings.dart';

ThemeData checkBoxTheme(BuildContext context) => ThemeData(
  brightness: provider(context).uiMode == ThemeMode.light
      ? Brightness.light
      : provider(context).uiMode == ThemeMode.dark
          ? Brightness.dark
          : MediaQuery.of(context).platformBrightness,
  primaryColor: theme.blue.colour,
  colorScheme: ColorScheme(
    primary: theme.blue.colour,
    brightness: provider(context).uiMode == ThemeMode.light
        ? Brightness.light
        : provider(context).uiMode == ThemeMode.dark
            ? Brightness.dark
            : MediaQuery.of(context).platformBrightness,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    error: theme.red.colour,
    secondary: theme.blue.colour,
    onBackground: Colors.white,
    background: theme.blue.colour,
    onSurface: Colors.white,
    surface: theme.blue.colour,
    onError: Colors.white,
  ),
);

enum theme {
  primary,
  secondary,
  darkAppBar,
  darkSurface,
  error,
  red,
  green,
  blue,
  pink,
  lightSurface,
}

extension ThemeExt on theme {
  Color get colour {
    switch (this) {
      case theme.primary:
        return const Color(0xFFFFFFFF);
      case theme.secondary:
        return const Color(0xFF000000);
      case theme.darkAppBar:
        return const Color(0xFF101010);
      case theme.darkSurface:
        return const Color(0xFF020202);
      case theme.error:
        return const Color(0xFFFF5858);
      case theme.red:
        return const Color(0xFFFF3030);
      case theme.green:
        return const Color(0xFF00FF99);
      case theme.blue:
        return const Color(0xFF00AAFF);
      case theme.pink:
        return const Color(0xFFFFCCCC);
      case theme.lightSurface:
        return const Color(0xFFDDDDDD);
    }
  }
}
