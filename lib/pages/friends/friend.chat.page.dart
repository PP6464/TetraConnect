import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/app.settings.dart';
import '../../util/api.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';

class FriendChatPage extends StatefulWidget {
  final String friendId;
  final String otherUser;

  const FriendChatPage({super.key, required this.friendId, required this.otherUser});

  @override
  State<FriendChatPage> createState() => _FriendChatPageState();
}

class _FriendChatPageState extends State<FriendChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: firestore.doc("users/${widget.otherUser}").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                context,
                snapshot,
                (user) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(user["photoUrl"]),
                    ),
                    Text(
                      user["displayName"],
                      textScaler: TextScaler.linear(provider(context).tsf),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: firestore.collection("users/${widget.friendId}/messages").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                context,
                snapshot,
                (messages) => messages.docs.isEmpty
                    ? Text(
                        AppLocalizations.of(context)!.startConversation,
                        textScaler: TextScaler.linear(provider(context).tsf),
                      )
                    : ListView.builder(
                        itemCount: messages.docs.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                          child: Text(
                            messages.docs[index]["text"],
                            textScaler: TextScaler.linear(provider(context).tsf),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
