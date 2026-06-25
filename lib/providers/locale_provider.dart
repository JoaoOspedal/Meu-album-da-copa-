import 'package:flutter/material.dart';

/// Holds the user's selected app language.
class LocaleProvider extends ChangeNotifier {
  static const supportedLocales = [Locale('pt'), Locale('en')];

  Locale _locale = const Locale('pt');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
  }
}
