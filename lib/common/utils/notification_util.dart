import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/service/account_service.dart';

class NotificationUtil {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static Future<Null> setUpNotifications() async {
    if (Platform.isAndroid) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );

      _firebaseMessaging.getToken().then((token) {
        print("Firebase Messaging Token: " + token);

        Firestore.instance
            .collection(Constants.COLLECTION_USER)
            .document(AccountService.currentUser().id)
            .updateData({"androidNotificationToken": token});
      });
    }
  }
}
