import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './util/models.dart';
import './util/api.dart';
import './firebase_options.dart';
import './provider/app.settings.dart';
import './ui/theme.dart';
import 'pages/auth/auth.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {

}

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
  AppSettingsValues values;
  String? uid = preferences.getString("uid");
  if (!saveUser || uid == null) {
    await preferences.remove("uid");
    values = AppSettingsValues(
      uiMode: uiModeFromString(preferences.getString("uiMode") ?? stringifyUIMode(ThemeMode.system)),
      tsf: preferences.getDouble("tsf") ?? 1.0,
    );
  } else {
    try {
      values = AppSettingsValues(
        uiMode: uiModeFromString(preferences.getString("uiMode") ?? stringifyUIMode(ThemeMode.system)),
        tsf: preferences.getDouble("tsf") ?? 1.0,
        user: await User.fromUID(uid),
      );
    } on Exception {
      values = AppSettingsValues(
        uiMode: uiModeFromString(preferences.getString("uiMode") ?? stringifyUIMode(ThemeMode.system)),
        tsf: preferences.getDouble("tsf") ?? 1.0,
      );
    }
  }
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
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
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      if (msg.data["type"] == "call") {
        if (!kIsWeb) {
          FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
          const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
            'max_importance_channel', // id
            'Max Importance Notifications', // title
            description: 'This channel is used for maximum important notifications.', // description
            importance: Importance.max,
          );
          await plugin.initialize(
            const InitializationSettings(
              android: AndroidInitializationSettings(
                "@drawable/ic_notification",
              ),
            ),
          );
          await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(notificationChannel);
          plugin.show(
            msg.notification!.hashCode,
            msg.notification!.title,
            msg.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannel.id,
                notificationChannel.name,
                channelDescription: notificationChannel.description,
                icon: "@drawable/ic_notification",
              ),
            ),
          );
        }
        return;
      }
      if (msg.data["type"] == "friendRequest") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.notificationSentFriendRequestTitle(msg.data["fromDisplayName"]),
              textScaler: TextScaler.linear(provider(context).tsf),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {});
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
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
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) return locale;
            return const Locale("en");
          },
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
