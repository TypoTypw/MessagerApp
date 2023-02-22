import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatterbug/customTheme.dart' as custom;
import 'loginScreen.dart';
import 'package:email_validator/email_validator.dart';

import '../firebase_auth/authenticationStatus.dart';
import '../firebase_auth/firebaseAuthentication.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static const String screenID = 'resetPasswordScreen';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = '';
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authentication = AuthenticationService();

  bool isLoading = false;
  late AuthStatus _status;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    height: 200.0,
                    child: Image.asset('assets/icons/tools.png'),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text("Reset Password"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) => EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email",
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 201, 0, 118),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: const Color.fromARGB(255, 201, 0, 118),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            _status = await _authentication.resetPassword(
                              email: _emailController.text.trim(),
                            );
                            if (_status == AuthStatus.successful) {
                              Navigator.pushNamed(
                                  context, LoginScreen.screenID);
                            } else {
                              final error =
                                  AuthExceptionHandler.generateErrorMessage(
                                      _status);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                ),
                              );
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          'Reset',
                          style: custom
                              .AppTheme.customMainTheme.textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: InkWell(
                        child: Column(
                          children: const [
                            Icon(Icons.exit_to_app_sharp),
                            Text('Return')
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, 'loginScreen');
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
