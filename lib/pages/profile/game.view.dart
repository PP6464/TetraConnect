import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class GameViewPage extends StatefulWidget {
  final DocumentReference gameRef;

  const GameViewPage({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<GameViewPage> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  int moveIndex = 0;
  int turnIndex = 0;
  List<String> turnOrder = ["circle", "square", "triangle", "cross"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: Center(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
