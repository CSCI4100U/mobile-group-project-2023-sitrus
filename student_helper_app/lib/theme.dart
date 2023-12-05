import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      primary: Color(0xFF288BFD),
      secondary: Color(0xFF5DA8FD),
      background: Colors.white,
      tertiary: Color(0xFF97D2FB)

  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7f5af0),
        secondary: Color(0xFF3f2d78),
        background: Color(0xFFfffffe),
        tertiary: Color(0xFF262850)

    )
);