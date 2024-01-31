import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/util/api.dart';

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
              const SizedBox(height: 8.0),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 500.0,
                  maxWidth: 500.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection("friends").where("from", isEqualTo: provider(context).user!.ref).where("state", isEqualTo: "pending").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return asyncBuilder(
                        context,
                        snapshot,
                        (data) {
                          return data.docs.isNotEmpty
                              ? ListView.builder(
                                  itemCount: data.docs.length,
                                  itemBuilder: (BuildContext context, int index) => StreamBuilder(
                                    stream: (data.docs[index]["users"].singleWhere((element) => element.id != provider(context).user!.uid) as DocumentReference).snapshots(),
                                    builder: (context, snapshot) => asyncBuilder(
                                      context,
                                      snapshot,
                                      (userData) => Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: NetworkImage(userData["photoUrl"]),
                                          ),
                                          title: Text(
                                            userData["displayName"],
                                            textScaler: TextScaler.linear(provider(context).tsf),
                                          ),
                                          subtitle: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              userData.id,
                                              textScaler: TextScaler.linear(provider(context).tsf),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            tooltip: AppLocalizations.of(context)!.deleteFriendRequest,
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              await data.docs[index].reference.delete();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.noPendingRequests,
                                  textScaler: TextScaler.linear(provider(context).tsf),
                                );
                        },
                      );
                    },
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
