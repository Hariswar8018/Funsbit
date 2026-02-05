

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SaveToken {
  static Future<void> registerUserFCMToken(String userId) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Android 13+ permission
      await messaging.requestPermission();

      final String? token = await messaging.getToken();

      if (token == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
          'fcmToken': token,
        },
      );

      print("FCM Token saved for user $userId");
    } catch (e) {
      print("FCM token error: $e");
    }
  }

}