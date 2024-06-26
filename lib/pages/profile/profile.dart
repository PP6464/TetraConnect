import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/pages/profile/game.log.dart';
import 'package:tetraconnect/pages/profile/statistics.dart';

import 'account.dart';
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    AppLocalizations.of(context)!.profile,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.yourID(provider(context).user!.uid),
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDarkMode(context) ? Colors.grey : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          size: 40.0,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.account,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.accountDesc,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GameLogPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.history,
                          size: 40.0,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.gameLog,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.gameLogDesc,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const StatisticsPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.stacked_bar_chart,
                          size: 40.0,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.statistics,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.statisticsDesc,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
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
