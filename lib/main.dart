import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:saff_geo_attendence/providers/locale_provider.dart';
import 'package:saff_geo_attendence/providers/theme_provider.dart';
import 'package:saff_geo_attendence/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService db = DatabaseService.instance;
  await db.initDB();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? isDark = pref.getBool("isDark") ?? false;
  bool? isArabic= pref.getBool("isArabic") ?? false;
  print(pref.getKeys());
  runApp(MultiProvider(providers: [
     ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(isDark ? ThemeMode.dark : ThemeMode.light),
        ),
    ChangeNotifierProvider<LocaleProvider>(
          create: (context) =>
              LocaleProvider(isArabic ? Locale("ar") : Locale("en")),
        ),
  ], child: MyApp()));
}