import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';
import '../../provider/app.settings.dart';

class PendingFriendRequestsPage extends StatefulWidget {
  const PendingFriendRequestsPage({Key? key}) : super(key: key);

  @override
  State<PendingFriendRequestsPage> createState() => _PendingFriendRequestsState();
}

class _PendingFriendRequestsState extends State<PendingFriendRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  foregroundImage: NetworkImage(provider(context).user!.photoUrl),
                  radius: 90.0,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.pendingFriendRequests,
                textScaler: TextScaler.linear(provider(context).tsf),
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}