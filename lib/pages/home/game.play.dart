import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../ui/theme.dart';
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
        body: SingleChildScrollView(
          child: Center(
            child: StreamBuilder(
              stream: firestore.doc("games/${widget.gameId}").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                context,
                snapshot,
                (game) {
                  if (!game["isPlaying"]) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        canPop = true;
                      });
                      Navigator.of(context).pop();
                    });
                    return blank;
                  }
                  playerIndex = turnOrder.indexOf(
                    game["players"].entries.where((e) => e.value.id == provider(context).user!.uid).toList()[0].key,
                  );
                  currentPlayerIndex = game["moves"].isEmpty ? 0 : game["moves"].last.length % 4;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomPaint(
                          size: Size(
                            min(400.0, MediaQuery.of(context).size.width),
                            min(400.0, MediaQuery.of(context).size.width),
                          ),
                          painter: BoardPainter(
                            turns: game["moves"],
                            lines: game["lines"],
                            context: context,
                          ),
                        ),
                        currentPlayerIndex == playerIndex
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  10,
                                  (index) => SizedBox(
                                    height: (min(400.0, MediaQuery.of(context).size.width) - 32) / 10,
                                    width: (min(400.0, MediaQuery.of(context).size.width) - 32) / 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_downward),
                                      tooltip: AppLocalizations.of(context)!.placePiece,
                                      onPressed: () async {
                                        List moves = game["moves"];
                                        if (moves.isEmpty) {
                                          moves.add({
                                            turnOrder[playerIndex]: index,
                                          });
                                        }
                                        if (moves.last.length == 4) {
                                          moves.add({
                                            turnOrder[playerIndex]: index,
                                          });
                                        } else {
                                          moves.last[turnOrder[playerIndex]] = index;
                                        }
                                        await game.reference.update({
                                          "moves": moves,
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : blank,
                        Text(
                          AppLocalizations.of(context)!.results,
                          textScaler: TextScaler.linear(provider(context).tsf),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
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
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  );
                },
              ),
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

  BoardPainter({required this.context, required this.turns, required this.lines});

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
    for (int i = 0; i < turns.length; i++) {
      Map<String, dynamic> turn = turns[i];
      for (int j = 0; j < (i == turns.length - 1 ? turns.last.length : 4); j++) {
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
    for (Line line in linesToRender) {
      Path linePath = Path();
      linePath.moveTo(line.points[0][0] * size.width / (points.length) + size.width / (2 * (points.length)), size.height - (line.points[0][1] * size.height / (points.length) + size.height / (2 * (points.length))));
      linePath.lineTo(line.points[1][0] * size.width / (points.length) + size.width / (2 * (points.length)), size.height - (line.points[1][1] * size.height / (points.length) + size.height / (2 * (points.length))));
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
    return turns != oldDelegate.turns;
  }
}
