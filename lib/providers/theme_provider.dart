import 'package:flutter/material.dart';

/// Holds the user's light/dark theme preference.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get isDarkMode => _mode == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    final next = enabled ? ThemeMode.dark : ThemeMode.light;
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
  }
}
