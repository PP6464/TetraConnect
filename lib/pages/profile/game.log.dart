import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util/api.dart';
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';
import 'game.view.dart';

class GameLogPage extends StatefulWidget {
  const GameLogPage({Key? key}) : super(key: key);

  @override
  State<GameLogPage> createState() => _GameLogPageState();
}

class _GameLogPageState extends State<GameLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: min(500.0, MediaQuery.of(context).size.width),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(provider(context).user!.photoUrl),
                      radius: 90.0,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.gameLog,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  FutureBuilder(
                    future: firestore.collection("games").where("isPlaying", isEqualTo: false).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                      context,
                      snapshot,
                      (data) {
                        List<QueryDocumentSnapshot> userGames = data.docs.where((element) => (element["players"] as Map).values.contains(provider(context).user!.ref)).toList();
                        return SizedBox(
                          height: 500.0,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              DateTime timeStamp = (userGames[index]["time"] as Timestamp).toDate();
                              String timeStampString = "${AppLocalizations.of(context)!.date(timeStamp.day, timeStamp.second, timeStamp.year)} ${timeStamp.hour.toString().padRight(2, "0")}:${(timeStamp.minute % 60).toString().padRight(2, "0")}:${(timeStamp.second % 60).toString().padRight(2, "0")}";
                              String shape = (userGames[index]["players"] as Map).keys.where((element) => (userGames[index]["players"] as Map)[element] == provider(context).user!.ref).single;
                              int result = (userGames[index]["results"] as List<dynamic>).indexOf(provider(context).user!.ref);
                              if (result > 2 - ((userGames[index].data() as Map)["ties"] ?? 0)) {
                                result = 3 - ((userGames[index].data() as Map)["ties"] ?? 0) as int;
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => GameViewPage(gameRef: userGames[index].reference),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 2.0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16.0, bottom: 30.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Image.asset("assets/$shape.png"),
                                        subtitle: Text(
                                          result == 0
                                              ? AppLocalizations.of(context)!.first
                                              : result == 1
                                                  ? AppLocalizations.of(context)!.second
                                                  : result == 2
                                                      ? AppLocalizations.of(context)!.third
                                                      : AppLocalizations.of(context)!.fourth,
                                          textScaler: TextScaler.linear(provider(context).tsf),
                                        ),
                                        title: Text(
                                          timeStampString,
                                          textScaler: TextScaler.linear(provider(context).tsf),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: userGames.length,
                            itemExtent: 75.0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
