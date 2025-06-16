import 'package:naturascan/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static SharedPreferences? _sharedPrefs;

  PrefManager._();

  static final PrefManager instance = PrefManager._();

  static init() async {
    if (_sharedPrefs != null) {
      return _sharedPrefs;
    } else {
      _sharedPrefs = await SharedPreferences.getInstance();
      return _sharedPrefs;
    }
  }

  static Future<void> putString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> putDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static Future<void> putInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value ?? "";
  }
  static Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? value = prefs.getDouble(key);
    return value ?? 0.0;
  }

  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(key);
    return value ?? 0;
  }
  static String get accessTokenAuth =>
      _sharedPrefs?.getString(Constants.accessTokenAuth) ?? "";

  static void putAppleUserInfo(String givenName, String familyName) async {
    _sharedPrefs?.setString(Constants.appleFamilyName, familyName);
    _sharedPrefs?.setString(Constants.appleGivenName, givenName);
  }

  static String? get appleFamilyName {
    return _sharedPrefs?.getString(Constants.appleFamilyName);
  }

  static String? get appleGivenName {
    return _sharedPrefs?.getString(Constants.appleGivenName);
  }

  static void putBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(key);
    return value ?? false;
  }

  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
