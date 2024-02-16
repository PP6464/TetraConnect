// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/pages/home/game.play.dart';
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
  int prevLobbyCount = 0;
  String lobbyId = "";
  List<String> turnOrder = ["circle", "square", "triangle", "cross"];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !matchmaking, // If matchmaking, popping should just cancel the match making
      onPopInvoked: (_) async {
        // Try to cancel the match if one is matchmaking
        if (matchmaking) {
          try {
            DocumentSnapshot lobby = await firestore.doc("lobbies/$lobbyId").get();
            if (lobby["playerCount"] == 1) {
              await lobby.reference.delete();
            } else {
              List newPlayers = lobby["players"].values.where((e) => e.id != provider(context).user!.uid).toList();
              List<String> newPlayersKeys = turnOrder.sublist(0, newPlayers.length);
              Map<String, dynamic> newPlayersMap = {};
              for (int i = 0; i < newPlayers.length; i++) {
                newPlayersMap[newPlayersKeys[i]] = newPlayers[i];
              }
              await lobby.reference.update({
                "avgRating": (lobby["avgRating"] * lobby["playerCount"] - provider(context).user!.rating) / (lobby["playerCount"] - 1),
                "playerCount": FieldValue.increment(-1),
                "players": newPlayersMap,
              });
            }
            matchmaking = false;
            setState(() {
            });
          } finally {}
        }
      },
      child: Scaffold(
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
                        QuerySnapshot lobbies = await firestore.collection("lobbies").where("playerCount", isLessThan: 4).get();
                        if (lobbies.docs.isEmpty) {
                          // Create a new lobby
                          DocumentReference ref = await firestore.collection("lobbies").add({
                            "players": {
                              "circle": provider(context).user!.ref,
                            },
                            "playerCount": 1,
                            "avgRating": provider(context).user!.rating,
                          });
                          setState(() {
                            lobbyId = ref.id;
                          });
                        } else {
                          // Join existing lobby with closest average rating
                          QueryDocumentSnapshot lobby = (lobbies.docs
                                ..sort((a, b) {
                                  return (a["avgRating"] - provider(context).user!.rating).abs() - (b["avgRating"] - provider(context).user!.rating);
                                }))
                              .first;
                          lobbyId = lobby.id;
                          if (lobby["playerCount"] == 3) {
                            // Lobby is full, convert to game
                            await firestore.doc("games/$lobbyId").set({
                              "players": {
                                turnOrder[lobby["playerCount"]]: provider(context).user!.ref,
                                ...lobby["players"],
                              },
                              "lines": [],
                              "results": {},
                              "isPlaying": true,
                              "time": FieldValue.serverTimestamp(),
                            });
                            await lobby.reference.delete();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GamePlayPage(gameId: lobbyId),
                              ),
                            );
                          } else {
                            await lobby.reference.update({
                              "players": {
                                turnOrder[lobby["playerCount"]]: provider(context).user!.ref,
                                ...lobby["players"],
                              },
                              "playerCount": FieldValue.increment(1),
                              "avgRating": (lobby["avgRating"] * lobby["playerCount"] + provider(context).user!.rating) / (lobby["playerCount"] + 1),
                            });
                          }
                        }
                        setState(() {
                          matchmaking = true;
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
                    StreamBuilder(
                      stream: firestore.doc("lobbies/$lobbyId").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                        context,
                        snapshot,
                        (lobbyInfo) {
                          if (lobbyInfo.exists) {
                            prevLobbyCount = lobbyInfo["playerCount"];
                            return Text(
                              AppLocalizations.of(context)!.numberOfPlayers(lobbyInfo["playerCount"]),
                              textScaler: TextScaler.linear(provider(context).tsf),
                            );
                          } else if (prevLobbyCount == 3) {
                            // Lobby has been converted into a game
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GamePlayPage(gameId: lobbyId),
                                ),
                              );
                            });
                            return blank;
                          } else {
                            // Lobby has been cancelled
                            matchmaking = false;
                            return blank;
                          }
                        },
                      ),
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
                          List newPlayers = lobby["players"].values.where((e) => e.id != provider(context).user!.uid).toList();
                          List<String> newPlayersKeys = turnOrder.sublist(0, newPlayers.length);
                          Map<String, dynamic> newPlayersMap = {};
                          for (int i = 0; i < newPlayers.length; i++) {
                            newPlayersMap[newPlayersKeys[i]] = newPlayers[i];
                          }
                          await lobby.reference.update({
                            "avgRating": (lobby["avgRating"] * lobby["playerCount"] - provider(context).user!.rating) / (lobby["playerCount"] - 1),
                            "playerCount": FieldValue.increment(-1),
                            "players": newPlayersMap,
                          });
                        }
                        setState(() {
                          matchmaking = false;
                        });
                      },
                    ),
                    const SizedBox(height: 32.0),
                  ],
          ),
        ),
      ),
    );
  }
}
