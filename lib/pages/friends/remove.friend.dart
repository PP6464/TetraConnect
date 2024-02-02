import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/util/api.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';
import '../../provider/app.settings.dart';

class RemoveFriendPage extends StatefulWidget {
  const RemoveFriendPage({Key? key}) : super(key: key);

  @override
  State<RemoveFriendPage> createState() => _RemoveFriendPageState();
}

class _RemoveFriendPageState extends State<RemoveFriendPage> {
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
                AppLocalizations.of(context)!.removeFriends,
                textScaler: TextScaler.linear(provider(context).tsf),
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder(
                stream: firestore
                    .collection("friends")
                    .where("state", isEqualTo: "accepted")
                    .where("users", arrayContains: provider(context).user!.ref)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                  context,
                  snapshot,
                  (friends) {
                    if (friends.docs.isEmpty) {
                      return Text(
                        AppLocalizations.of(context)!.noRemoveFriends,
                        textScaler: TextScaler.linear(provider(context).tsf),
                      );
                    } else {
                      return Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500.0,
                          maxHeight: 500.0,
                        ),
                        child: ListView.builder(
                          itemCount: friends.docs.length,
                          itemBuilder: (BuildContext context, int index) => Card(
                            child: StreamBuilder(
                              stream: (friends.docs[index]["users"])
                                  .singleWhere((element) => element.id != provider(context).user!.uid)
                                  .snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                                context,
                                snapshot,
                                (friend) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: NetworkImage(friend["photoUrl"]),
                                    ),
                                    title: Text(
                                      friend["displayName"],
                                      textScaler: TextScaler.linear(provider(context).tsf),
                                    ),
                                    subtitle: Text(
                                      friend.id,
                                      textScaler: TextScaler.linear(provider(context).tsf),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: AppLocalizations.of(context)!.removeFriend,
                                      onPressed: () async {
                                        await Dio().post(
                                          "$apiUrl/friend/remove",
                                          queryParameters: {
                                            "user": provider(context).user!.uid,
                                            "removed": friend.id,
                                          }
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
