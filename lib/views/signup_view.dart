// ignore_for_file: use_build_context_synchronously

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/helper/validators.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';
import 'package:saff_geo_attendence/services/auth_service.dart';
import 'package:saff_geo_attendence/views/login_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  final passwordController = FancyPasswordController();
  String? password;
  TextEditingController repPassController = TextEditingController();
  bool isLoading = false;
  // form key for validating the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(context, true),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // logo of the app
                Image.asset(
                  'assets/saff_logo.png',
                  height: 200,
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.email,
                    ),
                    validator: (value) =>
                        Validators.emailValidation(context, value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: FancyPasswordField(
                    validator: (value) =>
                        Validators.passwordValidation(context, value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: AppLocalizations.of(context)!.password,
                    ),
                    hasValidationRules: true,
                    hasStrengthIndicator: true,
                    validationRules: {
                      UppercaseValidationRule(),
                      MinCharactersValidationRule(8),
                      LowercaseValidationRule(),
                      DigitValidationRule(),
                    },
                    validationRuleBuilder: (rules, value) {
                      if (value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Wrap(
                        children: rules
                            .map(
                              (e) => e.validate(value)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 10.0,
                                            color: Colors.green.shade800,
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                                color: Colors.green.shade800),
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            size: 10.0,
                                            color: Colors.red.shade800,
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            e.name,
                                            style: TextStyle(
                                                color: Colors.red.shade800),
                                          )
                                        ],
                                      ),
                                    ),
                            )
                            .toList(),
                      );
                    },
                    onChanged: (String text) {
                      password = text;
                      // if (passwordController.areAllRulesValidated) {}
                    },
                    style: const TextStyle(),
                    obscureText: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: repPassController,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.confirm_password,
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (passwordConfirmation) {
                      if (passwordConfirmation == null ||
                          passwordConfirmation.isEmpty) {
                        return AppLocalizations.of(context)!.password_required;
                      }
                      bool passwordConfirmed = password == passwordConfirmation;
                      return (passwordConfirmed)
                          ? null
                          : AppLocalizations.of(context)!.password_not_match;
                    },
                    style: const TextStyle(),
                    obscureText: true,
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ElevatedButton(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(AppLocalizations.of(context)!.sign_up,
                                  style: Theme.of(context).textTheme.button),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                var registerDone = await _authService
                                    .register(
                                        emailController.text.trim(), password!);
                                if (registerDone) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginView()));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Error while registering user"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                print(e);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .complete_all_fields),
                                duration: const Duration(seconds: 2),
                              ));
                            }
                          },
                        )),
                  ),
                ]),
                Row(
                  children: <Widget> [
                    Text(AppLocalizations.of(context)!.already_have_account),
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.sign_in_here,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        ));
  }
}
