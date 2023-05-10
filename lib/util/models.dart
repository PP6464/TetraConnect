import 'package:cloud_firestore/cloud_firestore.dart';

import './api.dart';

class User {
  final String uid;
  String email;
  String displayName;
  String photoUrl;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  update(Map<String, dynamic> changes) async {
    if (changes.containsKey("email")) {
      email = changes["email"];
      await auth.currentUser!.updateEmail(email);
    }
    if (changes.containsKey("displayName")) {
      displayName = changes["displayName"];
      await auth.currentUser!.updateDisplayName(displayName);
    }
    if (changes.containsKey("photoUrl")) {
      photoUrl = changes["photoUrl"];
      await auth.currentUser!.updatePhotoURL(photoUrl);
    }
    await firestore.doc("users/$uid").update(changes);
  }

  static Future<User> fromUID(String uid) async {
    final DocumentSnapshot userRef = await firestore.doc("users/$uid").get();
    return User(
      displayName: userRef["displayName"],
      email: userRef["email"],
      photoUrl: userRef["photoUrl"],
      uid: uid,
    );
  }
}
