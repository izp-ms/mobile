import 'package:flutter/material.dart';
import 'package:mobile/helpers/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late bool _isDark;
  bool get isDark => _isDark;

  ThemeProvider() {
    _isDark = false;
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    AppSharedPreferences.saveThemePreference(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await AppSharedPreferences.getThemePreference();
    notifyListeners();
  }
}