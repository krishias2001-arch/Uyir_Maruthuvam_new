import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FCMService {

  static Future<void> saveToken() async {

    String? token = await FirebaseMessaging.instance.getToken();

    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      "fcmToken": token
    }, SetOptions(merge: true));
  }
}