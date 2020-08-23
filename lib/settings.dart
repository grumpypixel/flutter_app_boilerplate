import 'log.dart';
import 'settings_file.dart';

class Settings {
  static final Settings _singleton = new Settings._internal();

  static const _kDummySettingDefault = true;

  static const _kDummySettingKey = 'dummy_setting';

  var _dummySetting = _kDummySettingDefault;

  bool get dummySetting => _dummySetting;

  factory Settings() {
    return _singleton;
  }

  Settings._internal() {
    // Initialize something...
  }

  Future<void> init() async {
    await SettingsFile().init();
    try {
      _dummySetting = SettingsFile().loadBoolean(_kDummySettingKey);
      if (_dummySetting == null) {
        await setDummySetting(_kDummySettingDefault);
      }
    } catch (e) {
      Log.warning(e);
    }
  }

  Future<void> setDummySetting(bool value) async {
    _dummySetting = value;
    await SettingsFile().save(_kDummySettingKey, _dummySetting);
  }
}
