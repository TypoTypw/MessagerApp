import 'package:flutter/material.dart';

import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String screenID = 'welcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          child: Hero(
            tag: 'logo',
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/chat.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, LoginScreen.screenID);
          },
        ),
      ),
    );
  }
}
