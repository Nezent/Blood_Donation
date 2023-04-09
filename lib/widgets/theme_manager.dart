import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  void toggleTheme(bool isDark) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('theme', isDark);

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void initializeTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var theme = pref.getBool('theme') ?? false;
    _themeMode = (theme ? ThemeMode.dark : ThemeMode.light);
    notifyListeners();
  }
}
