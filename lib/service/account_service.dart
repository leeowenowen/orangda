import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orangda/common/utils/notification_util.dart';
import 'package:orangda/models/user.dart';

import '../main.dart';
import '../ui/account/set_account_info_page.dart';

class AccountService {
  static auth.FirebaseAuth _auth;
  static GoogleSignIn _googleSignIn;
  static User _currentUserModel;

  static init() {
    _auth = auth.FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
  }

  static auth.FirebaseAuth firebaseAuth() {
    return _auth;
  }

  static GoogleSignIn googleSignIn() {
    return _googleSignIn;
  }

  static setCurrentUser(User user) {
    _currentUserModel = user;
  }

  static User currentUser() {
    return _currentUserModel;
  }

  static logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUserModel = null;
  }

  static Future<bool> ensureLoggedIn(BuildContext context) async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) {
      user = await _googleSignIn.signInSilently();
    }
    if (user == null) {
      await _googleSignIn.signIn();
      await tryCreateUserRecord(context);
    }

    if (await _auth.currentUser == null) {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      NotificationUtil.setUpNotifications();
    }
    return _currentUserModel != null;

  }

  static Future<bool> silentLogin(BuildContext context) async {
    GoogleSignInAccount user = _googleSignIn.currentUser;

    if (user == null) {
      user = await _googleSignIn.signInSilently();
      await tryCreateUserRecord(context);
    }

    if (await _auth.currentUser == null && user != null) {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    }
    return _currentUserModel != null;
  }

  static Future<void> tryCreateUserRecord(BuildContext context) async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) {
      return null;
    }
    DocumentSnapshot userRecord = await ref.document(user.id).get();
    if (userRecord.data == null) {
      // no user record exists, time to create

      String userName = await Navigator.of(context).pushNamed(
        SetAccountInfoPage.ROUTE,
      );

      if (userName != null || userName.length != 0) {
        ref.document(user.id).setData({
          "id": user.id,
          "username": userName,
          "photoUrl": user.photoUrl,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "followers": {},
          "following": {},
        });
      }
      userRecord = await ref.document(user.id).get();
    }

    User currentUser = User.fromDocument(userRecord);
    AccountService.setCurrentUser(currentUser);
    currentUserModel = currentUser;
    return null;
  }
}
