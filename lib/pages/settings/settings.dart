import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double tsf = 1.0;
  ThemeMode uiMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    tsf = provider(context).tsf;
    uiMode = provider(context).uiMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.settings),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.settings,
                  textScaleFactor: provider(context, true).tsf,
                  style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) => asyncBuilder(
                    context,
                    snapshot,
                        (packageInfo) => Text(
                      AppLocalizations.of(context)!.appVersion("${packageInfo.version}+${packageInfo.buildNumber}"),
                      textScaleFactor: provider(context).tsf,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tsf,
                      textScaleFactor: provider(context, true).tsf,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Slider(
                  value: tsf,
                  onChanged: (double value) async {
                    await provider(context).updateTSF(value);
                    setState(() {
                      tsf = value;
                    });
                  },
                  min: tsfMin,
                  max: tsfMax,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.uiMode,
                      textScaleFactor: provider(context, true).tsf,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                ListTile(
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: uiMode,
                    onChanged: (ThemeMode? value) async {
                      await provider(context).updateUIMode(value!);
                      setState(() {
                        uiMode = value;
                      });
                    },
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.light,
                    textScaleFactor: provider(context, true).tsf,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: uiMode,
                    onChanged: (ThemeMode? value) async {
                      await provider(context).updateUIMode(value!);
                      setState(() {
                        uiMode = value;
                      });
                    },
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.dark,
                    textScaleFactor: provider(context, true).tsf,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: uiMode,
                    onChanged: (ThemeMode? value) async {
                      await provider(context).updateUIMode(value!);
                      setState(() {
                        uiMode = value;
                      });
                    },
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.system,
                    textScaleFactor: provider(context, true).tsf,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
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