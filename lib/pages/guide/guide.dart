import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/provider/app.settings.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.home),
      body: const Text("Guide"),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => route.home.widget,
            ),
          );
        },
        child: Row(
          children: [
            const Icon(
              Icons.home,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0),
            Text(
              AppLocalizations.of(context)!.continueToHome,
              textScaleFactor: provider(context).tsf,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
