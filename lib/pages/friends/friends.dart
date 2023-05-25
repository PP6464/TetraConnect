import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/pages/friends/chat.with.friends.dart';
import 'package:tetraconnect/pages/friends/incoming.friend.requests.dart';
import 'package:tetraconnect/pages/friends/pending.friend.requests.dart';
import 'package:tetraconnect/pages/friends/remove.friend.dart';
import 'package:tetraconnect/pages/friends/send.friend.request.dart';

import '../../util/route.dart';
import '../../ui/elements.dart';
import '../../provider/app.settings.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: min(500.0, MediaQuery.of(context).size.width),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    AppLocalizations.of(context)!.friends,
                    textScaleFactor: provider(context).tsf,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatWithFriendsPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(Icons.message),
                        title: Text(
                          AppLocalizations.of(context)!.chatWithFriends,
                          textScaleFactor: provider(context).tsf,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RemoveFriendPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(Icons.delete),
                        title: Text(
                          AppLocalizations.of(context)!.removeFriend,
                          textScaleFactor: provider(context).tsf,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SendFriendRequest(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(Icons.send),
                        title: Text(
                          AppLocalizations.of(context)!.sendFriendRequest,
                          textScaleFactor: provider(context).tsf,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const IncomingFriendRequestPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(Icons.call_received),
                        title: Text(
                          AppLocalizations.of(context)!.incomingFriendRequests,
                          textScaleFactor: provider(context).tsf,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PendingFriendRequestsPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: const Icon(Icons.pending_actions),
                        title: Text(
                          AppLocalizations.of(context)!.pendingFriendRequests,
                          textScaleFactor: provider(context).tsf,
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
