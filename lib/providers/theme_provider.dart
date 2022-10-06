// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:saff_geo_attendence/helper/constants.dart';
import 'package:saff_geo_attendence/services/shared_preferences_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode? _themeMode;
  ThemeMode? get themeMode => _themeMode;

  ThemeProvider(this._themeMode);

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    SharedPreferencesService prefs = SharedPreferencesService.instance;
    prefs.setDark(isOn);
    notifyListeners();
  }
}

Color primaryColor = Constants.primaryColor;

Map<int, Color> blackSwatchColorMap = {
  50: primaryColor,
  100: primaryColor,
  200: primaryColor,
  300: primaryColor,
  400: primaryColor,
  500: primaryColor,
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
  1000: primaryColor,
};
MaterialColor blackSwatch = MaterialColor(0xFF0f5731, blackSwatchColorMap);

Map<int, Color> whiteSwatchColorMap = {
  50: primaryColor,
  100: primaryColor,
  200: primaryColor,
  300: primaryColor,
  400: primaryColor,
  500: primaryColor,
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
  1000: primaryColor,
};
// Green color code: 93cd48 and first two characters (FF) are alpha values (transparency)
MaterialColor whiteSwatch = MaterialColor(0xFF0f5731, whiteSwatchColorMap);

class MyThemes {
  static final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    primaryColor: primaryColor,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline2: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      caption: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      button: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      overline: TextStyle(
        fontSize: 10,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: whiteSwatch,
      brightness: Brightness.dark,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    iconTheme: IconThemeData(color: whiteSwatch),
    primaryIconTheme: IconThemeData(color: whiteSwatch),
  );

  ThemeData getDark() => darkTheme;

  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline2: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headline6: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      subtitle2: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      caption: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      overline: TextStyle(
        fontSize: 10,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    primaryColor: primaryColor,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: blackSwatch,
      brightness: Brightness.light,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  );
  ThemeData getLight() => lightTheme;
}
