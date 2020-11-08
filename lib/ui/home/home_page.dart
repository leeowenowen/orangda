import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/account/profile_page.dart';
import 'package:orangda/ui/demo/demo_page.dart';
import 'package:orangda/ui/feed/feed.dart';
import 'package:orangda_photo_selector/photo_selector_view.dart';

class HomePage extends StatefulWidget {
  static final String ROUTE = 'home_page';

  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

enum TabType { FEED, ACTIVITY, ADD, DUMMY, ME }

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage>  {
  int _page = 0;
  PageController _pageController;
  StreamController<int> indexController = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BACKGROUND,
      body: Container(
        color: MyColors.BACKGROUND,
        child: PageView(
          children: [
            Container(
              child: Feed(),
            ),
            // Container(color: Colors.white, child: ActivityPage()),
            Container(
              child: PhotoSelectorView(),
            ),
            Container(
              child: ProfilePage(),
            ),
            // Container(
            //   color: Colors.white,
            //   child: ProfilePage(
            //     userId: AccountService.googleSignIn().currentUser.id,
            //   ),
            // )
          ],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return ConvexAppBar(
      gradient: LinearGradient(colors:[
        Colors.deepOrange,Colors.black87,
      ]),
      color: MyColors.FOREGROUND,
      backgroundColor: MyColors.BACKGROUND,
      activeColor: MyColors.HIGHLIGHT_COLOR,
      height: 50,
      top: -20,
      items: [
        TabItem(icon: Icons.home,title: ''),
        // TabItem(icon: Icons.map, title: 'Discovery'),
        TabItem(icon: Icons.camera_alt, title: ''),
        // TabItem(icon: Icons.message, title: 'Message'),
        TabItem(icon: Icons.person, title: ''),
      ],
      initialActiveIndex: 0,
      //optional, default as 0
      onTap: (value) {
        indexController.add(value);
        _pageController.jumpToPage(value);
      },
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    // parseParams(context);
    _pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void parseParams(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      Map<String, Object> args = ModalRoute.of(context).settings.arguments;
      TabType specifyTab = args['tab'];
      if (specifyTab != null) {
        setState(() {
          _page = specifyTab.index;

        });
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    parseParams(context);
    }
}
