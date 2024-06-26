import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_bar_chart/fine_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tetraconnect/provider/app.settings.dart';
import 'package:tetraconnect/ui/theme.dart';
import 'package:tetraconnect/util/api.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: Center(
        child: FutureBuilder(
          future: firestore.collection("games").get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> games) => asyncBuilder(
            context,
            games,
            (data) {
              List<QueryDocumentSnapshot> userGames = data.docs.where((element) => (element["players"] as Map).values.contains(provider(context).user!.ref)).toList();
              List<int> userGameResults = userGames.map((e) {
                if ((e.data() as Map)["ties"] == null || e["results"].indexOf(provider(context).user!.ref) <= 2 - e["ties"]) return e["results"].indexOf(provider(context).user!.ref) as int;
                return 3 - e["ties"] as int;
              }).toList();
              int n1 = userGameResults.where((element) => element == 0).length;
              int n2 = userGameResults.where((element) => element == 1).length;
              int n3 = userGameResults.where((element) => element == 2).length;
              int n4 = userGameResults.where((element) => element == 3).length;
              return SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: min(500.0, MediaQuery.of(context).size.width),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              foregroundImage: NetworkImage(provider(context).user!.photoUrl),
                              radius: 90.0,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.statistics,
                            textScaler: TextScaler.linear(provider(context).tsf),
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.rating(provider(context).user!.rating),
                            textScaler: TextScaler.linear(provider(context).tsf),
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDarkMode(context) ? Colors.grey : Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.results,
                            textScaler: TextScaler.linear(provider(context).tsf),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          FineBarChart(
                            isBottomNameDisable: false,
                            isValueDisable: false,
                            barValue: [n1, n2, n3, n4].map((e) => e.toDouble()).toList(),
                            barColors: [
                              theme.red.colour,
                              theme.pink.colour,
                              theme.green.colour,
                              theme.blue.colour,
                            ],
                            barWidth: 30,
                            backgroundColors: isDarkMode(context) ? theme.darkSurface.colour : theme.lightSurface.colour,
                            barBottomName: [
                              AppLocalizations.of(context)!.first,
                              AppLocalizations.of(context)!.second,
                              AppLocalizations.of(context)!.third,
                              AppLocalizations.of(context)!.fourth,
                            ],
                            barHeight: 300.0,
                            barBackgroundColors: Colors.grey.withOpacity(0.3),
                            textStyle: TextStyle(
                              fontSize: 15.0 * provider(context).tsf,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          PieChart(
                            dataMap: {
                              AppLocalizations.of(context)!.first: n1.toDouble(),
                              AppLocalizations.of(context)!.second: n2.toDouble(),
                              AppLocalizations.of(context)!.third: n3.toDouble(),
                              AppLocalizations.of(context)!.fourth: n4.toDouble(),
                            },
                            chartRadius: 100.0,
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                              chartValueStyle: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 13.5,
                                color: Colors.black,
                              ),
                              decimalPlaces: 1,
                              showChartValuesOutside: true,
                            ),
                            colorList: [
                              theme.red.colour,
                              theme.pink.colour,
                              theme.green.colour,
                              theme.blue.colour,
                            ],
                            baseChartColor: Colors.grey,
                            chartType: ChartType.ring,
                          ),
                          const SizedBox(height: 32.0),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
