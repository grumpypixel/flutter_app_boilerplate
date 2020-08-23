import 'package:localstorage/localstorage.dart';
import 'log.dart';

class SettingsFile {
  static final SettingsFile _singleton = new SettingsFile._internal();

  static const _kFilename = 'settings.json';

  LocalStorage _storage;

  factory SettingsFile() {
    return _singleton;
  }

  SettingsFile._internal() {
    _storage = LocalStorage(_kFilename);
  }

  Future<bool> get ready async => await _storage.ready;

  Future<void> init() async {
    if (await _storage.ready) {
      // pass
    } else {
      Log.info('Storage init error.');
    }
  }

  Future<void> clear() async {
    await _storage.clear();
  }

  Future<void> save(String key, dynamic value) async {
    await _storage.setItem(key, value);
  }

  dynamic load(String key) {
    return _storage.getItem(key);
  }

  String loadString(String key) {
    return load(key) as String;
  }

  bool loadBoolean(String key) {
    return load(key) as bool;
  }

  int loadInteger(String key) {
    return load(key) as int;
  }

  double loadDecimal(String key) {
    return load(key) as double;
  }
}
