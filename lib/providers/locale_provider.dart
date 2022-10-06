import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  LocaleProvider(this._locale);

  Locale get getlocale => _locale!;

  // bool isArabic
  bool get isArabic => _locale?.languageCode == "ar";

  void changeLocale(bool isArabic) async {
    _locale = isArabic ? Locale("ar", "SA") : Locale("en", "US");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isArabic", isArabic);
    notifyListeners();
  }



}
