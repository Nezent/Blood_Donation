import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode {
    if (_themeMode == ThemeMode.light) {
      return ThemeMode.light;
    } else if (_themeMode == ThemeMode.dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  toggleTheme(bool isDark) {
    if (isDark == true) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
