// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/provider/app.settings.dart';

import '../../ui/elements.dart';
import '../../ui/theme.dart';
import '../../util/api.dart';
import '../../util/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool matchmaking = false;
  int players = 0;
  String lobbyId = "";
  List<String> turnOrder = ["circle", "square", "triangle", "cross"];

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
                      QuerySnapshot lobbies = await firestore.collection("lobbies").where("playerCount", isLessThan: 4).get();
                      if (lobbies.docs.isEmpty) {
                        // Create a new lobby
                        firestore.collection("lobbies").add({
                          "players": {
                            "circle": provider(context).user!.ref,
                          },
                          "playerCount": 1,
                          "avgRating": provider(context).user!.rating,
                        });
                      } else {
                        // Join existing lobby with closest average rating
                        QueryDocumentSnapshot lobby = (lobbies.docs
                              ..sort((a, b) {
                                return (a["avgRating"] - provider(context).user!.rating).abs() - (b["avgRating"] - provider(context).user!.rating);
                              }))
                            .first;
                        lobbyId = lobby.id;
                        await lobby.reference.update({
                          "players": {
                            turnOrder[lobby["playerCount"]]: provider(context).user!.ref,
                            ...lobby["players"],
                          },
                          "playerCount": FieldValue.increment(1),
                          "avgRating": (lobby["avgRating"] * lobby["playerCount"] + provider(context).user!.rating) / (lobby["playerCount"] + 1),
                        });
                        setState(() {
                          players = lobby["playerCount"] + 1;
                        });
                      }
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
                      DocumentSnapshot lobby = await firestore.doc("lobbies/$lobbyId").get();
                      if (lobby["playerCount"] == 1) {
                        await lobby.reference.delete();
                      } else {
                        String shape = lobby["players"].entries.where((e) => e.value = provider(context).user!.ref).single.key;
                        int shapeIndex = turnOrder.indexOf(shape);
                        Map<String, DocumentReference> newPlayers = lobby["players"];
                        for (int i = shapeIndex + 1; i < 4; i++) {
                          if (lobby["players"][turnOrder[i]] == null) break;
                          newPlayers[turnOrder[i - 1]] = lobby["players"][turnOrder[i]];
                        }
                        await lobby.reference.update({
                          "avgRating": (lobby["avgRating"] * lobby["playerCount"] - provider(context).user!.rating) / (lobby["playerCount"] - 1),
                          "playerCount": FieldValue.increment(-1),
                          "players": newPlayers,
                        });
                      }
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
