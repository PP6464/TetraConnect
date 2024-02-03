import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/provider/app.settings.dart';

import '../../ui/elements.dart';
import '../../ui/theme.dart';
import '../../util/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool matchmaking = false;
  int players = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.home),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: !matchmaking
              ? [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        matchmaking = true;
                        players = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.startGame,
                        textScaler: TextScaler.linear(provider(context).tsf),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  const Spacer(),
                  defaultLoadingIndicator,
                  Text(
                    AppLocalizations.of(context)!.searchingForPlayers,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.numberOfPlayers(players),
                    textScaler: TextScaler.linear(provider(context).tsf),
                  ),
                  const Spacer(),
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: theme.red.colour,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        matchmaking = false;
                        players = 0;
                      });
                    },
                  ),
                  const SizedBox(height: 32.0),
                ],
        ),
      ),
    );
  }
}
