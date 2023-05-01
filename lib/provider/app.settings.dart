import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/models.dart';

double tsfMin = 0.5;
double tsfMax = 1.5;

class AppSettings extends ChangeNotifier {
  ThemeMode _uiMode = ThemeMode.system;
  ThemeMode get uiMode => _uiMode;
  double _tsf = 1.0; // (tsf = Text Scale Factor)
  double get tsf => _tsf;
  User? _user;
  User? get user => _user;

  Future<void> updateTSF(double value) async {
    assert(tsfMin <= value && value <= tsfMax); // Ensure tsf is within reasonable range
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble("tsf", value);
    _tsf = value;
    notifyListeners();
  }

  Future<void> updateUIMode(ThemeMode newMode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("uiMode", stringifyUIMode(newMode));
    _uiMode = newMode;
    notifyListeners();
  }

  Future<void> updateUser(User? newUser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (newUser != null) {
      preferences.setString("uid", newUser.uid);
    } else {
      preferences.remove("uid");
    }
    _user = newUser;
    notifyListeners();
  }

  AppSettings(AppSettingsValues values) {
    _uiMode = values.uiMode;
    _tsf = values.tsf;
    _user = values.user;
  }
}

class AppSettingsValues {
  final ThemeMode uiMode;
  final double tsf;
  final User? user;

  AppSettingsValues({
    required this.uiMode,
    required this.tsf,
    this.user,
  });
}

AppSettings provider(context, [listen = false]) => Provider.of<AppSettings>(context, listen: listen);

String stringifyUIMode(ThemeMode uiMode) {
  switch (uiMode) {
    case ThemeMode.system:
      return "system";
    case ThemeMode.light:
      return "light";
    case ThemeMode.dark:
      return "dark";
  }
}

ThemeMode uiModeFromString(String uiMode) {
  for (ThemeMode themeMode in ThemeMode.values) {
    if (stringifyUIMode(themeMode) == uiMode) return themeMode;
  }
  return ThemeMode.system;
}