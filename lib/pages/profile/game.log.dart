import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util/api.dart';
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';
import 'game.view.dart';
import 'pass.play.view.dart';

class GameLogPage extends StatefulWidget {
  const GameLogPage({Key? key}) : super(key: key);

  @override
  State<GameLogPage> createState() => _GameLogPageState();
}

class _GameLogPageState extends State<GameLogPage> with TickerProviderStateMixin {
  int pageIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      StreamBuilder(
        stream: firestore.collection("games").where("isPlaying", isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
          context,
          snapshot,
          (data) {
            List<QueryDocumentSnapshot> userGames =
                data.docs.where((element) => (element["players"] as Map).values.contains(provider(context).user!.ref)).toList();
            userGames.sort((a, b) {
              DateTime aTime = a["time"].toDate();
              DateTime bTime = b["time"].toDate();
              return aTime.isAfter(bTime)
                  ? -1
                  : aTime.isAtSameMomentAs(bTime)
                      ? 0
                      : 1;
            });
            return SizedBox(
              height: 500.0,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  DateTime timeStamp = (userGames[index]["time"] as Timestamp).toDate();
                  String timeStampString =
                      "${AppLocalizations.of(context)!.date(timeStamp.day.toString().padLeft(2, "0"), timeStamp.month.toString().padLeft(2, "0"), timeStamp.year)} ${timeStamp.hour.toString().padLeft(2, "0")}:${(timeStamp.minute % 60).toString().padLeft(2, "0")}:${(timeStamp.second % 60).toString().padRight(2, "0")}";
                  String shape = (userGames[index]["players"] as Map)
                      .keys
                      .where((element) => (userGames[index]["players"] as Map)[element] == provider(context).user!.ref)
                      .single;
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
      StreamBuilder(
        stream: firestore.collection("passPlay").where("host", isEqualTo: provider(context).user!.ref).snapshots(),
        builder: (context, snapshot) => asyncBuilder(
          context,
          snapshot,
          (data) {
            List<QueryDocumentSnapshot> games = data.docs;
            games.sort((a, b) {
              DateTime aTime = a["time"].toDate();
              DateTime bTime = b["time"].toDate();
              return aTime.isAfter(bTime)
                  ? -1
                  : aTime.isAtSameMomentAs(bTime)
                      ? 0
                      : 1;
            });
            return SizedBox(
              height: 500.0,
              child: ListView.builder(
                itemCount: games.length,
                itemExtent: 75.0,
                itemBuilder: (context, index) {
                  DateTime timeStamp = (games[index]["time"] as Timestamp).toDate();
                  String dateString = AppLocalizations.of(context)!
                      .date(timeStamp.day.toString().padLeft(2, "0"), timeStamp.month.toString().padLeft(2, "0"), timeStamp.year);
                  String timeString =
                      "${timeStamp.hour.toString().padLeft(2, "0")}:${(timeStamp.minute % 60).toString().padLeft(2, "0")}:${(timeStamp.second % 60).toString().padRight(2, "0")}";
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PassPlayViewPage(gameRef: games[index].reference),
                        ),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: ListTile(
                          title: Text(
                            dateString,
                            textScaler: TextScaler.linear(provider(context).tsf),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            timeString,
                            textScaler: TextScaler.linear(provider(context).tsf),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ];
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: SingleChildScrollView(
        child: Center(
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
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context)!.online,
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!.passPlay,
                      ),
                    ],
                    onTap: (newIndex) {
                      setState(() {
                        pageIndex = newIndex;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  pages[pageIndex],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
