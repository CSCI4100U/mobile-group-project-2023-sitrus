import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_helper_project/theme.dart';
class ThemeProvider {

  static Future<ThemeData> determineTheme(BuildContext context) async {
    bool? isDarkMode = await loadThemeFromPreferences();
   // current=isDarkMode ?? current;
    return isDarkMode ?? false ? darkMode : lightMode;
  }

  static Future<void> saveThemeToPreferences(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  static Future<bool?> loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode');
  }
}
