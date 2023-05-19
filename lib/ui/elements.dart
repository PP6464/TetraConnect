// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/app.settings.dart';
import '../util/api.dart';
import 'theme.dart';
import '../util/route.dart';

Widget blank = const SizedBox(height: 0.0, width: 0.0);

Widget logo({double radius = 20.0, double padding = 0.0}) => Padding(
      padding: EdgeInsets.all(padding),
      child: CircleAvatar(
        foregroundImage: const AssetImage("assets/logo.png"),
        radius: radius,
      ),
    );

AppBar normalAppBar(BuildContext context, route? removedRoute) => AppBar(
      elevation: 2.0,
      title: Row(
        children: [
          Text(
            "TetraConnect",
            textScaleFactor: provider(context, true).tsf,
          ),
          const Spacer(),
          logo(),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == route.logout.value) {
                await auth.signOut();
                provider(context).updateUser(null);
                (await SharedPreferences.getInstance()).remove("uid");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => route.logout.widget,
                  ),
                  (route) => false,
                );
                return;
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => route.values.where((element) => element.value == value).single.widget,
                  ),
                );
              }
            },
            itemBuilder: (context) => List.generate(
              removedRoute == null ? route.values.length : route.values.length - 1,
              (int index) => PopupMenuItem(
                value: (route.values.where((element) => element != removedRoute)).toList()[index].value,
                child: Text(
                  (route.values.where((element) => element != removedRoute)).toList()[index].name(context),
                  style: (route.values.where((element) => element != removedRoute)).toList()[index] == route.logout
                      ? TextStyle(
                          color: theme.error.colour,
                        )
                      : (route.values.where((element) => element != removedRoute)).toList()[index] == route.fundTetraConnect
                          ? const TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          : null,
                  textScaleFactor: provider(context).tsf,
                ),
              ),
            ),
          ),
        ],
      ),
    );

Widget asyncBuilder<T>(BuildContext context, AsyncSnapshot<T> snapshot, Widget Function(T) onSuccessWidget) {
  if (snapshot.hasData) {
    return onSuccessWidget(snapshot.data as T);
  } else if (snapshot.hasError) {
    return errorText(context);
  } else {
    return defaultLoadingIndicator;
  }
}

Text errorText(BuildContext context) => Text(AppLocalizations.of(context)!.error,
    textScaleFactor: provider(context).tsf,
    style: const TextStyle(
      fontSize: 17.5,
    ));

Widget defaultLoadingIndicator = Padding(
  padding: const EdgeInsets.all(8.0),
  child: CircularProgressIndicator(
    backgroundColor: theme.secondary.colour,
    valueColor: AlwaysStoppedAnimation<Color>(theme.primary.colour),
  ),
);

bool isDarkMode(context) => Theme.of(context).brightness == Brightness.dark;
