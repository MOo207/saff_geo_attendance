import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/services/shared_preferences_service.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  LocaleProvider(this._locale);

  Locale get getlocale => _locale!;

  // bool isArabic
  bool get isArabic => _locale?.languageCode == "ar";

  void changeLocale(bool isArabic) async {
    _locale = isArabic ? const Locale("ar", "SA") : const Locale("en", "US");
    SharedPreferencesService prefs =  SharedPreferencesService.instance;
    await prefs.setArabic(isArabic);
    notifyListeners();
  }



}
