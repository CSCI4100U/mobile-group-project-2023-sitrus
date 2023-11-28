import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      primary: Colors.lightBlue,
      secondary: Colors.deepOrange,
      background: Colors.white

  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.deepPurple,
        background: Colors.white

    )
);