import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'screens/welcomeScreen.dart';
import 'screens/loginScreen.dart';
import 'screens/registration.dart';
import 'screens/chatScreen.dart';
import 'screens/forgotPassword.dart';
import 'customTheme.dart' as custom;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter Bug',
      debugShowCheckedModeBanner: false,
      theme: custom.AppTheme.customMainTheme,
      initialRoute: 'welcomeScreen',
      routes: {
        'welcomeScreen': (context) => const WelcomeScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'registerScreen': (context) => const RegistrationScreen(),
        'chatScreen': (context) => const ChatScreen(),
        'resetPasswordScreen': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
