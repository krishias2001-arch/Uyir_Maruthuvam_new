import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Load saved language (call at app start)
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('lang');

    if (code != null && _isSupported(code)) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Change language
  Future<void> setLocale(String languageCode) async {
    if (!_isSupported(languageCode)) return;

    if (_locale.languageCode == languageCode) return; // avoid rebuild

    _locale = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', languageCode);

    notifyListeners();
  }

  /// Safety check
  bool _isSupported(String code) {
    return ['en', 'ta'].contains(code);
  }
}