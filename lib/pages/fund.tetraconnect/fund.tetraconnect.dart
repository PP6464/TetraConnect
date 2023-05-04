import 'package:flutter/material.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class FundTetraConnectPage extends StatefulWidget {
  const FundTetraConnectPage({Key? key}) : super(key: key);

  @override
  State<FundTetraConnectPage> createState() => _FundTetraConnectPageState();
}

class _FundTetraConnectPageState extends State<FundTetraConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.home),
      body: const Text("Fund TetraConnect"),
    );
  }
}
