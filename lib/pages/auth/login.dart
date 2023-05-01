import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Row(
          children: [
            Text(
              "TetraConnect",
              textScaleFactor: provider(context).tsf,
            ),
            const Spacer(),
            logo(),
          ],
        ),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              logo(
                radius: 90.0,
                padding: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.login,
                  textScaleFactor: provider(context).tsf,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
