import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/utils/time_util.dart';

class Post{
  final List<String> images2;
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
      {this.images2,
        this.mediaUrl,
        this.username,
        this.location,
        this.description,
        this.likes,
        this.postId,
        this.ownerId,
        this.postTime}){
    likeCount = getLikeCount(likes);
  }
  factory Post.fromDocument(DocumentSnapshot document) {
    Timestamp timestamp = document['timestamp'];
    int timestampmillSeconds = timestamp.millisecondsSinceEpoch;
    return Post(
        username: document['username'],
        location: document['location'],
         images2: document.data()['images'],
        mediaUrl:document.data()['mediaUrl'],
        likes: document['likes'],
        description: document['description'],
        postId: document.id,
        ownerId: document['ownerId'],
        postTime: formatTimestamp(timestampmillSeconds));
  }

  factory Post.fromJSON(Map data) {
    return Post(
      username: data['username'],
      location: data['location'],
      images2: data['images'],
      likes: data['likes'],
      description: data['description'],
      ownerId: data['ownerId'],
      postId: data['postId'],
      postTime: data['timestamp'],
    );
  }

  String coverUrl(){
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