import 'package:flutter/material.dart';

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
    );
  }
}
