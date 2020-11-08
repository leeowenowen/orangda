import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orangda/common/utils/preferences.dart';
import 'package:orangda/models/user.dart';
import 'package:orangda/models/user/user_model.dart';
import 'package:orangda/ui/account/login_page.dart';

class AccountService {
  static auth.FirebaseAuth _auth;
  static User _currentUser;

  static init() {
    _auth = auth.FirebaseAuth.instance;
    loadUser();
  }

  static User currentUser() {
    return _currentUser;
  }

  static logout() async {
    await _auth.signOut();
    _currentUser = null;
    Prefs.instance().setString('userId', "");
  }

  static Future<void> _setCurrentUser(auth.UserCredential authUser) async {
    User user = User.fromAuthUser(authUser);
    await UserModel.createUser(user);
    await Prefs.instance().setString('userId', user.id);
    _currentUser = user;
  }

  static Future<void> loadUser() async {
    String userId = Prefs.instance().getString('userId');
    if (userId != null && userId.isNotEmpty) {
      DocumentSnapshot documentSnapshot = await UserModel.getUserById(userId);
      if (documentSnapshot.data() != null) {
        _currentUser = User.fromDocument(documentSnapshot);
      }
    }
  }
  //should always use this
  static Function doIfSignIn(BuildContext context, Function doSth) {
    return () {
      if (currentUser() != null) {
        doSth();
      } else {
        Navigator.of(context).pushNamed(LoginPage.ROUTE).then((user) {
          if (currentUser() != null) {
            doSth();
          }
        });
      }
    };
  }
  // only used in login page
  static Future<void> signInWithGoogle() async {
    try {
      auth.UserCredential userCredential;
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final auth.GoogleAuthCredential googleAuthCredential =
          auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);

     await  _setCurrentUser(userCredential);

      // Fluttertoast.showToast(msg: 'Login success!');
    } catch (e) {
      print(e);
      // Fluttertoast.showToast(msg: 'Login failed!');
    }
  }

  static Future<void> signInWithFacebook() async {
    try {
      String accessToken;
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          accessToken = result.accessToken.token;
          break;
        case FacebookLoginStatus.cancelledByUser:
          Fluttertoast.showToast(msg: 'Login cancelled!');
          return;
        case FacebookLoginStatus.error:
          Fluttertoast.showToast(msg: 'Login failed with msg:' + result.errorMessage);
          return;
        default:
          Fluttertoast.showToast(msg: 'Login failed with default handler!');
          return;
      }
      final auth.AuthCredential authCredential =
          auth.FacebookAuthProvider.credential(accessToken);
      final auth.UserCredential userCredential =
          (await _auth.signInWithCredential(authCredential));
      await _setCurrentUser(userCredential);
      // Fluttertoast.showToast(msg: 'Login success!');
    } catch (e) {
      print(e);
      // Fluttertoast.showToast(msg: 'Login failed!');
    }
  }
}
