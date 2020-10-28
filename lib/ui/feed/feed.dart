import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orangda/common/utils/font_util.dart';
import 'package:orangda/ui/widgets/image_post.dart';

import '../../common/constants/constants.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<ImagePost> feedData;

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: AppBar(
        title: FontUtil.makeTitle(),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            width: 200,
            color: Colors.red,
            child: buildFeed(),
          )),
    );
  }

  Future<Null> _refresh() async {
    await _getFeed();

    setState(() {});

    return;
  }

  _loadFeed() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String json = prefs.getString("feed");
    //
    // if (json != null) {
    //   List<Map<String, dynamic>> data =
    //       jsonDecode(json).cast<Map<String, dynamic>>();
    //   List<ImagePost> listOfPosts = _generateFeed(data);
    //   setState(() {
    //     feedData = listOfPosts;
    //   });
    // } else {
    _getFeed();
    // }
  }

  Future<List<ImagePost>> getPosts() async {
    List<ImagePost> posts = [];
    var snap = await Firestore.instance
        .collection(Constants.COLLECTION_POSTS)
        .orderBy("timestamp")
        .getDocuments();
    for (var doc in snap.documents) {
      posts.add(ImagePost.fromDocument(doc));
    }

    return posts;
  }

  _getFeed() async {
    print("Staring getFeed");
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    // load all feeds , so do not need user id now
    // String userId = AccountService.googleSignIn().currentUser.id.toString();
    // var url = 'https://us-central1-orange-86885.cloudfunctions.net/getFeed?uid=' + userId;
    // String userId = '';
    // var url = 'https://us-central1-orange-86885.cloudfunctions.net/getFeed';
    //
    // var httpClient = HttpClient();
    //
    // List<ImagePost> listOfPosts;
    // String result;
    // try {
    //   var request = await httpClient.getUrl(Uri.parse(url));
    //   var response = await request.close();
    //   if (response.statusCode == HttpStatus.ok) {
    //     String json = await response.transform(utf8.decoder).join();
    //     prefs.setString("feed", json);
    //     List<Map<String, dynamic>> data =
    //         jsonDecode(json).cast<Map<String, dynamic>>();
    //     listOfPosts = _generateFeed(data);
    //     result = "Success in http request for feed";
    //   } else {
    //     result =
    //         'Error getting a feed: Http status ${response.statusCode} | userId $userId';
    //   }
    // } catch (exception) {
    //   result = 'Failed invoking the getFeed function. Exception: $exception';
    // }
    // print(result);
    List<ImagePost> posts = await getPosts();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String jsonString = json.encode(posts);
    // prefs.setString("feed", jsonString);
    setState(() {
      feedData = posts;
    });
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
