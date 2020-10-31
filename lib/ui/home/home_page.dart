import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:orangda/common/utils/font_util.dart';
import 'package:orangda/localization/my_l10n.dart';
import 'package:orangda/service/account_service.dart';
import 'package:orangda/ui/account/login_page.dart';
import 'package:orangda/ui/activity/activity_page.dart';
import 'package:orangda/ui/demo/variable_size_demo.dart';
import 'package:orangda/ui/widgets/fancy_bottom_navigation.dart';
import 'package:orangda_photo_selector/photo_selector_view.dart';

import '../../main.dart';
import '../post_feed/post_feed_page.dart';
import '../account/profile_page.dart';
import '../upload/upload_page.dart';

class HomePage extends StatefulWidget {
  static final String ROUTE = 'home_page';
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}
enum TabType{
  FEED, ACTIVITY, ADD, DUMMY, ME
}
class _HomePageState extends State<HomePage> {
  int _page = 0;
  PageController _pageController;
  StreamController<int> indexcontroller = StreamController<int>.broadcast();

  String _getPageTitle() {
    String key;
    switch (_page) {
      case 0:
        key = 'main.title';
        break;
      // case 1:
      //   key = 'smile_wall.title';
      //   break;
      case 1:
        key = 'share.title';
        break;
      // case 3:
      //   key = 'dummy.title';
      //   break;
      case 2:
        key = 'me.title';
        break;
      default:
        break;
    }
    return MyLocalizations.of(context).get(key);
  }

  @override
  Widget build(BuildContext context) {
    return (AccountService.googleSignIn().currentUser == null ||
        currentUserModel == null)
        ? LoginPage()
        : Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: FontUtil.makeTitleByString(_getPageTitle()),
      //   centerTitle: true,
      //   elevation: 0,
      //   bottom: new PreferredSize(
      //       child: new Container(
      //           color: Color(0xffdddddd),
      //           height: 0.5,
      // ),),),
      body: Container(
        child: PageView(
          children: [
            Container(
              color: Colors.white,
              child: PostFeedPage(),
            ),
            // Container(color: Colors.white, child: ActivityPage()),
            Container(
              color: Colors.white,
              child: PhotoSelectorView(),
            ),
            // Container(
            //   color: Colors.white,
            //   child: VariableSizedDemo(),
            // ),
            Container(
              color: Colors.white,
              child: ProfilePage(
                userId: AccountService.googleSignIn().currentUser.id,
              ),
            )
          ],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
        ),
      ),
      bottomNavigationBar:_buildBottomBar(),

    );
  }

  Widget _buildBottomBar(){
    return ConvexAppBar(
      color: Colors.black,
      backgroundColor: Colors.white,
      activeColor:Colors.orange,
      height: 50,
      top:-20,
      items: [
        TabItem(icon: Icons.home, title: 'Home'),
        // TabItem(icon: Icons.map, title: 'Discovery'),
        TabItem(icon: Icons.add, title: 'Add'),
        // TabItem(icon: Icons.message, title: 'Message'),
        TabItem(icon: Icons.people, title: 'Profile'),
      ],
      initialActiveIndex: 0,//optional, default as 0
      onTap: (value){
        indexcontroller.add(value);
        _pageController.jumpToPage(value);
      },
    );
  }

  Widget _buildBottomBarV2(){
    return       StreamBuilder<Object>(
        initialData: 0,
        stream: indexcontroller.stream,
        builder: (context, snapshot) {
          int cIndex = snapshot.data;
          return FancyBottomNavigation(
            currentIndex: cIndex,
            items: <FancyBottomNavigationItem>[
              FancyBottomNavigationItem(
                  icon: Icon(Icons.home), title: Text('Home')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.local_activity), title: Text('Activity')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.thumb_up), title: Text('Thank You')),
              FancyBottomNavigationItem(
                  icon: Icon(Icons.person), title: Text('Me')),
            ],
            onItemSelected: (int value) {
              indexcontroller.add(value);
              _pageController.jumpToPage(value);
            },
          );
        });
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      Map<String,Object> args = ModalRoute.of(context).settings.arguments;
      TabType specifyTab = args['tab'];
      if (specifyTab != null)
        setState(() {
          _page = specifyTab.index;
        });
    }
  }
}