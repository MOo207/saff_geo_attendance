import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _kisDark = 'isDark';
  static const String _kisArabic = 'isArabic';

  // singelton
  static final SharedPreferencesService instance = SharedPreferencesService._();
  SharedPreferencesService._();

  // get shared preferences
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();
  Future<bool> get isDark async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(_kisDark) ?? false;
  }

  Future<bool> get isArabic async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(_kisArabic) ?? false;
  }

  Future<void> setDark(bool isDark) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_kisDark, isDark);
  }

  Future<void> setArabic(bool isArabic) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_kisArabic, isArabic);
  }

}
