import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tetraconnect/util/api.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class GamePlayPage extends StatefulWidget {
  final String gameId;

  const GamePlayPage({super.key, required this.gameId});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  int currentPlayerIndex = 0;
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
              }
              return blank;
            },
          ),
        ),
      ),
    );
  }
}
