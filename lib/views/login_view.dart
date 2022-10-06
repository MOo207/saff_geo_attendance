// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:saff_geo_attendence/helper/constants.dart';
import 'package:saff_geo_attendence/helper/validators.dart';
import 'package:saff_geo_attendence/models/user.dart';
import 'package:saff_geo_attendence/services/auth_service.dart';
import 'package:saff_geo_attendence/services/database_service.dart';
import 'package:saff_geo_attendence/views/map_veiw_homepage.dart';
import 'package:saff_geo_attendence/views/preferences_view.dart';
import 'package:saff_geo_attendence/views/signup_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saff_geo_attendence/widgets/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  // form key for validating the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(context, false),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  // user preference button
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreferencesPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // logo of the app
              Image.asset(
                'assets/saff_logo.png',
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
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
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password,
                        ),
                        validator: (value) =>
                            Validators.passwordValidation(context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //forgot password screen

                        // getAllUsers test
                        DatabaseService db = DatabaseService.instance;
                        db.getAllUsers().then((value) {
                          print(value);
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot_password,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Constants.primaryColor,
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(children: [
                Expanded(
                  child: Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(AppLocalizations.of(context)!.sign_in,
                                style: Theme.of(context).textTheme.button),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              var loginResult = await _authService.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              // if user is subtype of user, or firebaseauthexception is thrown, then show error message
                              if (loginResult.containsKey(true)) {
                                User loggedInUser = User.fromJson(loginResult[true] as Map<String, dynamic>);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             MapHomePage(loggedInUser: loggedInUser,)));
                              } else {
                                String error = loginResult[false].toString();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(error),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              // show snackbar with error message
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(e.toString()),
                                duration: const Duration(seconds: 2),
                              ));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .complete_all_fields),
                              duration: const Duration(seconds: 2),
                            ));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      )),
                ),
              ]),
              Row(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.dont_have_account,
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context)!.create_one,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupView())),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ));
  }
}
