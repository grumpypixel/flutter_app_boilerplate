import 'package:flutter/material.dart';
import 'app_builder.dart';
import 'app_localizations.dart';
import 'theme_manager.dart';

class ThemesView extends StatefulWidget {
  @override
  ThemesViewState createState() => ThemesViewState();
}

class ThemesViewState extends State<ThemesView> {
  final _themeColorsDesc = <ThemeColorDesc>[];
  final _themeColors = <Color>[];
  final _themeKeys = <String>[];
  String _dropdownValue;

  ThemesViewState() {
    _themeColorsDesc.addAll(ThemeManager().themeColors);
    _themeColorsDesc.forEach((item) {
      _themeColors.add(item.color);
      _themeKeys.add(item.key);
    });
    final desc = _getCurrentThemeColorDesc();
    _dropdownValue = desc != null ? desc.key : _themeKeys[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).themesTitle)),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).systemThemeText),
                  value: ThemeManager().systemMode,
                  onChanged: (value) => _onSystemDefaultChanged(value),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).darkModeText),
                  value: ThemeManager().darkMode,
                  onChanged: ThemeManager().systemMode == false ? (value) => _onDarkModeChanged(value) : null,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).superDarkText),
                  value: ThemeManager().superDark,
                  onChanged: !ThemeManager().systemMode && ThemeManager().darkMode
                      ? (value) => _onSuperDarkModeChanged(value)
                      : null,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).themeColorText),
                  trailing: DropdownButton<String>(
                    value: _dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 4,
                      color: _getColorByName(_dropdownValue),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dropdownValue = value;
                        _onThemeColorChanged(value);
                      });
                    },
                    items: _themeKeys.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(AppLocalizations.of(context).getColor(value)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSystemDefaultChanged(bool value) {
    setState(() {
      ThemeManager().setSystemMode(value);
    });
    _forceRebuild();
  }

  void _onDarkModeChanged(bool value) {
    setState(() {
      if (value) {
        ThemeManager().enableDarkMode();
      } else {
        ThemeManager().enableLightMode();
      }
    });
    _forceRebuild();
  }

  void _onSuperDarkModeChanged(bool value) {
    setState(() {
      ThemeManager().setSuperDarkMode(value);
    });
    _forceRebuild();
  }

  void _onThemeColorChanged(String value) {
    final themeColor = _getThemeColorByName(value);
    if (themeColor != null) {
      setState(() {
        ThemeManager().setThemeColor(themeColor);
      });
      _forceRebuild();
    }
  }

  void _forceRebuild() {
    AppBuilder.of(context).rebuild();
  }

  Color _getColorByName(String name) {
    for (var i = 0; i < _themeColorsDesc.length; i++) {
      if (_themeColorsDesc[i].key == name) {
        return _themeColorsDesc[i].color;
      }
    }
    return Colors.black;
  }

  ThemeColor _getThemeColorByName(String name) {
    for (var i = 0; i < _themeColorsDesc.length; i++) {
      if (_themeColorsDesc[i].key == name) {
        return _themeColorsDesc[i].themeColor;
      }
    }
    return null;
  }

  ThemeColorDesc _getCurrentThemeColorDesc() {
    final current = ThemeManager().themeColor;
    for (var i = 0; i < _themeColorsDesc.length; i++) {
      if (_themeColorsDesc[i].themeColor == current) {
        return _themeColorsDesc[i];
      }
    }
    return null;
  }
}
