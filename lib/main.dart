import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_builder.dart';
import 'app_localizations.dart';
import 'language_manager.dart';
import 'le_snack.dart';
import 'settings.dart';
import 'settings_file.dart';
import 'settings_view.dart';
import 'theme_manager.dart';
import 'themes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsFile().init();
  await Settings().init();
  await ThemeManager().init();
  await LanguageManager().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (BuildContext context) {
        return MaterialApp(
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).mainTitle,
          localizationsDelegates: [
            SpecificLocalizationDelegate(LanguageManager().getCustomLocale()),
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeManager().systemMode ? ThemeManager().lightTheme : ThemeManager().theme,
          darkTheme: ThemeManager().systemMode ? ThemeManager().darkTheme : null,
          home: MainView(),
        );
      },
    );
  }
}

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> with WidgetsBindingObserver {
  final _leSnack = LeSnack();
  AppLifecycleState _lifecycleState;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state;
    });
    if (_lifecycleState == AppLifecycleState.inactive) {
      // Do something, e.g. save pending changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _leSnack.key,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counterButtonPressed(),
        tooltip: AppLocalizations.of(context).incrementCounterTooltip,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).mainTitle,
      ),
    );
  }

  Widget _buildDrawer() {
    final children = <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: ThemeManager().mainColor,
        ),
        child: Container(
          child: Center(
            child: FlutterLogo(size: 92.0, style: FlutterLogoStyle.stacked, textColor: Colors.black),
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.color_lens),
        title: Text(AppLocalizations.of(context).themesTitle),
        onTap: () {
          Navigator.pop(context);
          _onShowThemes();
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(AppLocalizations.of(context).settingsTitle),
        onTap: () {
          Navigator.pop(context);
          _onShowSettings();
        },
      ),
    ];
    return Drawer(
      child: ListView(
        children: children,
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${AppLocalizations.of(context).clickCounterText}:'),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }

  void _onShowSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsView(),
        fullscreenDialog: false,
      ),
    );
  }

  void _onShowThemes() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemesView(),
        fullscreenDialog: false,
      ),
    );
  }

  void _counterButtonPressed() {
    _incrementCounter();
    _leSnack.showMessage(AppLocalizations.of(context).buttonPressedSnack);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
