import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/elements.dart';
import '../../util/api.dart';
import '../../util/route.dart';
import '../../provider/app.settings.dart';
import 'friend.chat.page.dart';

class ChatWithFriendsPage extends StatefulWidget {
  const ChatWithFriendsPage({Key? key}) : super(key: key);

  @override
  State<ChatWithFriendsPage> createState() => _ChatWithFriendsPageState();
}

class _ChatWithFriendsPageState extends State<ChatWithFriendsPage> {
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
                AppLocalizations.of(context)!.chatWithFriends,
                textScaler: TextScaler.linear(provider(context).tsf),
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder(
                stream: firestore
                    .collection("friends")
                    .where(
                      "users",
                      arrayContains: provider(context).user!.ref,
                    )
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                  context,
                  snapshot,
                  (friends) => Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500.0,
                      maxHeight: 500.0,
                    ),
                    child: friends.docs.isEmpty
                        ? Text(
                            AppLocalizations.of(context)!.noChatFriends,
                            textScaler: TextScaler.linear(provider(context).tsf),
                          )
                        : ListView.builder(
                            itemCount: friends.docs.length,
                            itemBuilder: (BuildContext context, int index) => StreamBuilder(
                              stream: friends.docs[index]["users"].singleWhere((elem) => elem.id != provider(context).user!.uid).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                                context,
                                snapshot,
                                (user) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => FriendChatPage(
                                          friendId: friends.docs[index].id,
                                          otherUser: user.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: NetworkImage(user["photoUrl"]),
                                      ),
                                      title: Text(
                                        user["displayName"],
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                      subtitle: Text(
                                        user.id,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
