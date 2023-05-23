import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util/route.dart';
import '../../ui/elements.dart';
import '../../provider/app.settings.dart';
import '../../util/api.dart';

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

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController searchUser = TextEditingController();
  SearchOption searchOption = SearchOption.name;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SingleChildScrollView(
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
                        List<QueryDocumentSnapshot> users = data.docs.where((element) => searchOption == SearchOption.name ? element["displayName"] == searchUser.text : element.id == searchUser.text).toList();
                        return SizedBox(
                          height: 500.0,
                          child: ListView.builder(
                            itemExtent: 50.0,
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                stream: firestore.collection("friends").where("users", arrayContains: provider(context).user!.ref).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                                  context,
                                  snapshot,
                                  (data) {
                                    return data.docs.where((element) => element["users"].contains()).isEmpty
                                        ? Card(
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
                                                onPressed: () async {},
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
      SingleChildScrollView(
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
                textScaleFactor: provider(context).tsf,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      SingleChildScrollView(
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
                textScaleFactor: provider(context).tsf,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.send),
            tooltip: AppLocalizations.of(context)!.sendFriendRequest,
            label: AppLocalizations.of(context)!.sendFriendRequest,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.call_received),
            tooltip: AppLocalizations.of(context)!.incomingFriendRequests,
            label: AppLocalizations.of(context)!.incomingFriendRequests,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pending_actions),
            tooltip: AppLocalizations.of(context)!.pendingFriendRequests,
            label: AppLocalizations.of(context)!.pendingFriendRequests,
          ),
        ],
        onTap: (int newIndex) {
          setState(() {
            pageIndex = newIndex;
          });
        },
        currentIndex: pageIndex,
      ),
    );
  }
}
