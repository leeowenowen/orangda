import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orangda/common/constants/constants.dart';
import 'package:orangda/models/post/post.dart';
import 'package:orangda/models/post/post_model.dart';
import 'package:orangda/models/user/user_model.dart';
import 'package:orangda/service/account_service.dart';
import 'package:orangda/ui/widgets/image_post.dart';

import '../../models/user.dart';
import 'edit_profile_page.dart';
import 'image_tile.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  static final String ROUTE = 'profile_page';

  ProfilePage();

  State createState(){
      return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>
    with
        AutomaticKeepAliveClientMixin<ProfilePage>,
        AfterLayoutMixin<ProfilePage> {
  String profileId;
  String currentUserId;
  String view = "grid"; // default view
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  _ProfilePageState();
  @override
  void initState() {
    super.initState();
    if (AccountService.currentUser() != null) {
      currentUserId = AccountService.currentUser().id;
    }
  }

  void parseParams(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      Map<String, Object> args = ModalRoute.of(context).settings.arguments;
      String profileId = args['userId'];
      if (profileId != null && profileId.isNotEmpty) {
        this.profileId = profileId;
      }
    }
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    parseParams(context);
    if(AccountService.currentUser() == null){
      await Navigator.of(context).pushNamed(LoginPage.ROUTE);
      if(AccountService.currentUser() != null){
        setState(() {
          currentUserId = AccountService.currentUser().id;
        });
      }
      return;
    }
  }

  editProfile() {
    EditProfilePage editPage = EditProfilePage();

    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              title: Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      editPage.applyChanges();
                      Navigator.maybePop(context);
                    })
              ],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: editPage,
                ),
              ],
            )),
      );
    }));
  }

  followUser() {
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
    UserModel.followUser(profileId, currentUserId);
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
    UserModel.unFollowUser(profileId, currentUserId);
  }

  Column buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ))
      ],
    );
  }


  Container buildFollowButton(
      {String text,
        Color backgroundcolor,
        Color textColor,
        Color borderColor,
        Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5.0)),
            alignment: Alignment.center,
            child: Text(text,
                style:
                TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            width: 220.0,
            height: 27.0,
          )),
    );
  }
  Container buildProfileFollowButton(User user) {
    // viewing your own profile - should show edit button
    if (currentUserId != null && currentUserId == profileId) {
      return buildFollowButton(
        text: "Edit Profile",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: editProfile,
      );
    }

    // already following user - should show unfollow button
    if (isFollowing) {
      return buildFollowButton(
        text: "Unfollow",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildFollowButton(
        text: "Follow",
        backgroundcolor: Colors.blue,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: followUser,
      );
    }

    return buildFollowButton(
        text: "loading...",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
  }
  Row buildImageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.black26;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on, color: isActiveButtonColor("grid")),
          onPressed: () {
            changeView("grid");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
          onPressed: () {
            changeView("feed");
          },
        ),
      ],
    );
  }

  Container buildUserPosts() {
    Future<List<ImagePost>> getPosts() async {
      List<ImagePost> posts = [];
      var snap = await PostModel.getPostByUserId(profileId);
      for (var doc in snap.docs) {
        Post post = Post.fromDocument(doc);
        ImagePost imagePost = ImagePost(post);
        posts.add(imagePost);
      }
      setState(() {
        postCount = snap.docs.length;
      });

      return posts.reversed.toList();
    }

    return Container(
        child: FutureBuilder<List<ImagePost>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else if (view == "grid") {
              // build the grid
              return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
//                    padding: const EdgeInsets.all(0.5),
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data.map((ImagePost imagePost) {
                    return GridTile(child: ImageTile(imagePost));
                  }).toList());
            } else if (view == "feed") {
              return Column(
                  children: snapshot.data.map((ImagePost imagePost) {
                    return imagePost;
                  }).toList());
            }
            return Container();
          },
        ));
  }
  void updateProfileId(){
    parseParams(context);
    if(profileId == null || profileId.isEmpty){
      if(AccountService.currentUser() != null){
        profileId = AccountService.currentUser().id;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    updateProfileId();
    if(profileId == null || profileId.isEmpty){
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Constants.COLLECTION_USER)
            .doc(profileId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          }

          User user = User.fromDocument(snapshot.data);

          if (currentUserId != null && user.followers.containsKey(currentUserId) &&
              user.followers[currentUserId] &&
              followButtonClicked == false) {
            isFollowing = true;
          }

          return Scaffold(
            body: Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 40.0,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      buildStatColumn("posts", postCount),
                                      buildStatColumn("followers",
                                          _countFollowings(user.followers)),
                                      buildStatColumn("following",
                                          _countFollowings(user.following)),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        buildProfileFollowButton(user)
                                      ]),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              user.displayName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1.0),
                          child: Text(user.bio),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  buildImageViewButtonBar(),
                  Divider(height: 0.0),
                  buildUserPosts(),
                ],
              ),
            ),
          );
        });
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  int _countFollowings(Map followings) {
    int count = 0;

    void countValues(key, value) {
      if (value) {
        count += 1;
      }
    }

    followings.forEach(countValues);

    return count;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

void openProfile(BuildContext context, String userId) {
  Navigator.of(context).pushNamed(ProfilePage.ROUTE, arguments: {
    "userId": userId
  });
}
