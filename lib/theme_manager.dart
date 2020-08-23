import 'package:flutter/material.dart';
import 'dart:math';
import 'log.dart';
import 'settings_file.dart';

enum ThemeColor {
  red,
  green,
  blue,
  pink,
  yellow,
}

class ThemeColorDesc {
  ThemeColor themeColor;
  String key;
  Color color;

  ThemeColorDesc(this.themeColor, this.key, this.color);
}

class ThemeManager {
  static final ThemeManager _singleton = new ThemeManager._internal();

  ThemeColor _themeColor = ThemeColor.green;
  List<ThemeColorDesc> _themeColors;
  bool _systemMode = true;
  bool _darkMode = false;
  bool _superDark = false;

  static const _kThemeColorKey = 'theme_color';
  static const _kSystemModeKey = 'system_mode';
  static const _kDarkModeKey = 'dark_mode';
  static const _kSuperDarkKey = 'super_dark';

  factory ThemeManager() {
    return _singleton;
  }

  ThemeManager._internal() {
    _themeColors = [
      ThemeColorDesc(ThemeColor.red, 'color_red', Colors.red),
      ThemeColorDesc(ThemeColor.green, 'color_green', Colors.green),
      ThemeColorDesc(ThemeColor.blue, 'color_blue', Colors.blue),
      ThemeColorDesc(ThemeColor.pink, 'color_pink', Colors.pink),
      ThemeColorDesc(ThemeColor.yellow, 'color_yellow', Colors.yellow),
    ];
  }

  ThemeData get theme => _getTheme(_darkMode ? Brightness.dark : Brightness.light);
  ThemeData get lightTheme => _getTheme(Brightness.light);
  ThemeData get darkTheme => _getTheme(Brightness.dark);
  Color get mainColor => _getMainColor();
  Color get errorColor => this.theme.errorColor;

  bool get systemMode => _systemMode;
  bool get darkMode => _darkMode;
  bool get superDark => _superDark;

  ThemeColor get themeColor => _themeColor;
  List<ThemeColorDesc> get themeColors => _themeColors;

  Future<void> init() async {
    if (await SettingsFile().ready) {
      try {
        final value = SettingsFile().load(_kThemeColorKey);
        if (value != null) {
          _themeColor = ThemeColor.values.firstWhere((e) => e.toString() == value);
        } else {
          await SettingsFile().save(_kThemeColorKey, _themeColor.toString());
        }
      } catch (e) {
        Log.warning(e);
      }
      try {
        final value = SettingsFile().load(_kSystemModeKey);
        if (value != null) {
          _systemMode = value;
        } else {
          await SettingsFile().save(_kSystemModeKey, _systemMode);
        }
      } catch (e) {
        Log.warning(e);
      }
      try {
        final value = SettingsFile().load(_kDarkModeKey);
        if (value != null) {
          _darkMode = value;
        } else {
          await SettingsFile().save(_kDarkModeKey, _darkMode);
        }
      } catch (e) {
        Log.warning(e);
      }
      try {
        final value = SettingsFile().load(_kSuperDarkKey);
        if (value != null) {
          _superDark = value;
        } else {
          await SettingsFile().save(_kSuperDarkKey, _superDark);
        }
      } catch (e) {
        Log.warning(e);
      }
    } else {
      Log.warning('Storage init error.');
    }
  }

  void reset() async {
    await SettingsFile().clear();
    _themeColor = ThemeColor.green;
    _systemMode = true;
    _darkMode = false;
  }

  void setSystemMode(bool systemMode) async {
    _systemMode = systemMode;
    await SettingsFile().save(_kSystemModeKey, _systemMode);
  }

  void enableLightMode() {
    _setMode(false);
  }

  void enableDarkMode() {
    _setMode(true);
  }

  void setThemeColor(ThemeColor color) async {
    _themeColor = color;
    await SettingsFile().save(_kThemeColorKey, _themeColor.toString());
  }

  void _setMode(bool darkMode) async {
    _darkMode = darkMode;
    await SettingsFile().save(_kDarkModeKey, _darkMode);
  }

  void setSuperDarkMode(bool value) async {
    if (_superDark != value) {
      _superDark = value;
      await SettingsFile().save(_kSuperDarkKey, _superDark);
    }
  }

