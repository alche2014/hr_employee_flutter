import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static savePreferenceString(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static Future<bool> getPreferenceBoolean(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(key) == null) {
      return true;
    } else if (sharedPreferences.getBool(key) == true) {
      return true;
    } else {
      return false;
    }
  }
}
