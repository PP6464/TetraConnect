import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './util/models.dart';
import './util/api.dart';
import './firebase_options.dart';
import './provider/app.settings.dart';
import './ui/theme.dart';
import 'pages/auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool saveUser = preferences.getBool("keepLoggedIn") ?? false;
  if (!saveUser) {
    try {
      await auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  final AppSettingsValues values;
  String? uid = preferences.getString("uid");
  if (!saveUser || uid == null) {
    await preferences.remove("uid");
    values = AppSettingsValues(
      uiMode: uiModeFromString(preferences.getString("uiMode") ?? stringifyUIMode(ThemeMode.system)),
      tsf: preferences.getDouble("tsf") ?? 1.0,
    );
  } else {
    values = AppSettingsValues(
      uiMode: uiModeFromString(preferences.getString("uiMode") ?? stringifyUIMode(ThemeMode.system)),
      tsf: preferences.getDouble("tsf") ?? 1.0,
      user: await User.fromUID(uid),
    );
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(values),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'TetraConnect',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          supportedLocales: const [
            Locale("en"),
          ],
          theme: ThemeData(
            fontFamily: "Montserrat",
            scaffoldBackgroundColor: theme.lightSurface.colour,
            primaryColor: theme.primary.colour,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.primary.colour,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme(
              onPrimary: Colors.black,
              secondary: theme.secondary.colour,
              background: theme.lightSurface.colour,
              brightness: Brightness.light,
              error: theme.error.colour,
              onBackground: Colors.black,
              onError: Colors.white,
              primary: Colors.black,
              onSecondary: Colors.white,
              surface: theme.lightSurface.colour,
              onSurface: Colors.black,
            ),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            fontFamily: "Montserrat",
            scaffoldBackgroundColor: theme.darkSurface.colour,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: theme.darkAppBar.colour,
            appBarTheme: AppBarTheme(
              backgroundColor: theme.darkAppBar.colour,
            ),
            colorScheme: ColorScheme(
              onPrimary: theme.darkAppBar.colour,
              primary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.black,
              error: theme.red.colour,
              onError: Colors.white,
              background: theme.darkSurface.colour,
              onBackground: Colors.white,
              surface: theme.darkSurface.colour,
              onSurface: Colors.white,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: appState.uiMode,
          home: const SafeArea(
            child: AuthPage(),
          ),
        );
      },
    );
  }
}
