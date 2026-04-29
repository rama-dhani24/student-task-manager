// lib/providers/settings_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _isLoggedIn = false;
  String _userEmail = '';

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeStr = prefs.getString(AppConstants.keyThemeMode) ?? 'light';
    _themeMode = themeModeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    final lang = prefs.getString(AppConstants.keyLanguage) ?? 'en';
    _locale = Locale(lang);

    _isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    _userEmail = prefs.getString(AppConstants.keyUserEmail) ?? '';

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.keyThemeMode,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLanguage, languageCode);
    notifyListeners();
  }

  Future<void> login(String email) async {
    _isLoggedIn = true;
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setString(AppConstants.keyUserEmail, email);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    await prefs.remove(AppConstants.keyUserEmail);
    notifyListeners();
  }
}
