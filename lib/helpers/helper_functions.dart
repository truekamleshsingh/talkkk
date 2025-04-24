import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'NAMEKEY';
  static String userEmailKey = 'EMAILKEY';

  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.setString(userEmailKey, email);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getBool(userLoggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString(userEmailKey);
  }
}
