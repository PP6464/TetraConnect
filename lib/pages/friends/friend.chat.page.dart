import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:profanity_filter/profanity_filter.dart';

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
  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: firestore.doc("users/${widget.otherUser}").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) => asyncBuilder(
                  context,
                  snapshot,
                  (user) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user["photoUrl"]),
                      ),
                      const SizedBox(width: 12.0),
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
            ),
            StreamBuilder(
              stream: firestore
                  .collection("friends/${widget.friendId}/messages")
                  .orderBy("time")
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) => asyncBuilder(
                context,
                snapshot,
                (messages) => messages.docs.isEmpty
                    ? Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.startConversation,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: messages.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            QueryDocumentSnapshot message = messages.docs[index];
                            DateTime time = message["time"].toDate();
                            return Align(
                              alignment: message["user"].id == provider(context).user!.uid ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 0.8 * MediaQuery.of(context).size.width,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Card(
                                    color: message["user"].id == provider(context).user!.uid ? Colors.white : Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.timestamp(
                                              time.hour.toString().padLeft(2, '0'),
                                              time.minute.toString().padLeft(2, '0'),
                                              time.day.toString().padLeft(2, '0'),
                                              time.month.toString().padLeft(2, '0'),
                                              time.year.toString().padLeft(2, '0'),
                                            ),
                                            textScaler: TextScaler.linear(provider(context).tsf),
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          Text(
                                            messages.docs[index]["text"],
                                            textScaler: TextScaler.linear(provider(context).tsf),
                                            style: TextStyle(
                                              color: message["user"].id == provider(context).user!.uid ? Colors.black : Colors.white,
                                            ),
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
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: message,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return AppLocalizations.of(context)!.messageRequired;
                    if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.messageNoProfanity;
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.sendMessage,
                      textScaler: TextScaler.linear(provider(context).tsf),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                      child: Icon(Icons.message),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      tooltip: AppLocalizations.of(context)!.sendMessage,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        await Dio().post(
                          "$apiUrl/friend/message",
                          queryParameters: {
                            "user": provider(context).user!.uid,
                            "friend": widget.friendId,
                            "text": message.text,
                          },
                        );
                        await (AudioPlayer()..audioCache = AudioCache(prefix: "")).play(AssetSource("assets/sent_comment.wav"));
                        setState(() {
                          message.clear();
                        });
                      },
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
