import 'package:flutter/material.dart';

import '../../ui/elements.dart';
import '../../util/route.dart';

class FriendChatPage extends StatefulWidget {
  final String friendId;
  const FriendChatPage({super.key, required this.friendId});

  @override
  State<FriendChatPage> createState() => _FriendChatPageState();
}

class _FriendChatPageState extends State<FriendChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.friends),
    );
  }
}
