// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/util/api.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';
import '../../provider/app.settings.dart';

class IncomingFriendRequestPage extends StatefulWidget {
  const IncomingFriendRequestPage({Key? key}) : super(key: key);

  @override
  State<IncomingFriendRequestPage> createState() => _IncomingFriendRequestPageState();
}

class _IncomingFriendRequestPageState extends State<IncomingFriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
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
                AppLocalizations.of(context)!.incomingFriendRequests,
                textScaler: TextScaler.linear(provider(context).tsf),
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500.0,
                  maxHeight: 500.0,
                ),
                child: StreamBuilder(
                  stream: firestore.collection("friends").where("to", isEqualTo: provider(context).user!.ref).where("state", isEqualTo: "pending").snapshots(),
                  builder: (context, snapshot) => asyncBuilder(
                    context,
                    snapshot,
                    (data) {
                      return data.docs.isEmpty
                          ? Text(
                              AppLocalizations.of(context)!.noIncomingRequests,
                              textScaler: TextScaler.linear(provider(context).tsf),
                            )
                          : ListView.builder(
                              itemCount: data.docs.length,
                              itemBuilder: (BuildContext context, int index) => StreamBuilder<DocumentSnapshot>(
                                stream: (data.docs[index]["from"] as DocumentReference).snapshots(),
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            tooltip: AppLocalizations.of(context)!.accept,
                                            onPressed: () async {
                                              await data.docs[index].reference.update({
                                                "state": "accepted",
                                              });
                                              Dio().patch(
                                                "$apiUrl/friend-request/accept/${data.docs[index].id}",
                                                queryParameters: {
                                                  "acceptedBy": provider(context).user!.uid,
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.check),
                                          ),
                                          const SizedBox(width: 8.0),
                                          IconButton(
                                            tooltip: AppLocalizations.of(context)!.reject,
                                            onPressed: () async {
                                              await data.docs[index].reference.delete();
                                              Dio().patch(
                                                "$apiUrl/friend-request/reject/${data.docs[index].id}",
                                                queryParameters: {
                                                  "rejectedBy": provider(context).user!.uid,
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.clear),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
