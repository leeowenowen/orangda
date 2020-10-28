import 'package:flutter/material.dart';
import 'package:orangda/ui/account/login_page.dart';
import 'package:orangda/ui/account/profile_page.dart';
import 'package:orangda/ui/account/set_account_info_page.dart';
import 'package:orangda/ui/comment/comment_page.dart';
import 'package:orangda/ui/demo/custom_scroll_view_demo.dart';
import 'package:orangda/ui/demo/demo_page.dart';
import 'package:orangda/ui/demo/known_size_demo.dart';
import 'package:orangda/ui/demo/random_size_demo.dart';
import 'package:orangda/ui/demo/variable_size_demo.dart';
import 'package:orangda/ui/home/home_page.dart';
import 'package:orangda/ui/startup/user_guidence_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      DemoPage.ROUTE: (_) => DemoPage(),
      UserGuidencePage.ROUTE: (_) => UserGuidencePage(),
      CustomScrollviewDemo.ROUTE: (_) => CustomScrollviewDemo(),
      KnownSizedDemo.ROUTE: (_) => KnownSizedDemo(),
      RandomSizedDemo.ROUTE: (_) => RandomSizedDemo(),
      VariableSizedDemo.ROUTE: (_) => VariableSizedDemo(),
      LoginPage.ROUTE: (_) => LoginPage(),
      HomePage.ROUTE: (_) => HomePage(),
      CommentPage.ROUTE: (_) => CommentPage(),
      ProfilePage.ROUTE: (_) => ProfilePage(),
      SetAccountInfoPage.ROUTE: (_) => SetAccountInfoPage(),
    };
  }
}
