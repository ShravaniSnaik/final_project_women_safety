// import 'package:shared_preferences/shared_preferences.dart';

// class MySharedPreference{
//  static SharedPreferences?_preferences;
//  static const String mkey='usertype';

//  static init() async{
//     _preferences=await SharedPreferences.getInstance();
//     return _preferences;
//   }

//  static Future saveUserType(String type)async{
//    await init(); 
//     return await _preferences!.setString(mkey, type);
//   }
//   static Future<String?> getUserType() async {
//    await init();  // Ensure initialization
//     return _preferences!.getString(mkey);
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;
  static const String mkey = 'usertype';

  // Ensure preferences are initialized before use
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveUserType(String type) async {
    await init(); // Ensure SharedPreferences is initialized
    await _preferences!.setString(mkey, type);
  }

  static Future<String> getUserType() async {
    await init(); // Ensure SharedPreferences is initialized
    return _preferences?.getString(mkey) ?? ""; // Avoid null error
  }
}
