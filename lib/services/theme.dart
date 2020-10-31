import 'package:flutter/material.dart';

class MyTheme {
  static var theme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
    hintColor: Colors.lightBlue[800],
    splashColor: Colors.transparent,
    // Define the default font family.
    fontFamily: 'Noto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyText2: TextStyle(fontSize: 14.0),
      overline: TextStyle(fontSize: 18.0, letterSpacing: 0),
    ),
  );
}
