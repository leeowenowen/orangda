import 'package:orangda/common/utils/preferences.dart';
import 'package:package_info/package_info.dart';

class AppUtil {
  static const String _VERSION = "version";
  static bool _isFirstRun = false;

  //must be initialized before Prefs.
  static init() async {
    String oldVersion = Prefs.instance().getString(_VERSION);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    if (oldVersion == null || oldVersion.isEmpty || (oldVersion != version)) {
      _isFirstRun = true;
      Prefs.instance().setString(_VERSION, version);
    } else {
      _isFirstRun = false;
    }
  }

  static bool isFirstRun() {
    return _isFirstRun;
  }
}
