import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:orangda/themes/theme.dart';
import 'package:orangda/ui/account/login_page.dart';
import 'package:orangda/ui/home/home_page.dart';

import 'common/utils/app_util.dart';
import 'common/utils/preferences.dart';
import 'localization/my_l10n_delegate.dart';
import 'routes/route.dart';
import 'service/account_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized();

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
