import 'package:shared_preferences/shared_preferences.dart';

void saveImage(String key, path) async {
  SharedPreferences saveimage = await SharedPreferences.getInstance();
  saveimage.setString(key, path);
}

Future loadImage(String key) async {
  SharedPreferences loadimage = await SharedPreferences.getInstance();
  return loadimage.getString(key);
}
