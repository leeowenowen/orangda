import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:orangda/ui/post_feed/posts_repository.dart';
import 'package:orangda/ui/widgets/image_post.dart';
import 'package:orangda/ui/widgets/push_to_refresh_header.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import '../../../common/constants/constants.dart';

class SmileWallPage extends StatefulWidget {
  @override
  _SmileWallPageState createState() => _SmileWallPageState();
}

class _SmileWallPageState extends State<SmileWallPage> {
  List<ImagePost> _posts;
  PostRepository listSourceRepository = PostRepository(
    pageCount: 20,
    collection: Constants.COLLECTION_ACTIVITY,
  );
  DateTime dateTimeNow;

  @override
  void initState() {
    super.initState();
   // _getSmileWallPosts();
  }

  @override
  void dispose() {
    super.dispose();
    listSourceRepository.dispose();
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_posts == null || _posts.length == 0) {
    //   return Container();
    // }
    return PullToRefreshNotification(
      pullBackOnRefresh: false,
      maxDragOffset: maxDragOffset,
      armedDragUpCancel: false,
      onRefresh: onRefresh,
      child: LoadingMoreCustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo info) {
              return PullToRefreshHeader(info, dateTimeNow);
            }),
          ),
          LoadingMoreSliverList<ImagePost>(
            SliverListConfig<ImagePost>(
              extendedListDelegate:
                  const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: buildItem,
              sourceList: listSourceRepository,
              padding: const EdgeInsets.all(5.0),
              lastChildLayoutType: LastChildLayoutType.foot,
            ),
          )
        ],
      ),
    );
  }

  // Future<List<ImagePost>> _getSmileWallPosts() async {
  //   List<ImagePost> posts = [];
  //   var snap = await Firestore.instance
  //       .collection(Constants.COLLECTION_POSTS)
  //       .orderBy("timestamp")
  //       .getDocuments();
  //   for (var doc in snap.documents) {
  //     posts.add(ImagePost.fromDocument(doc));
  //   }
  //   setState(() {
  //     _posts = posts.reversed.toList();
  //   });
  // }

  Widget buildItem(BuildContext context, ImagePost item, int index) {
    return item;
  }
}
