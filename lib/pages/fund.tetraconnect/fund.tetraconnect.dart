import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';

class FundTetraConnectPage extends StatefulWidget {
  const FundTetraConnectPage({Key? key}) : super(key: key);

  @override
  State<FundTetraConnectPage> createState() => _FundTetraConnectPageState();
}

class _FundTetraConnectPageState extends State<FundTetraConnectPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  Future<void> redirect() async {
    if (await canLaunchUrl(Uri.parse("https://buymeacoffee.com/pp16"))) {
      launchUrl(Uri.parse("https://buymeacoffee.com/pp16"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.home),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.fundMessage,
          textScaler: TextScaler.linear(provider(context).tsf),
        ),
      ),
    );
  }
}
