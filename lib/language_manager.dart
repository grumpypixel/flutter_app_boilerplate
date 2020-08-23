import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'settings_file.dart';
import 'log.dart';

enum LanguageType {
  system,
  english,
  german,
}

class Language {
  LanguageType type;
  String locaKey;
  String languageCode;
  String countryCode;
}

class LanguageManager {
  static final LanguageManager _singleton = new LanguageManager._internal();
  LanguageType _language = LanguageType.english;

  final _languages = List<Language>();

  static const _kLanguageKey = 'language';

  factory LanguageManager() {
    return _singleton;
  }

  LanguageManager._internal() {
    _languages.addAll([
      Language()
        ..type = LanguageType.system
        ..locaKey = 'lang_system'
        ..languageCode = null
        ..countryCode = null,
      Language()
        ..type = LanguageType.english
        ..locaKey = 'lang_english'
        ..languageCode = 'en'
        ..countryCode = '',
      Language()
        ..type = LanguageType.german
        ..locaKey = 'lang_german'
        ..languageCode = 'de'
        ..countryCode = '',
    ]);
  }

  List<Language> get languages => _languages;
  LanguageType get language => _language;

  bool get useLanguageAsOnDevice => _language != LanguageType.system;

  List<String> get supportedLanguages {
    final languageCodes = <String>[];
    _languages.forEach((item) {
      if (item.type != LanguageType.system) {
        languageCodes.add(item.languageCode);
      }
    });
    return languageCodes;
  }

  List<Locale> get supportedLocales {
    final locales = <Locale>[];
    _languages.forEach((item) {
      if (item.type != LanguageType.system) {
        locales.add(Locale(item.languageCode, item.countryCode));
      }
    });
    return locales;
  }

  Future<void> init() async {
    if (await SettingsFile().ready) {
      try {
        final value = SettingsFile().load(_kLanguageKey);
        if (value != null) {
          _language = LanguageType.values.firstWhere((e) => e.toString() == value);
        } else {
          await setLanguage(LanguageType.system);
        }
      } catch (e) {
        Log.warning(e);
      }
    } else {
      Log.error('Storage init error.');
    }
  }

  Future<void> setLanguage(LanguageType language) async {
    _language = language;
    await SettingsFile().save(_kLanguageKey, _language.toString());
  }

  Locale getCustomLocale() {
    if (_language == LanguageType.system) {
      return null;
    }
    Locale locale;
    for (int i = 0; i < _languages.length; ++i) {
      final language = languages[i];
      if (language.type != LanguageType.system && language.type == _language) {
        locale = Locale(language.languageCode, language.countryCode);
        break;
      }
    }
    return locale;
  }

  Future<String> getDeviceLocaleString() async {
    try {
      return await Devicelocale.currentLocale;
    } catch (e) {
      Log.warning(e);
    }
    return '';
  }
}
