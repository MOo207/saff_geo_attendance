import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/widgets/language_button_change.dart';
import 'package:saff_geo_attendence/widgets/theme_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/saff_logo.png',
            height: 150,
          ),
          Text(
            AppLocalizations.of(context)!.user_preference,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          // change language button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.arabic,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ChangeLanguageButton(),
            ],
          ),
          // change theme button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.dark_mode,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ChangeThemeButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
