import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      primary: Colors.lightBlue,
      secondary: Colors.deepOrange,
      background: Colors.white

  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.deepPurple,
        background: Colors.white

    )
);