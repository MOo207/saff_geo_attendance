import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:saff_geo_attendence/providers/locale_provider.dart';
import 'package:saff_geo_attendence/providers/theme_provider.dart';
import 'package:saff_geo_attendence/views/login_view.dart';
import 'package:saff_geo_attendence/views/signup_view.dart';

import 'views/map_veiw_homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAFF Geo Attendence',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Provider.of<LocaleProvider>(context).getlocale,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    );
  }
}
