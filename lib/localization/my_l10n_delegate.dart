import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'my_l10n.dart';

class MyLocalizationDelegate extends LocalizationsDelegate<MyLocalizations> {
  List<String> supportLang = ['en', 'zh'];

  @override
  bool isSupported(Locale locale) {
    return supportLang.contains(locale.languageCode);
  }

  @override
  Future<MyLocalizations> load(Locale locale) {
    return new SynchronousFuture<MyLocalizations>(new MyLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyLocalizations> old) {
    return false;
  }
}
