import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;
  final String key = "theme";

  ThemeNotifier(this._currentTheme) {
    _loadTheme();
  }
  
  _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString(key) ?? 'light';
    
    if (theme == 'light') {
      _currentTheme = ThemeData.light();
    } else {
      _currentTheme = ThemeData.dark();
    }
    notifyListeners();
  }
  
  getTheme() => _currentTheme;

  setTheme(ThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (theme == ThemeData.light()) {
      prefs.setString(key, 'light');
      _currentTheme = ThemeData.light();
    } else {
      prefs.setString(key, 'dark');
      _currentTheme = ThemeData.dark();
    }
    notifyListeners();
  }
}
