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
          title: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
              Image.asset('assets/logo.png', width: 40,),
              FontUtil.makeTitle(),]
          ),
          centerTitle: true,
        ),
        body: _buildFeed());
  }

  Widget _buildFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.size > 4) {
          return ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (context, index) {
                return Container(height: 0,color: Colors.red,);
              },
              itemBuilder: (context, index) {
                var doc = snapshot.data.docs[index];
                final ImagePost imagePost = ImagePost.fromDocument(doc);
                return imagePost;
                // return Container(height: 300,color: Colors.black,);

              });

        }
        // return Container(height: 300,color: Colors.black,);
        return Center(child: CircularProgressIndicator(
            backgroundColor:Colors.red,
        ));
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
