import 'package:flutter/material.dart';
import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String screenID = 'welcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController circleController;
  late Animation animation;
  late Animation circleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    circleController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    animation = ColorTween(
      begin: Colors.indigo,
      end: const Color.fromARGB(255, 53, 20, 151),
    ).animate(controller);

    circleAnimation =
        CurvedAnimation(parent: circleController, curve: Curves.elasticInOut);

    controller.forward();
    circleController.forward();

    circleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        circleController.reverse(from: 0.9);
      } else if (status == AnimationStatus.dismissed) {
        circleController.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });
    circleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 250 + (circleController.value * 100),
              width: 250 + (circleController.value * 100),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/circle.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            InkWell(
              child: Hero(
                tag: 'logo',
                child: Container(
                  width: 90,
                  height: 90,
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
          ],
        ),
      ),
    );
  }
}
