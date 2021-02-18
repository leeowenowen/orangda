import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/utils/time_util.dart';

class Post {
  final List<String> images;
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final Map likes;
  final String postId;
  final String ownerId;
  final String postTime;
  int likeCount;

  Post(
      {this.images,
      this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.ownerId,
      this.postTime}) {
    likeCount = getLikeCount(likes);
  }

  factory Post.fromDocument(DocumentSnapshot document) {
    Timestamp timestamp = document['timestamp'];
    int timestampmillSeconds = timestamp.millisecondsSinceEpoch;
    var images = document.data()['images'];
    String mediaUrl = document.data()['mediaUrl'];
    List<String> imgUrls = List();
    if (images != null) {
      List<dynamic> listImgs = images;
      for (var i = 0; i < listImgs.length; i++) {
        String imgUrl = listImgs[i];
        imgUrls.add(imgUrl);
      }
    }
    if (imgUrls.length > 0) {
      mediaUrl = imgUrls[0];
    }
    return Post(
        username: document['username'],
        location: document['location'],
        images: imgUrls,
        mediaUrl: mediaUrl,
        likes: document['likes'],
        description: document['description'],
        postId: document.id,
        ownerId: document['ownerId'],
        postTime: formatTimestamp(timestampmillSeconds));
  }

  String coverUrl() {
    return mediaUrl;
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }
}
