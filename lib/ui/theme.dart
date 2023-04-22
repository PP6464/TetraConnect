// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

enum theme {
  primary,
  secondary,
  darkAppBar,
  darkSurface,
  error,
  red,
  green,
  blue,
  pink
}

extension ThemeExt on theme {
  Color get colour {
    switch (this) {
      case theme.primary:
        return const Color(0xFFFFFFFF);
      case theme.secondary:
        return const Color(0xFF000000);
      case theme.darkAppBar:
        return const Color(0xFF202020);
      case theme.darkSurface:
        return const Color(0xFF101010);
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
    }
  }
}
