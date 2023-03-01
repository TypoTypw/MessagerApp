import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData customMainTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 13, 13, 13),
    splashColor: Colors.yellow,
    fontFamily: "Cacha",
    scaffoldBackgroundColor: const Color.fromARGB(255, 71, 71, 71),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 71, 71, 71),
      iconTheme: IconThemeData(
        color: Color.fromARGB(255, 201, 0, 118),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black38,
      onPrimary: Colors.black38,
      secondary: Colors.indigoAccent,
    ),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 53, 20, 151),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 201, 0, 118),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color.fromARGB(255, 201, 0, 118),
      ),
      hintStyle: TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        color: Colors.yellowAccent,
      ),
      subtitle1: TextStyle(
        color: Color.fromARGB(255, 201, 0, 118),
        fontSize: 18.0,
      ),
      bodyText2:
          TextStyle(fontSize: 20.0, fontFamily: 'Cacha', color: Colors.white),
    ),
  );
}
