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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => route.home.widget,
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.home,
              color: Colors.black,
            ),
            const SizedBox(width: 8.0),
            Text(
              AppLocalizations.of(context)!.continueToHome,
              textScaler: TextScaler.linear(provider(context).tsf),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
