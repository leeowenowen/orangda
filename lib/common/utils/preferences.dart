import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences _prefs;

  static init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _prefs = sp;
  }

  static SharedPreferences instance() {
    return _prefs;
  }
}

