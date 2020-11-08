import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String email;
  String id;
  final String photoUrl;
  final String providerId;
  final String username;
  final String displayName;
  final String phoneNumber;
  final String provider;
  final String bio;
  final Map followers;
  final Map following;

   User(
      {this.username,
      this.id,
      this.photoUrl,
      this.providerId,
      this.email,
      this.displayName,
      this.phoneNumber,
      this.provider,
      this.bio,
      this.followers,
      this.following});

  // no user id here, it'll generate by database insert operation
  factory User.fromAuthUser(auth.UserCredential credential) {
    auth.User authUser = credential.user;
    return User(
      email: authUser.email,
      username: credential.additionalUserInfo.username,
      photoUrl: authUser.photoURL,
      providerId: authUser.uid,
      displayName: authUser.displayName,
      phoneNumber: authUser.phoneNumber,
      provider: credential.additionalUserInfo.providerId,
      bio: '',
      followers: {},
      following: {},
    );
  }

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      id: document.id,
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      providerId: document['providerId'],
      displayName: document['displayName'],
      phoneNumber: document['phoneNumber'],
      provider: document['provider'],
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
    );
  }
}
