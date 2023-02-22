import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chatScreen.dart';
import 'registration.dart';
import 'forgotPassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../firebase_auth/authenticationStatus.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import '../firestore_handler/firestoreServiceHandler.dart';
import 'package:chatterbug/customTheme.dart' as custom;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String screenID = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authentication = AuthenticationService();
  final _fireStoreInstance = firestoreServices();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CircularProgressIndicator(),
        blur: 2.5,
        color: const Color.fromARGB(255, 201, 0, 118),
        child: ListView(
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
                      height: 100.0,
                    ),
                    Hero(
                      tag: 'logo',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/chat.png'),
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegistrationScreen.screenID);
                          },
                          child: Text(
                            "REGISTER",
                            style: custom
                                .AppTheme.customMainTheme.textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      textAlign: TextAlign.center,
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
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your password.',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 0, 118),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    Row(
                      children: [
                        const Text("Forgot your password than click this"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ResetPasswordScreen.screenID);
                          },
                          child: Text(
                            "LINK",
                            style: custom
                                .AppTheme.customMainTheme.textTheme.headline6,
                          ),
                        ),
                      ],
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
                              final _status = await _authentication.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                              if (_status == AuthStatus.successful) {
                                _fireStoreInstance.signInProfile();
                                Navigator.pushNamed(
                                    context, ChatScreen.screenID);
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
                          child: const Text(
                            'Log In',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
