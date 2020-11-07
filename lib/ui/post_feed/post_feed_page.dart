import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orangda/ui/post_feed/posts_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import '../../common/constants/constants.dart';
import '../widgets/image_post.dart';
import '../widgets/push_to_refresh_header.dart';

class PostFeedPage extends StatefulWidget {
  @override
  _PostFeedPageState createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  PostRepository listSourceRepository = PostRepository(
    pageCount: 20,
    collection: Constants.COLLECTION_POST,
  );
  DateTime dateTimeNow;

  @override
  void initState() {
    super.initState();
    listSourceRepository.refresh().whenComplete(() {
      setState(() {
        dateTimeNow = DateTime.now();
      });
    });
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
    return Container(
      child: PullToRefreshNotification(
        pullBackOnRefresh: false,
        maxDragOffset: maxDragOffset,
        armedDragUpCancel: false,
        onRefresh: onRefresh,
        child: Container(

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
                    maxCrossAxisExtent: 400,
                    // crossAxisSpacing: 5,
                    // mainAxisSpacing: 5,
                  ),
                  itemBuilder: buildItem,
                  sourceList: listSourceRepository,
                  // padding: const EdgeInsets.all(5.0),
                  lastChildLayoutType: LastChildLayoutType.foot,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, ImagePost item, int index) {
    return Container(
        // decoration: BoxDecoration(
        //     border: Border(
        //         bottom: BorderSide(
        //   color: Colors.grey,
        //   width: 2,
        // ))),
        child: item);
  }
}
