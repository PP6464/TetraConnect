import 'package:flutter/material.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(provider(context).user!.photoUrl),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
