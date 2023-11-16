import 'package:chitchat/constants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool themeMode = false;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedThemeMode = prefs.getBool('themeMode');
    if (storedThemeMode != null) {
      themeMode = storedThemeMode;
    }
    if (themeMode == false) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
    //notifyListeners();
  }

  Future<void> _saveThemeMode(bool themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', themeMode);
    if (themeMode == false) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
    notifyListeners();
  }

  void themeChanged() {
    themeMode = !themeMode;
    toggleTheme();
    _saveThemeMode(themeMode);
    notifyListeners();
  }
}
