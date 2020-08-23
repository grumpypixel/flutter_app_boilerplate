import 'dart:core';
import 'package:flutter/material.dart';
import 'app_builder.dart';
import 'app_localizations.dart';
import 'language_manager.dart';
import 'settings.dart';

class SettingsView extends StatefulWidget {
  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  String _currentLanguageValue;
  final _languageNames = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsTitle),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    _rebuildLanguages();
    _setCurrentLanguage();
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context).languageText),
                trailing: DropdownButton<String>(
                  value: _currentLanguageValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (value) => _onLanguageChanged(value),
                  items: _languageNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).dummySettingText),
                value: Settings().dummySetting,
                onChanged: (value) => _onDummySettingChanged(value),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  void _rebuildLanguages() {
    _languageNames.clear();
    final languages = LanguageManager().languages;
    languages.forEach((item) {
      final text = AppLocalizations.of(context).getText(item.locaKey);
      _languageNames.add(text);
    });
  }

  void _setCurrentLanguage() {
    _currentLanguageValue = null;
    final languages = LanguageManager().languages;
    final selectedLanguage = LanguageManager().language;
    for (int i = 0; i < languages.length; i++) {
      final item = languages[i];
      if (item.type == selectedLanguage) {
        _currentLanguageValue = AppLocalizations.of(context).getText(item.locaKey);
        break;
      }
    }
  }

  void _onLanguageChanged(String value) {
    var selectedLanguage = LanguageType.system;
    final languages = LanguageManager().languages;
    for (int i = 0; i < languages.length; ++i) {
      final name = AppLocalizations.of(context).getText(languages[i].locaKey);
      if (value == name) {
        selectedLanguage = languages[i].type;
        break;
      }
    }
    setState(() {
      _currentLanguageValue = value;
      if (selectedLanguage != LanguageManager().language) {
        LanguageManager().setLanguage(selectedLanguage);
      }
    });
    _forceRebuild();
  }

  void _onDummySettingChanged(bool value) async {
    await Settings().setDummySetting(value);
    setState(() {});
  }

  void _forceRebuild() {
    AppBuilder.of(context).rebuild();
  }
}
