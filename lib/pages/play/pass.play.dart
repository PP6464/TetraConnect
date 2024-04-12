// ignore_for_file: sdk_version_since

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/util/api.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/constants.dart';
import '../../util/route.dart';
import '../../ui/theme.dart';

class PassPlayPage extends StatefulWidget {
  const PassPlayPage({super.key});

  @override
  State<PassPlayPage> createState() => _PassPlayPageState();
}

class _PassPlayPageState extends State<PassPlayPage> {
  List<Map<String, dynamic>> moves = [];
  List<Line> lines = [];
  List<String> results = [];
  int? ties;
  int playerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.passPlay),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomPaint(
                  size: Size(
                    min(400.0, MediaQuery.of(context).size.width),
                    min(400.0, MediaQuery.of(context).size.width),
                  ),
                  painter: BoardPainter(
                    turns: moves,
                    lines: lines,
                    context: context,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      10,
                      (index) => SizedBox(
                        height: (min(400.0, MediaQuery.of(context).size.width)) / 10,
                        width: (min(400.0, MediaQuery.of(context).size.width)) / 10,
                        child: (() {
                          List<List<String>> columns = List.generate(10, (index) => []);
                          for (var turn in moves) {
                            for (var move in turn.entries) {
                              if (move.value != null) columns[move.value].add(move.key);
                            }
                          }
                          if (!columns.any((element) => element.length < 10) && results.length < 3) {
                            // Grid is full so game must be complete, but results must be a tie
                            ties = 3 - results.length;
                            results.addAll(turnOrder.where((element) => !results.contains(element)));
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              firestore.collection("passPlay").add({
                                "results": results,
                                "ties": ties,
                                "lines": lines.map((e) => e.toString()).toList(),
                              });
                              Navigator.of(context).pop();
                            });
                            return false;
                          }
                          // If player has already finished
                          if (results.contains(turnOrder[playerIndex])) {
                            if (moves.last.length == 4) {
                              moves.add({
                                turnOrder[playerIndex]: null,
                              });
                            } else {
                              moves.last[turnOrder[playerIndex]] = null;
                            }
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                playerIndex = (playerIndex + 1) % 4;
                              });
                            });
                            return false;
                          }
                          return columns[index].length < 10;
                        }).call()
                            ? Tooltip(
                                message: AppLocalizations.of(context)!.placePiece,
                                child: GestureDetector(
                                  child: const Icon(Icons.arrow_downward),
                                  onTap: () async {
                                    if (moves.isEmpty) {
                                      moves.add({
                                        turnOrder[playerIndex]: index,
                                      });
                                    } else {
                                      // Check for 4 in a row
                                      List<List<String>> columns = List.generate(10, (index) => []);
                                      String shape = turnOrder[playerIndex];
                                      // First map the grid into a list of columns
                                      for (var turn in moves) {
                                        for (var move in turn.entries) {
                                          if (move.value != null) columns[move.value].add(move.key);
                                        }
                                      }
                                      columns[index].add(shape);
                                      // Only need to check for 4 in a row with the newest entry
                                      String? line; // Record a line showing the 4 in a row into the database
                                      // Check in each of 7 directions (can't have vertically upwards due to gravity)
                                      // Vertically downwards
                                      if (columns[index].length > 3 && !columns[index].sublist(columns[index].length - 4).any((e) => e != shape)) {
                                        // There is a 4 in a row vertically downward
                                        line =
                                            "$index,${columns[index].length - 1},$index,${columns[index].length - 4},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Horizontally left
                                      else if (index > 2 &&
                                          !columns
                                              .sublist(index - 3, index + 1)
                                              .map((e) => e.elementAtOrNull(columns[index].length - 1))
                                              .any((e) => e != shape)) {
                                        // There is a 4 in a row horizontally left
                                        line =
                                            "${index - 3},${columns[index].length - 1},$index,${columns[index].length - 1},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Horizontally right
                                      else if (index < 7 &&
                                          !columns
                                              .sublist(index, index + 4)
                                              .map((e) => e.elementAtOrNull(columns[index].length - 1))
                                              .any((e) => e != shape)) {
                                        line =
                                            "$index,${columns[index].length - 1},${index + 3},${columns[index].length - 1},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Horizontally (second from left)
                                      else if (index > 0 &&
                                          index < 8 &&
                                          !columns
                                              .sublist(index - 1, index + 3)
                                              .map((e) => e.elementAtOrNull(columns[index].length - 1))
                                              .any((e) => e != shape)) {
                                        line =
                                            "${index - 1},${columns[index].length - 1},${index + 2},${columns[index].length - 1},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Horizontally (second from right)
                                      else if (index > 1 &&
                                          index < 9 &&
                                          !columns
                                              .sublist(index - 2, index + 2)
                                              .map((e) => e.elementAtOrNull(columns[index].length - 1))
                                              .any((e) => e != shape)) {
                                        line =
                                            "${index - 2},${columns[index].length - 1},${index + 1},${columns[index].length - 1},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (bottom left to top right)
                                      else if (index < 7 &&
                                          columns[index + 1].elementAtOrNull(columns[index].length) == shape &&
                                          columns[index + 2].elementAtOrNull(columns[index].length + 1) == shape &&
                                          columns[index + 3].elementAtOrNull(columns[index].length + 2) == shape) {
                                        // There is a 4 in a row diagonally bottom left to top right
                                        line =
                                            "$index,${columns[index].length - 1},${index + 3},${columns[index].length + 2},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (same dir but second from left)
                                      else if (index > 0 &&
                                          index < 8 &&
                                          columns[index].length > 1 &&
                                          columns[index - 1].elementAtOrNull(columns[index].length - 2) == shape &&
                                          columns[index + 1].elementAtOrNull(columns[index].length) == shape &&
                                          columns[index + 2].elementAtOrNull(columns[index].length + 1) == shape) {
                                        line =
                                            "${index - 1},${columns[index].length - 2},${index + 2},${columns[index].length + 1},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (same dir but second from right)
                                      else if (index > 1 &&
                                          index < 9 &&
                                          columns[index].length > 2 &&
                                          columns[index - 2].elementAtOrNull(columns[index].length - 3) == shape &&
                                          columns[index - 1].elementAtOrNull(columns[index].length - 2) == shape &&
                                          columns[index + 1].elementAtOrNull(columns[index].length) == shape) {
                                        line =
                                            "${index - 2},${columns[index].length - 3},${index + 1},${columns[index].length},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (top right to bottom left)
                                      else if (index > 2 &&
                                          columns[index].length > 3 &&
                                          columns[index - 1].elementAtOrNull(columns[index].length - 2) == shape &&
                                          columns[index - 2].elementAtOrNull(columns[index].length - 3) == shape &&
                                          columns[index - 3].elementAtOrNull(columns[index].length - 4) == shape) {
                                        // There is a 4 in a row diagonally top right to bottom left
                                        line =
                                            "$index,${columns[index].length - 1},${index - 3},${columns[index].length - 4},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (top left to bottom right)
                                      else if (index < 7 &&
                                          columns[index].length > 3 &&
                                          columns[index + 1].elementAtOrNull(columns[index].length - 2) == shape &&
                                          columns[index + 2].elementAtOrNull(columns[index].length - 3) == shape &&
                                          columns[index + 3].elementAtOrNull(columns[index].length - 4) == shape) {
                                        // There is a 4 in a row diagonally top left to bottom right
                                        line =
                                            "$index,${columns[index].length - 1},${index + 3},${columns[index].length - 4},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (same dir but second from left)
                                      else if (index > 0 &&
                                          index < 8 &&
                                          columns[index].length > 2 &&
                                          columns[index - 1].elementAtOrNull(columns[index].length) == shape &&
                                          columns[index + 1].elementAtOrNull(columns[index].length - 2) == shape &&
                                          columns[index + 2].elementAtOrNull(columns[index].length - 3) == shape) {
                                        line =
                                            "${index - 1},${columns[index].length},${index + 2},${columns[index].length - 3},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (same dir but second from right)
                                      else if (index > 1 &&
                                          index < 9 &&
                                          columns[index].length > 1 &&
                                          columns[index - 2].elementAtOrNull(columns[index].length + 1) == shape &&
                                          columns[index - 1].elementAtOrNull(columns[index].length) == shape &&
                                          columns[index + 1].elementAtOrNull(columns[index].length - 2) == shape) {
                                        line =
                                            "${index - 2},${columns[index].length + 1},${index + 1},${columns[index].length - 2},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      // Diagonally (bottom right to top left)
                                      else if (index > 2 &&
                                          columns[index - 1].elementAtOrNull(columns[index].length) == shape &&
                                          columns[index - 2].elementAtOrNull(columns[index].length + 1) == shape &&
                                          columns[index - 3].elementAtOrNull(columns[index].length + 2) == shape) {
                                        // There is a 4 in a row diagonally top right to bottom left
                                        line =
                                            "$index,${columns[index].length - 1},${index - 3},${columns[index].length + 2},${moves.last.length == 4 ? moves.length : moves.length - 1},${moves.last.length == 4 ? 0 : moves.last.length}";
                                      }
                                      if (moves.last.length == 4) {
                                        setState(() {
                                          moves.add({
                                            turnOrder[playerIndex]: index,
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          moves.last[turnOrder[playerIndex]] = index;
                                        });
                                      }
                                      if (line != null) {
                                        // There is a 4 in a row
                                        results.add(turnOrder[playerIndex]);
                                        setState(() {
                                          lines.add(Line.fromString(line!));
                                        });
                                        if (results.length == 3) {
                                          // End game now
                                          String lastShape = turnOrder.where((e) => !results.contains(e)).single;
                                          results.add(lastShape);
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            firestore.collection("passPlay").add({
                                              "time": FieldValue.serverTimestamp(),
                                              "results": results,
                                              "host": provider(context).user!.ref,
                                              "lines": lines.map((e) => e.string()).toList(),
                                              "ties": ties,
                                              "moves": moves,
                                            });
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      }
                                      setState(() {
                                        playerIndex = (playerIndex + 1) % 4;
                                      });
                                    }
                                  },
                                ),
                              )
                            : blank,
                      ),
                    ),
                  ),
                ),
                ...turnOrder.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Image.asset("assets/$e.png"),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          AppLocalizations.of(context)!.nthPlayer(turnOrder.indexOf(e) + 1),
                          textScaler: TextScaler.linear(provider(context).tsf),
                          style: TextStyle(
                            fontWeight: turnOrder.indexOf(e) == playerIndex ? FontWeight.bold : FontWeight.normal,
                            fontSize: turnOrder.indexOf(e) == playerIndex ? 20.0 : 17.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Text(
                  AppLocalizations.of(context)!.results,
                  textScaler: TextScaler.linear(provider(context).tsf),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 20.0,
                  ),
                ),
                ...results.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: Image.asset("assets/$e.png"),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          AppLocalizations.of(context)!.nthPlayer(turnOrder.indexOf(e) + 1),
                          textScaler: TextScaler.linear(provider(context).tsf),
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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

  String string() {
    return "${points[0][0]},${points[0][1]},${points[1][0]},${points[1][1]},$moveIndex,$turnIndex";
  }
}

class BoardPainter extends CustomPainter {
  BuildContext context;
  final List<dynamic> turns;
  final List<Line> lines; // Show line when 4 in a row made

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
    for (Line line in lines) {
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
    return turns != oldDelegate.turns;
  }
}
