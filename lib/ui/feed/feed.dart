import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orangda/common/utils/font_util.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/widgets/image_post.dart';

import '../../common/constants/constants.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> {
  List<ImagePost> feedData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.BACKGROUND,
        appBar: AppBar(
          title: FontUtil.makeTitle(),
          centerTitle: true,
        ),
        body: _buildFeed());
  }

  Widget _buildFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.size > 0) {
          return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data.docs[index];
                final ImagePost imagePost = ImagePost.fromDocument(doc);
                return imagePost;
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Stream<QuerySnapshot> _fetchPosts() {
    return FirebaseFirestore.instance
        .collection(Constants.COLLECTION_POSTS)
        .orderBy("timestamp")
        .snapshots();
  }
}
