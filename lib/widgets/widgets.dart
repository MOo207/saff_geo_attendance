import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saff_geo_attendence/helper/constants.dart';

PreferredSizeWidget myAppBar(context, bool showBackButton) {
  // get current theme by flutter system
  final ThemeData theme = Theme.of(context);
  // know if the appbar is dark or light
  final isDark = theme.brightness == Brightness.dark;
  return AppBar(
    centerTitle: true,
    iconTheme: showBackButton ? Theme.of(context).iconTheme : null,
    actions: [Image.asset(
          'assets/saff_logo.png',
          height: 50,
          width: 50,
        ),],
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.half_title1,
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context)!.half_title2,
          style:
              TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600),
        )
      ],
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}