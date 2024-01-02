import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../ui/theme.dart';
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
  int userIndex = -1;
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        moveIndex == 0 && turnIndex == 0
                            ? blank
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (turnIndex == 0) {
                                      turnIndex = 3;
                                      moveIndex--;
                                    } else {
                                      turnIndex--;
                                    }
                                    if (userIndex == 0) {
                                      userIndex = 3;
                                    } else {
                                      userIndex--;
                                    }
                                  });
                                },
                                tooltip: AppLocalizations.of(context)!.backward,
                                icon: const Icon(Icons.arrow_back),
                              ),
                        const SizedBox(width: 8.0),
                        moveIndex == turns.length - 1 && turnIndex == (turns.last.data() as Map).length
                            ? blank
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (turnIndex == 3) {
                                      turnIndex = 0;
                                      moveIndex++;
                                    } else {
                                      turnIndex++;
                                    }
                                    if (userIndex == 3) {
                                      userIndex = 0;
                                    } else {
                                      userIndex++;
                                    }
                                  });
                                },
                                tooltip: AppLocalizations.of(context)!.forward,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: FutureBuilder(
                        future: widget.gameRef.get(),
                        builder: (context, snapshot) => asyncBuilder(
                          context,
                          snapshot,
                          (data) {
                            return SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                itemExtent: 50.0,
                                itemCount: 4,
                                itemBuilder: (context, index) => StreamBuilder(
                                  stream: (data["players"][turnOrder[index]] as DocumentReference).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                                    context,
                                    snapshot,
                                    (userData) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              foregroundImage: NetworkImage(userData["photoUrl"]),
                                              radius: 34.0,
                                            ),
                                          ),
                                          Text(
                                            userData["displayName"],
                                            textScaler: TextScaler.linear(provider(context).tsf),
                                            style: TextStyle(
                                              fontWeight: index == userIndex ? FontWeight.bold : FontWeight.normal,
                                              fontSize: index == userIndex ? 20.0 : 17.5,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
    // Calculate grid
    List<List<String>> points = List.generate(10, (index) => []);
    for (int i = 0; i <= moveIndex; i++) {
      QueryDocumentSnapshot turn = turns.where((element) => element.id == "${i + 1}").single;
      for (int j = 0; j < (i == moveIndex ? turnIndex : (turn.data() as Map).length); j++) {
        if (turn[turnOrder[j]] != null) points[turn[turnOrder[j]] - 1].add(turnOrder[j]);
      }
    }
    // Render pieces
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < points[i].length; j++) {
        switch (points[i][j]) {
          case "circle":
            canvas.drawCircle(
              Offset(
                size.width / (2 * points.length) + size.width * i / points.length,
                size.height - (size.height / (2 * points.length) + size.height * j / points.length),
              ),
              15.0,
              Paint()
                ..color = theme.red.colour
                ..style = PaintingStyle.fill,
            );
            canvas.drawCircle(
              Offset(
                size.width / (2 * points.length) + size.width * i / points.length,
                size.height - (size.height / (2 * points.length) + size.height * j / points.length),
              ),
              15.0,
              Paint()
                ..color = isDarkMode(context) ? Colors.white : Colors.black
                ..style = PaintingStyle.stroke
                ..strokeCap = StrokeCap.round
                ..strokeWidth = 1.0,
            );
            break;
          case "square":
            Rect square = Rect.fromCenter(
              center: Offset(
                size.width / (2 * points.length) + size.width * i / points.length,
                size.height - (size.height / (2 * points.length) + size.height * j / points.length),
              ),
              width: 30.0,
              height: 30.0,
            );
            canvas.drawRect(
              square,
              Paint()
                ..color = theme.pink.colour
                ..style = PaintingStyle.fill,
            );
            canvas.drawRect(
              square,
              Paint()
                ..color = isDarkMode(context) ? Colors.white : Colors.black
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..strokeCap = StrokeCap.round,
            );
            break;
          case "triangle":
            Path triangle = Path();
            triangle.moveTo(
              (size.width / (2 * points.length) + size.width * i / points.length) - 15,
              size.height - (size.height / (2 * points.length) + size.height * j / points.length) + 7.5 * sqrt(3),
            );
            triangle.relativeLineTo(30, 0);
            triangle.relativeLineTo(-15, -15 * tan(pi / 3));
            triangle.relativeLineTo(-15, 15 * tan(pi / 3));
            triangle.close();
            canvas.drawPath(
              triangle,
              Paint()
                ..color = theme.green.colour
                ..style = PaintingStyle.fill,
            );
            canvas.drawPath(
              triangle,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..strokeCap = StrokeCap.round
                ..color = isDarkMode(context) ? Colors.white : Colors.black,
            );
            break;
          case "cross":
            Path cross = Path();
            cross.moveTo(
              (size.width / (2 * points.length) + size.width * i / points.length) + 5 / sqrt(2),
              size.height - (size.height / (2 * points.length) + size.height * j / points.length),
            );
            cross.relativeLineTo(15 - 5 / sqrt(2), -15 + (5 / sqrt(2)));
            cross.relativeLineTo(-5 / sqrt(2), -5 / sqrt(2));
            cross.relativeLineTo(-15 + 5 / sqrt(2), 15 - (5 / sqrt(2)));
            cross.relativeLineTo(-15 + (5 / sqrt(2)), -15 + 5 / sqrt(2));
            cross.relativeLineTo(-5 / sqrt(2), 5 / sqrt(2));
            cross.relativeLineTo(15 - 5 / sqrt(2), 15 - 5 / sqrt(2));
            cross.relativeLineTo(-15 + 5 / sqrt(2), 15 - 5 / sqrt(2));
            cross.relativeLineTo(5 / sqrt(2), 5 / sqrt(2));
            cross.relativeLineTo(15 - 5 / sqrt(2), -15 + 5 / sqrt(2));
            cross.relativeLineTo(15 - 5 / sqrt(2), 15 - 5 / sqrt(2));
            cross.relativeLineTo(5 / sqrt(2), -5 / sqrt(2));
            cross.relativeLineTo(-15 + 5 / sqrt(2), -15 + 5 / sqrt(2));
            canvas.drawPath(
              cross,
              Paint()
                ..color = theme.blue.colour
                ..style = PaintingStyle.fill,
            );
            canvas.drawPath(
              cross,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..strokeCap = StrokeCap.round
                ..color = isDarkMode(context) ? Colors.white : Colors.black,
            );
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) {
    return moveIndex == oldDelegate.moveIndex || turnIndex == oldDelegate.turnIndex;
  }
}
