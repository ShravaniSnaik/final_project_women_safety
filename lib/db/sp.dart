import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;
  static const String mkey = 'usertype';
  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type) async {
    return await _preferences!.setString(mkey, type);
  }

  static Future<String>? getUserType() async =>
      _preferences!.getString(mkey) ?? "";
}
