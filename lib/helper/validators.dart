import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  Validators();
  static bool isEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  static bool isPassword(String password) {
    return password.length >= 8;
  }
  static emailValidation(context , value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.email_required;
    } else if (!isEmail(value)) {
      return AppLocalizations.of(context)!.email_invalid;
    }
    return null;
  }

 static passwordValidation(context,value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.password_required;
    } else if (!isPassword(value)) {
      return AppLocalizations.of(context)!.password_length;
    }
    return null;
  }
}