import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/service/account_service.dart';

import '../user.dart';

class UserModel {
  static final userCollection =
      FirebaseFirestore.instance.collection(Constants.COLLECTION_USER);

  static Future<DocumentSnapshot> getUserById(String userId) {
    return userCollection.doc(userId).get();
  }

  static createUser(User user) async {
    DocumentReference doc = await userCollection.add({
      "username": user.username,
      "providerId": user.providerId,
      "provider": user.provider,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "phoneNumber": user.phoneNumber,
      "displayName": user.displayName,
      "bio": "",
      "followers": {},
      "following": {},
    });
    String docId = doc.id;
    user.id = docId;
    userCollection.doc(docId).update({"id": docId});
  }

  static followUser(String profileId, String currentUserId) {
    FirebaseFirestore.instance
        .doc(Constants.COLLECTION_USER + "/$profileId")
        .update({
      'followers.$currentUserId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance
        .doc(Constants.COLLECTION_USER + "/$currentUserId")
        .update({
      'following.$profileId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    //updates activity feed
    User currentUserModel = AccountService.currentUser();
    FirebaseFirestore.instance
        .collection(Constants.COLLECTION_FEED)
        .doc(profileId)
        .collection("items")
        .doc(currentUserId)
        .set({
      "ownerId": profileId,
      "username": currentUserModel.username,
      "userId": currentUserId,
      "type": "follow",
      "userProfileImg": currentUserModel.photoUrl,
      "timestamp": DateTime.now()
    });
  }

  static unFollowUser(String profileId, String currentUserId) {
    FirebaseFirestore.instance
        .doc(Constants.COLLECTION_USER + "/$profileId")
        .update({
      'followers.$currentUserId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance
        .doc(Constants.COLLECTION_USER + "/$currentUserId")
        .update({
      'following.$profileId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance
        .collection(Constants.COLLECTION_FEED)
        .doc(profileId)
        .collection("items")
        .doc(currentUserId)
        .delete();
  }
}
