import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// Firebase service instances
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Constants
String blankPicUrl = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
String baseStorageUrl = "https://firebasestorage.googleapis.com/v0/b/tetraconnect.appspot.com/o/";
String apiUrl = "https://tetraconnect.onrender.com";
String vapidKey = "BFMjFOmAGy-sdg1Uv_agnN60RaqULlKDhmxzIgUPKhMEM-iu3FylLvuYirIlqV_hPKzRUyB-S_jlwLpram_qCK8";

// OS
String getPlatformName() {
  if (kIsWeb) return "web";
  if (Platform.isWindows) return "windows";
  if (Platform.isAndroid) return "android";
  if (Platform.isFuchsia) return "fuchsia";
  if (Platform.isLinux) return "linux";
  if (Platform.isMacOS) return "macos";
  if (Platform.isIOS) return "ios";
  return "";
}