import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/models/post/post.dart';

class PostModel{
  static var postCollection =
  FirebaseFirestore.instance.collection(Constants.COLLECTION_POST);

  static Stream<QuerySnapshot> getAllPost() {
    return postCollection
        .orderBy("timestamp")
        .snapshots();
  }

  static getPostById(String postId) async {
    var document = await postCollection
        .doc(postId)
        .get();
    return Post.fromDocument(document);
  }
  static void like(String userId, String postId){
    postCollection.doc(postId).update({'likes.$userId': true});
  }

  static void unLike(String userId, String postId){
    postCollection.doc(postId).update({
      'likes.$userId': false
    });
  }
}