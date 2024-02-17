import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/api.dart';
import '../../util/constants.dart';
import '../../util/route.dart';

class GamePlayPage extends StatefulWidget {
  final String gameId;

  const GamePlayPage({super.key, required this.gameId});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  int currentPlayerIndex = 0;
  int playerIndex = 0;
  bool canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        appBar: normalAppBar(context, route.home),
        body: StreamBuilder(
          stream: firestore.doc("games/${widget.gameId}").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
            context,
            snapshot,
            (game) {
              if (!game["isPlaying"]) {
                setState(() {
                  canPop = true;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
                return blank;
              }
              setState(() {
                playerIndex = turnOrder.indexOf(
                  game["players"].entries.where((e) => e.value.id == provider(context).user!.uid).toList()[0].key,
                );
              });
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  CustomPaint(),
                  currentPlayerIndex == playerIndex
                      ? Row(
                          children: [],
                        )
                      : blank,
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.results,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  ListView.builder(
                    itemCount: game["results"].length,
                    itemBuilder: (BuildContext context, int index) {
                      String position = index == 0
                          ? AppLocalizations.of(context)!.first
                          : index == 1
                              ? AppLocalizations.of(context)!.second
                              : index == 2
                                  ? AppLocalizations.of(context)!.third
                                  : AppLocalizations.of(context)!.fourth;
                      return StreamBuilder(
                        stream: game["results"][index].snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                          context,
                          snapshot,
                          (user) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 16.0),
                                Text(
                                  position,
                                  textScaler: TextScaler.linear(provider(context).tsf),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user["photoUrl"]),
                                  radius: 25.0,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  user["displayName"],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
