import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'language_manager.dart';

class AppLocalizations {
  final Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static get supportedLocales {
    return LanguageManager().supportedLocales;
  }

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations instance = AppLocalizations(locale);
    String jsonContent = await rootBundle.loadString('assets/locale/i18n_${locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent);
    return instance;
  }

  String getColor(String colorKey) {
    return getText(colorKey);
  }

  String getText(String key) {
    try {
      final text = _localizedValues[locale.languageCode][key];
      if (text != null) {
        return text;
      }
    } catch (e) {
      print('Missing text: $key => $e');
    }
    return '<Missing Text>';
  }

  String get englishLanguage => getText('lang_english');
  String get germanLanguage => getText('lang_german');

  String get buttonPressedSnack => getText('snack_button_pressed');

  String get clickCounterText => getText('text_click_counter');
  String get darkModeText => getText('text_dark_mode');
  String get dummySettingText => getText('text_dummy_setting');
  String get languageText => getText('text_language');
  String get superDarkText => getText('text_super_dark');
  String get systemLanguageText => getText('text_system_language');
  String get systemThemeText => getText('text_system_theme');
  String get themeColorText => getText('text_theme_color');

  String get mainTitle => getText('title_main');
  String get settingsTitle => getText('title_settings');
  String get themesTitle => getText('title_themes');

  String get incrementCounterTooltip => getText('tooltip_increment_counter');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => LanguageManager().supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class SpecificLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale overriddenLocale;

  SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}
