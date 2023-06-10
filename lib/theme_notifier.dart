import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);
  
  getTheme() => _currentTheme;

  setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
