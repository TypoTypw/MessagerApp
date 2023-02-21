import 'dart:io';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'chatScreen.dart';
import '../firebase_auth/authenticationStatus.dart';
import '../firebase_auth/firebaseAuthentication.dart';
import 'loginScreen.dart';
import 'package:image_picker/image_picker.dart';
import '../firestore_handler/firestoreServiceHandler.dart';
import '../firestore_handler/firestoreStatus.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String screenID = 'registerScreen';

  @override
  State<RegistrationScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _authentication = AuthenticationService();
  final _firestoreServices = firestoreServices();
  File? imageFile;

  bool isLoading = false;
  RegExp passwordValidate =
      RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!_@#\$&*~]).{8,}$");
  double passwordStrength = 0;

  bool checkPassword(String password) {
    String pass = password.trim();
    if (pass.isEmpty) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (pass.length < 6) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (pass.length < 8) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else if (pass.length >= 8) {
      if (passwordValidate.hasMatch(pass)) {
        setState(() {
          passwordStrength = 1 / 1;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.pushNamed(context, 'loginScreen');
          },
        ),
        title: const Text('Sign-Up to Lifts To Go!'),
      ),
      body: Center(
        child: _accountSetupCard(),
      ),
    );
  }

  Widget _accountSetupCard() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: const BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ) // green shaped
                        ),
                    child: const Text(
                      "Account setup",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                          child: Image.asset('images/message.png'),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          // obscureText: true,
                          obscuringCharacter: '*',
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter your password';
                            } else {
                              bool checker = checkPassword(value);
                              if (checker) {
                                return null;
                              } else {
                                return "Password too weak";
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: passwordStrength,
                            backgroundColor: Colors.blueGrey,
                            minHeight: 5,
                            color: passwordStrength <= 1 / 4
                                ? Colors.red
                                : passwordStrength == 2 / 4
                                    ? Colors.yellow
                                    : passwordStrength == 3 / 4
                                        ? Colors.blue
                                        : Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          controller: _passwordConfirmController,
                          keyboardType: TextInputType.visiblePassword,
                          // obscureText: true,
                          obscuringCharacter: '*',
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Re-enter your password to confirm';
                            } else if (value !=
                                _passwordController.text.trim()) {
                              return "Password don't match try again";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Re-enter your password to confirm',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              (imageFile == null)
                                  ? Image.asset(
                                      'images/profile.png',
                                      width: 10,
                                      height: 10,
                                    )
                                  : CircleAvatar(
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                          child: Image.file(
                                            File(imageFile!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              Positioned(
                                left: 80,
                                bottom: -12,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 1,
                                            right: -15,
                                            child: RawMaterialButton(
                                              onPressed: () {
                                                _getImageFromGallery();
                                              },
                                              fillColor:
                                                  const Color(0xFFF5F6F9),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              shape: const CircleBorder(),
                                              child: const Icon(
                                                Icons.browse_gallery,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 1,
                                            right: -15,
                                            child: RawMaterialButton(
                                              onPressed: () {
                                                _getImageFromCamera();
                                              },
                                              fillColor:
                                                  const Color(0xFFF5F6F9),
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              shape: const CircleBorder(),
                                              child: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          validator: (value) =>
                              value != null ? null : "Please enter your name",
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: _surnameController,
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          validator: (value) => value != null
                              ? null
                              : "Please enter your surname",
                          decoration: const InputDecoration(
                            hintText: 'Enter your surname',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                          validator: (value) => value != null
                              ? null
                              : "Please enter your phone number",
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            color: Colors.deepOrangeAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            elevation: 5.0,
                            child: MaterialButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                if (_formKey.currentState!.validate()) {
                                  final status =
                                      await _authentication.createAccount(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                  String imageURL;
                                  if (imageFile == null) {
                                    imageURL = 'null';
                                  } else {
                                    imageURL = await _firestoreServices
                                        .uploadProfilePicture(imageFile!);
                                  }
                                  final profileStatus =
                                      await _firestoreServices.createProfile(
                                          name: _nameController.text.trim(),
                                          surname:
                                              _surnameController.text.trim(),
                                          phone: _phoneController.text,
                                          img: imageURL);

                                  if (status != AuthStatus.successful) {
                                    final error = AuthExceptionHandler
                                        .generateErrorMessage(status);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error),
                                      ),
                                    );
                                  }
                                  if (profileStatus ==
                                      FirestoreStatus.successful) {
                                    Navigator.pushNamed(context, 'chatScreen');
                                  } else {
                                    final error = AuthExceptionHandler
                                        .generateErrorMessage(status);
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
                                'Register',
                                style: TextStyle(color: Colors.white),
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
          ],
        ),
      ),
    );
  }

  _getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getImageFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
