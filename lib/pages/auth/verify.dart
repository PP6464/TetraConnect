// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/elements.dart';
import '../../util/api.dart';
import '../../util/route.dart';
import '../../ui/theme.dart';
import '../../provider/app.settings.dart';
import '../home/home.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late Timer timer;

  @override
  initState() {
    super.initState();
    auth.currentUser!.sendEmailVerification();

    timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (Timer t) async {
        await checkEmailVerified();
      },
    );
  }

  Future<void> checkEmailVerified() async {
    await auth.currentUser!.reload();
    if (auth.currentUser!.emailVerified) {
      timer.cancel();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              "ArtHub",
              textScaleFactor: provider(context).tsf,
            ),
            const Spacer(),
            logo(),
            PopupMenuButton(
              onSelected: (value) async {
                if (value == "logout") {
                  await auth.signOut();
                  (await SharedPreferences.getInstance()).remove("uid");
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => route.logout.widget,
                    ),
                        (route) => false,
                  );
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: "logout",
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(
                      color: theme.error.colour,
                    ),
                    textScaleFactor: provider(context).tsf,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.verificationEmail(auth.currentUser!.email!),
            textScaleFactor: provider(context).tsf,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}