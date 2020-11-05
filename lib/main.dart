import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/home/home_page.dart';
import 'package:orangda_photo_selector/photo_selector_view.dart';

import 'common/constants/constants.dart';
import 'common/utils/app_util.dart';
import 'common/utils/preferences.dart';
import 'localization/my_l10n_delegate.dart';
import 'models/user.dart';
import 'routes/route.dart';
import 'service/account_service.dart';
import 'ui/account/login_page.dart';

final ref = Firestore.instance.collection(Constants.COLLECTION_USER);

User currentUserModel;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // after upgrading flutter this is now necessary
  await Firebase.initializeApp();
  await Prefs.init();
  await AppUtil.init();

  AccountService.init();
  runApp(Orangda());
}

class Orangda extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orangda',
      initialRoute: HomePage.ROUTE,
      routes: Routes.getRoute(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MyLocalizationDelegate()
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'CN'),
      ],
      theme: AppTheme.theme,
      //  darkTheme: AppTheme.theme,
      // home: PhotoSelectorView());
    );
  }
}
