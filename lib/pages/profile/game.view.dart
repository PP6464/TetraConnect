import 'dart:math';

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<QuerySnapshot>(
            future: widget.gameRef.collection("moves").get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) => asyncBuilder(
              context,
              data,
              (gameData) {
                List<QueryDocumentSnapshot> turns = gameData.docs;
                return Column(
                  children: [
                    CustomPaint(
                      size: Size(
                        min(400.0, MediaQuery.of(context).size.width),
                        min(400.0, MediaQuery.of(context).size.width),
                      ),
                      painter: BoardPainter(
                        turns: turns,
                        moveIndex: moveIndex,
                        turnIndex: turnIndex,
                        context: context,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  List<String> turnOrder = ["circle", "square", "triangle", "cross"];
  BuildContext context;
  final List<QueryDocumentSnapshot> turns;
  int moveIndex;
  int turnIndex;

  BoardPainter({required this.context, required this.turns, required this.moveIndex, required this.turnIndex});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid
    Color gridColour = isDarkMode(context) ? Colors.white : Colors.black;
    Paint gridPaint = Paint()
      ..color = gridColour
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    List<Offset> topPoints = List.generate(9, (index) => Offset((index + 1) * size.width / 10, 0));
    List<Offset> bottomPoints = List.generate(9, (index) => Offset((index + 1) * size.width / 10, size.height));
    List<Offset> leftPoints = List.generate(9, (index) => Offset(0, (index + 1) * size.height / 10));
    List<Offset> rightPoints = List.generate(9, (index) => Offset(size.width, (index + 1) * size.height / 10));
    for (int i = 0; i < 9; i++) {
      canvas.drawLine(topPoints[i], bottomPoints[i], gridPaint);
      canvas.drawLine(leftPoints[i], rightPoints[i], gridPaint);
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) {
    return moveIndex == oldDelegate.moveIndex || turnIndex == oldDelegate.turnIndex;
  }
}
