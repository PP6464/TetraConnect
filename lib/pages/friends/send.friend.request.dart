import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';
import '../../util/api.dart';
import '../../provider/app.settings.dart';

enum SearchOption {
  name,
  uid,
}

extension SendFriendRequestSearchOptionExt on SearchOption {
  String string(BuildContext context) {
    switch (this) {
      case SearchOption.name:
        return AppLocalizations.of(context)!.displayName;
      case SearchOption.uid:
        return AppLocalizations.of(context)!.uid;
    }
  }
}

class SendFriendRequest extends StatefulWidget {
  const SendFriendRequest({Key? key}) : super(key: key);

  @override
  State<SendFriendRequest> createState() => _SendFriendRequestState();
}

class _SendFriendRequestState extends State<SendFriendRequest> {
  TextEditingController searchUser = TextEditingController();
  SearchOption searchOption = SearchOption.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: min(500.0, MediaQuery.of(context).size.width),
              ),
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
                    AppLocalizations.of(context)!.sendFriendRequest,
                    textScaleFactor: provider(context).tsf,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: searchUser,
                    onChanged: (String? value) => setState(() {}),
                    decoration: InputDecoration(
                      label: Text(
                        AppLocalizations.of(context)!.searchForUser,
                      ),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: SearchOption.name,
                        groupValue: searchOption,
                        onChanged: (SearchOption? value) {
                          setState(() {
                            searchOption = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        AppLocalizations.of(context)!.displayName,
                        textScaleFactor: provider(context).tsf,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Radio(
                        value: SearchOption.uid,
                        groupValue: searchOption,
                        onChanged: (SearchOption? value) {
                          setState(() {
                            searchOption = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        AppLocalizations.of(context)!.uid,
                        textScaleFactor: provider(context).tsf,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  StreamBuilder(
                    stream: firestore.collection("users").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                      context,
                      snapshot,
                      (data) {
                        List<QueryDocumentSnapshot> users = data.docs.where((element) => (searchOption == SearchOption.name ? element["displayName"].toLowerCase().contains(searchUser.text.toLowerCase()) : element.id.toLowerCase().contains(searchUser.text.toLowerCase())) && element.id != provider(context).user!.uid).toList();
                        return SizedBox(
                          height: 500.0,
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                stream: firestore.collection("friends").where("users", arrayContains: provider(context).user!.ref).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                                  context,
                                  snapshot,
                                  (data) {
                                    return data.docs.where((element) => element["users"].contains(users[index].reference)).isEmpty
                                        ? SizedBox(
                                      height: 75.0,
                                          child: Card(
                                              elevation: 2.0,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 35.0,
                                                  foregroundImage: NetworkImage(users[index]["photoUrl"]),
                                                ),
                                                title: Text(
                                                  users[index]["displayName"],
                                                  textScaleFactor: provider(context).tsf,
                                                ),
                                                subtitle: Text(
                                                  users[index].id,
                                                  textScaleFactor: provider(context).tsf,
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.send),
                                                  onPressed: () async {
                                                    firestore.collection("friends").add({
                                                      "users": [
                                                        provider(context).user!.ref,
                                                        users[index].reference,
                                                      ],
                                                      "state": "pending",
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                        )
                                        : blank;
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
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
