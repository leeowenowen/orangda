import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/ui/widgets/image_post.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

class PostRepository extends LoadingMoreBase<ImagePost> {
  PostRepository(
      {this.maxLength = 300,
      this.pageCount = 20,
      this.collection = Constants.COLLECTION_POSTS});

  int _pageIndex = 1;
  final int pageCount;
  bool _hasMore = true;
  bool forceRefresh = false;
  final String collection;

  @override
  bool get hasMore => (_hasMore && length < maxLength) || forceRefresh;
  final int maxLength;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    _pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !notifyStateChanged;
    final bool result = await super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  DocumentSnapshot lastDocument;

  Future<List<ImagePost>> _getSmileWallPosts() async {
    List<ImagePost> posts = [];
    var snap = await Firestore.instance
        .collection(collection)
        .orderBy("timestamp", descending: true)
        .limit(pageCount)
        .getDocuments();
    for (var doc in snap.documents) {
      lastDocument = doc;
      posts.add(ImagePost.fromDocument(doc));
    }
    return posts;
  }

  Future<List<ImagePost>> _getNextSmileWallPosts() async {
    List<ImagePost> posts = [];
    var snap = await Firestore.instance
        .collection(collection)
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDocument)
        .limit(pageCount)
        .getDocuments();
    for (var doc in snap.documents) {
      posts.add(ImagePost.fromDocument(doc));
    }
    return posts;
  }

  _getFeed() async {
    print("Staring getFeed");

    if (isEmpty) {
      return await _getSmileWallPosts();
    } else {
      return await _getNextSmileWallPosts();
    }
    //
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // // load all feeds , so do not need user id now
    // // String userId = AccountService.googleSignIn().currentUser.id.toString();
    // // var url = 'https://us-central1-orange-86885.cloudfunctions.net/getFeed?uid=' + userId;
    // String userId = '';
    // String url = '';
    // if (isEmpty) {
    //   url = 'https://us-central1-orange-86885.cloudfunctions.net/getFeed';
    // } else {
    //   final int lastPostId = 0;//this[length - 1].postId;
    //   url =
    //   'https://api.tuchong.com/feed-app?post_id=$lastPostId&page=$_pageIndex&type=loadmore';
    // }
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
    //     jsonDecode(json).cast<Map<String, dynamic>>();
    //     listOfPosts = _generateFeed(data);
    //     result = "Success in http request for feed";
    //   } else {
    //     result =
    //     'Error getting a feed: Http status ${response.statusCode} | userId $userId';
    //   }
    // } catch (exception) {
    //   result = 'Failed invoking the getFeed function. Exception: $exception';
    // }

    //return listOfPosts;
  }

  // List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
  //   List<ImagePost> listOfPosts = [];
  //
  //   for (var postData in feedData) {
  //     listOfPosts.add(ImagePost.fromJSON(postData));
  //   }
  //
  //   return listOfPosts;
  // }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      //await Future.delayed(const Duration(milliseconds: 500));
      List<ImagePost> feedList = await _getFeed();

      // if (_pageIndex == 1) {
      //   clear();
      // }

      for (final ImagePost item in feedList) {
        if (!contains(item) && hasMore) {
          add(item);
        }
      }

      _hasMore = feedList.isNotEmpty;
      _pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
