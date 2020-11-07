import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/models/feed/feed_model.dart';
import 'package:orangda/models/post/post.dart';
import 'package:orangda/models/post/post_model.dart';
import 'package:orangda/models/user/user_model.dart';
import 'package:orangda/service/account_service.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/account/profile_page.dart';
import 'package:orangda/ui/comment/comment_page.dart';

class ImagePost extends StatefulWidget {
  final Post post;

  const ImagePost(this.post);

  _ImagePost createState() => _ImagePost(
        this.post,
      );
}

class _ImagePost extends State<ImagePost> {
  final Post post;
  bool showHeart = false;
  var reference =
      FirebaseFirestore.instance.collection(Constants.COLLECTION_POST);

  _ImagePost(this.post);

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;
    if (liked()) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(post.postId);
        });
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => _likePost(post.postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: post.coverUrl(),
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          showHeart
              ? Positioned(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Opacity(
                        opacity: 0.85,
                        child: FlareActor(
                          "assets/flare/Like.flr",
                          animation: "Like",
                        )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("Someone", style: TextStyle(color: MyColors.MAIN_TEXT_COLOR));
    }

    return FutureBuilder(
        future: UserModel.getUserById(ownerId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            var data = snapshot.data.data();
            return Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(data['photoUrl']),
                  backgroundColor: Colors.grey,
                ),
                title: GestureDetector(
                  child: Text(data['username'],
                      style: TextStyle(
                          color: MyColors.MAIN_TEXT_COLOR,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfilePage.ROUTE,
                        arguments: {'userId': ownerId});
                  },
                ),
                subtitle: Row(children: [
                  IconTheme(
                    data: IconThemeData(size: 15, color: Colors.blue),
                    child: Icon(Icons.location_on),
                  ),
                  Text(this.post.location,
                      style: TextStyle(color: MyColors.MAIN_TEXT_COLOR)),
                ]),
                trailing: const Icon(Icons.more_vert),
              ),
            );
          }

          // snapshot data is null here
          return Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                child: Text('Someone',
                    style: TextStyle(
                        color: MyColors.MAIN_TEXT_COLOR,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.of(context).pushNamed(ProfilePage.ROUTE,
                      arguments: {'userId': ownerId});
                },
              ),
              subtitle: Row(children: [
                IconTheme(
                  data: IconThemeData(size: 15, color: Colors.blue),
                  child: Icon(Icons.location_on),
                ),
              ]),
              trailing: const Icon(Icons.more_vert),
            ),
          );
        });
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  Widget buildDesc(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
            child: Text(post.description,
                style: TextStyle(
                  color: MyColors.MAIN_TEXT_COLOR,
                  fontSize: 15,
                ))),
      ],
    );
  }

  Widget buildComment(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
        buildLikeIcon(),
        Padding(padding: const EdgeInsets.only(right: 20.0)),
        GestureDetector(
            child: const Icon(
              FontAwesomeIcons.comment,
              size: 25.0,
            ),
            onTap: () {
              goToComments(
                  context: context,
                  postId: post.postId,
                  ownerId: post.ownerId,
                  mediaUrl: post.coverUrl());
            }),
        Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(post.postTime,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12))))
      ],
    );
  }

  Widget buildLikeCount(BuildContext context) {
    int likeCount = post.likeCount;
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 20.0),
          child: Text(
            "$likeCount likes",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MyColors.BACKGROUND,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildPostHeader(ownerId: post.ownerId),
            buildDesc(context),
            buildLikeableImage(),
            buildComment(context),
            buildLikeCount(context)
          ],
        ));
  }

  bool liked(){
    if( AccountService.googleSignIn().currentUser == null){
      return false;
    }
    var userId = AccountService.googleSignIn().currentUser.id;
    return post.likes[userId];
  }

  void _likePost(String postId2) {
    var userId = AccountService.googleSignIn().currentUser.id;
    bool _liked = liked();

    if (_liked) {
      print('removing like');
      PostModel.unLike(userId, post.postId);
      setState(() {
        post.likeCount = post.likeCount - 1;
        post.likes[userId] = false;
      });
      FeedModel.removeActivityFeedItem(post.ownerId, post.postId);
    }else{
      print('liking');
      PostModel.like(userId, post.postId);
      FeedModel.addPostLike(
          post.postId, post.coverUrl(), AccountService.currentUser());
      setState(() {
        post.likeCount = post.likeCount + 1;
        post.likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }
}

class ImagePostFromId extends StatelessWidget {
  final String id;

  const ImagePostFromId({this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PostModel.getPostById(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          return snapshot.data;
        });
  }
}

void goToComments(
    {BuildContext context, String postId, String ownerId, String mediaUrl}) {
  Navigator.of(context).pushNamed(CommentPage.ROUTE, arguments: {
    'postId': postId,
    'postOwner': ownerId,
    'postMediaUrl': mediaUrl,
  });
}
