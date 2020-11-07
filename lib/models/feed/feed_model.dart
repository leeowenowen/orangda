import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/constants/constants.dart';

import '../user.dart';

class FeedModel {
  static void addPostLike(String postId, String mediaUrl, User user) {
    FirebaseFirestore.instance
        .collection(Constants.COLLECTION_FEED)
        .doc(user.id)
        .collection("items")
        .doc(postId)
        .set({
      "username": user.username,
      "userId": user.id,
      "type": "like",
      "userProfileImg": user.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": DateTime.now(),
      "postId": postId,
    });
  }

  static void removeActivityFeedItem(String userId, String postId) {
    FirebaseFirestore.instance
        .collection(Constants.COLLECTION_FEED)
        .doc(userId)
        .collection("items")
        .doc(postId)
        .delete();
  }
}
