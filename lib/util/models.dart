import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './api.dart';

class User {
  final String uid;
  final DocumentReference ref;
  String email;
  String displayName;
  String photoUrl;
  int rating;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.rating,
    required this.ref,
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
    if (changes.containsKey("rating")) {
      rating = changes["rating"];
    }
    await firestore.doc("users/$uid").update(changes);
  }

  static Future<User> fromUID(String uid) async {
    final DocumentSnapshot userData = await firestore.doc("users/$uid").get();
    if (!userData.exists) {
      throw Exception("User doesn't exist");
    }
    return User(
      displayName: userData["displayName"],
      email: userData["email"],
      photoUrl: userData["photoUrl"],
      rating: userData["rating"],
      ref: userData.reference,
      uid: uid,
    );
  }

  double tanh(double x) {
    return (exp(x) - exp(-x))/(exp(x) + exp(-x));
  }

  Future<void> updateRating ({required int result}) async {
    List<int> rankingDeltas = [10, 5, -5, -10];
    int newRating = rating + rankingDeltas[result];
    if (newRating < 0) newRating = 0;
    await ref.update({
      "rating": newRating,
    });
  }
}
