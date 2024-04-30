import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/provider/app.settings.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.home),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.aimOfGame,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.gameIntroP1,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    textAlign: TextAlign.justify,
                  ),
                  Container(
                    height: 300.0,
                    width: 300.0,
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/gravity.gif"),
                  ),
                  Text(
                    AppLocalizations.of(context)!.gameIntroP2,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => route.home.widget,
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.home,
              color: Colors.black,
            ),
            const SizedBox(width: 8.0),
            Text(
              AppLocalizations.of(context)!.continueToHome,
              textScaler: TextScaler.linear(provider(context).tsf),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
