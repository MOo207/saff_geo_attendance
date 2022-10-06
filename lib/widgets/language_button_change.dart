import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class ChangeLanguageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Switch.adaptive(
      value: localeProvider.isArabic,
      onChanged: (value) {
        localeProvider.changeLocale(value);
      },
    );
  }
}