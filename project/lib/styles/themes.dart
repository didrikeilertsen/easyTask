import 'package:flutter/material.dart';

/// Represents the theme the app is displaying.
class Themes {
  static Color textColor = Colors.black;
  static const MaterialColor primaryColor = MaterialColor(
    0xff4295a5,
    //0xffb04838,
    <int, Color>{
      50: Color.fromRGBO(36, 149, 165, 1), //10%
      100: Color.fromRGBO(36, 149, 165, 1),
      200: Color.fromRGBO(36, 149, 165, 1),
      300: Color.fromRGBO(36, 149, 165, 1),
      400: Color.fromRGBO(36, 149, 165, 1),
      500: Color.fromRGBO(36, 149, 165, 1),
      600: Color.fromRGBO(36, 149, 165, 1),
      700: Color.fromRGBO(36, 149, 165, 1),
      800: Color.fromRGBO(36, 149, 165, 1),
      900: Color.fromRGBO(36, 149, 165, 1),
    },
  );

  static const String fontFamily = "Comfortaa";

  static ThemeData themeData = ThemeData(
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Comfortaa",
    indicatorColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Color.fromRGBO(36, 149, 165, 1),
      foregroundColor: Colors.black,
      shadowColor: Colors.black54,
      elevation: 3,
    ),
    textTheme: textTheme,
  );

  static TextTheme textTheme = TextTheme(
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      color: textColor,
      fontSize: 14,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: textColor,
    ),
    bodySmall: const TextStyle(
      fontSize: 11,
    ),
    bodyLarge: const TextStyle(
      fontSize: 12,
      height: 1.5,
    ),
    labelLarge: const TextStyle(
      fontSize: 18,
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      color: textColor.withOpacity(0.54),
      fontSize: 12,
      letterSpacing: 0,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
