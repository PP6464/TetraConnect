import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../ui/theme.dart';
import '../../ui/elements.dart';
import '../../util/constants.dart';
import '../../util/route.dart';

class GameViewPage extends StatefulWidget {
  final DocumentReference gameRef;

  const GameViewPage({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<GameViewPage> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  int moveIndex = 0;
  int turnIndex = -1;

  void nextTurn() {
    if (turnIndex == 3) {
      turnIndex = 0;
      moveIndex++;
    } else {
      turnIndex++;
    }
  }

  void prevTurn() {
    if (turnIndex == 0) {
      turnIndex = 3;
      moveIndex--;
    } else {
      turnIndex--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: widget.gameRef.get(),
                  builder: (context, snapshot) => asyncBuilder(
                    context,
                    snapshot,
                    (game) {
                      List<dynamic> moves = game["moves"];
                      return Column(
                        children: [
                          CustomPaint(
                            size: Size(
                              min(400.0, MediaQuery.of(context).size.width),
                              min(400.0, MediaQuery.of(context).size.width),
                            ),
                            painter: BoardPainter(
                              turns: moves,
                              moveIndex: moveIndex,
                              turnIndex: turnIndex,
                              lines: game["lines"],
                              context: context,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              moveIndex <= 0 && turnIndex < 0
                                  ? blank
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          prevTurn();
                                          try {
                                            while (moves[moveIndex][turnOrder[turnIndex]] == null) {
                                              prevTurn();
                                            }
                                          } catch (e) {
                                            moveIndex = 0;
                                            turnIndex = -1;
                                          }
                                        });
                                      },
                                      tooltip: AppLocalizations.of(context)!.backward,
                                      icon: const Icon(Icons.arrow_back),
                                    ),
                              const SizedBox(width: 8.0),
                              moveIndex == moves.length - 1 && turnIndex == 3
                                  ? blank
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          nextTurn();
                                          while (moves[moveIndex][turnOrder[turnIndex]] == null &&
                                              moveIndex < moves.length &&
                                              turnIndex < (moveIndex == moves.length - 1 ? moves.last.length : 4) &&
                                              (moveIndex == moves.length - 1 ? turnIndex < 3 : true)) {
                                            nextTurn();
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
                            child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                itemExtent: 50.0,
                                itemCount: 4,
                                itemBuilder: (context, index) => StreamBuilder(
                                  stream: (game["players"][turnOrder[index]] as DocumentReference).snapshots(),
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
                                              fontWeight: index == (turnIndex) % 4 ? FontWeight.bold : FontWeight.normal,
                                              fontSize: index == (turnIndex) % 4 ? 20.0 : 17.5,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Line {
  final List<List<int>> points;
  final int moveIndex;
  final int turnIndex;

  Line({required this.points, required this.moveIndex, required this.turnIndex});

  static Line fromString(String l) {
    List<int> values = l.split(",").map((e) => int.parse(e)).toList();
    return Line(
      points: [
        [
          values[0],
          values[1],
        ],
        [
          values[2],
          values[3],
        ],
      ],
      moveIndex: values[4],
      turnIndex: values[5],
    );
  }
}

class BoardPainter extends CustomPainter {
  BuildContext context;
  final List<dynamic> turns;
  final List lines; // Show line when 4 in a row made
  final int moveIndex;
  final int turnIndex;

  BoardPainter({required this.context, required this.turns, required this.moveIndex, required this.turnIndex, required this.lines});

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
      Map<String, dynamic> turn = turns[i];
      for (int j = 0; j < (i == moveIndex ? turnIndex + 1 : 4); j++) {
        if (turn[turnOrder[j]] != null) points[turn[turnOrder[j]]].add(turnOrder[j]);
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
    // Render lines
    List<Line> linesToRender = lines.map((e) => Line.fromString(e)).toList();
    linesToRender = linesToRender
        .where((element) => element.moveIndex < moveIndex || (element.moveIndex == moveIndex && element.turnIndex <= turnIndex))
        .toList(); // Only render lines once the 4 in a row is formed
    for (Line line in linesToRender) {
      Path linePath = Path();
      linePath.moveTo(line.points[0][0] * size.width / (points.length) + size.width / (2 * (points.length)),
          size.height - (line.points[0][1] * size.height / (points.length) + size.height / (2 * (points.length))));
      linePath.lineTo(line.points[1][0] * size.width / (points.length) + size.width / (2 * (points.length)),
          size.height - (line.points[1][1] * size.height / (points.length) + size.height / (2 * (points.length))));
      canvas.drawPath(
        linePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = isDarkMode(context) ? Colors.white : Colors.black
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) {
    return moveIndex == oldDelegate.moveIndex || turnIndex == oldDelegate.turnIndex;
  }
}
