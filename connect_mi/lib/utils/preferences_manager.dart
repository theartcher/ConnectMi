import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///The manager for handling local (-persisted) storage.
class PreferencesManager {
  static SharedPreferences? _preferences;
  static const String _darkModeKey = 'isDarkMode';
  static const String _localeKey = 'locale';
  static const String _milightUrl = 'hub-Url';

  ///Initialize the singleton of the PreferencesManager.
  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///Retrieves the current saved [ThemeMode], if not set it will default to [ThemeMode.system].
  ThemeMode getTheme() {
    var themeModeUnparsed = _preferences!.getString(_darkModeKey);
    ThemeMode themeMode;

    switch (themeModeUnparsed) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'system':
      default:
        themeMode = ThemeMode.system;
    }

    return themeMode;
  }

  ///Saves the [theme] to local (-persisted) storage, returns the result of the operation.
  Future<bool> setTheme(ThemeMode theme) {
    return _preferences!.setString(_darkModeKey, theme.toString());
  }

  ///Retrieves the current saved [Locale], if not set it will default to 'en'.
  Locale getLocale() {
    return Locale(_preferences!.getString(_localeKey) ?? 'en');
  }

  ///Saves the [locale] to local (-persisted) storage, returns the result of the operation.
  Future<bool> setLocale(Locale locale) {
    return _preferences!.setString(_localeKey, locale.toString());
  }

  ///Retrieves the current saved MiLightHub URL, if not set it will default to ''.
  String getMiLightHubUrl() {
    return _preferences!.getString(_milightUrl) ?? "";
  }

  ///Saves the [url] to local (-persisted) storage, returns the result of the operation.
  Future<bool> setMiLightHubUrl(String url) {
    return _preferences!.setString(_milightUrl, url);
  }
}
