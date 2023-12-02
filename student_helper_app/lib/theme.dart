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
        primary: Color(0xFF7f5af0),
        secondary: Color(0xFF3f2d78),
        background: Color(0xFFfffffe)

    )
);