  Color _getMainColor() {
    switch (_themeColor) {
      case ThemeColor.red:
        return Colors.red;
      case ThemeColor.blue:
        return Colors.blue;
      case ThemeColor.green:
        return Colors.green;
      case ThemeColor.pink:
        return Colors.pink;
      case ThemeColor.yellow:
        return Colors.yellow;
    }
    return this.theme.primaryColor;
  }

  ThemeData _getTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return _getLightTheme();
      case Brightness.dark:
        return !_systemMode && _superDark ? _getSuperDarkTheme() : _getDarkTheme();
    }
    return null;
  }

  ThemeData _getLightTheme() {
    switch (_themeColor) {
      case ThemeColor.red:
        return _createLightTheme(Colors.red, Colors.black);
      case ThemeColor.green:
        return _createLightTheme(Colors.green, Colors.black);
      case ThemeColor.blue:
        return _createLightTheme(Colors.blue, Colors.black);
      case ThemeColor.pink:
        return _createLightTheme(Colors.pink, Colors.black);
      case ThemeColor.yellow:
        return _createLightTheme(Colors.yellow, Colors.black);
    }
    return ThemeData.light();
  }

  ThemeData _getDarkTheme() {
    switch (_themeColor) {
      case ThemeColor.red:
        return _createDarkTheme(Colors.red, Colors.red);
      case ThemeColor.green:
        return _createDarkTheme(Colors.green, Colors.green);
      case ThemeColor.blue:
        return _createDarkTheme(Colors.blue, Colors.blue);
      case ThemeColor.pink:
        return _createDarkTheme(Colors.pink, Colors.pink);
      case ThemeColor.yellow:
        return _createDarkTheme(Colors.yellow, Colors.yellow);
    }
    return ThemeData.dark();
  }

  ThemeData _getSuperDarkTheme() {
    switch (_themeColor) {
      case ThemeColor.red:
        return _createSuperDarkTheme(Colors.red);
      case ThemeColor.green:
        return _createSuperDarkTheme(Colors.green);
      case ThemeColor.blue:
        return _createSuperDarkTheme(Colors.blue);
      case ThemeColor.pink:
        return _createSuperDarkTheme(Colors.pink);
      case ThemeColor.yellow:
        return _createSuperDarkTheme(Colors.yellow);
    }
    return ThemeData.dark();
  }

  ThemeData _createLightTheme(Color primaryColor, Color secondaryColor) {
    final materialColor = generateMaterialColor(primaryColor);
    final themeData = ThemeData(
      brightness: Brightness.light,
      primarySwatch: materialColor,
      accentColor: secondaryColor,
    );
    return themeData.copyWith(
      iconTheme: IconThemeData(color: secondaryColor),
      primaryIconTheme: IconThemeData(color: primaryColor),
      accentIconTheme: IconThemeData(color: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }

  ThemeData _createDarkTheme(Color primaryColor, Color secondaryColor) {
    final themeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: generateMaterialColor(primaryColor),
      accentColor: secondaryColor,
    );
    return themeData.copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      toggleableActiveColor: primaryColor,
    );
  }

  ThemeData _createSuperDarkTheme(Color accentColor) {
    final materialColor = generateMaterialColor(accentColor);
    final darkAccentColor = materialColor[700];
    final themeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: generateMaterialColor(accentColor),
      accentColor: darkAccentColor,
    );
    return themeData.copyWith(
      primaryColor: Colors.black,
      accentColor: darkAccentColor,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.black,
      backgroundColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkAccentColor,
      ),
      toggleableActiveColor: darkAccentColor,
    );
  }

  // Source: https://medium.com/@morgenroth/using-flutters-primary-swatch-with-a-custom-materialcolor-c5e0f18b95b0
  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: _tintColor(color, 0.9),
      100: _tintColor(color, 0.8),
      200: _tintColor(color, 0.6),
      300: _tintColor(color, 0.4),
      400: _tintColor(color, 0.2),
      500: color,
      600: _shadeColor(color, 0.1),
      700: _shadeColor(color, 0.2),
      800: _shadeColor(color, 0.3),
      900: _shadeColor(color, 0.4),
    });
  }

  int _tintValue(int value, double factor) => max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color _tintColor(Color color, double factor) =>
      Color.fromRGBO(_tintValue(color.red, factor), _tintValue(color.green, factor), _tintValue(color.blue, factor), 1);

  int _shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  Color _shadeColor(Color color, double factor) => Color.fromRGBO(
      _shadeValue(color.red, factor), _shadeValue(color.green, factor), _shadeValue(color.blue, factor), 1);
}
