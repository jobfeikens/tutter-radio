import 'package:shared_preferences/shared_preferences.dart';

const _keyVolume = 'volume';
const _keyShowPotter = 'showPotter';

class Persistence {
  late final SharedPreferences _preferences;
  
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  set volume(double? volume) {
    if (volume != null) {
      _preferences.setDouble(_keyVolume, volume);
    } else {
      _preferences.remove(_keyVolume);
    }
  }

  set showPotter(bool? showPotter) {
    if (showPotter != null) {
      _preferences.setBool(_keyShowPotter, showPotter);
    } else {
      _preferences.remove(_keyShowPotter);
    }
  }

  double? get volume => _preferences.getDouble(_keyVolume);

  bool? get showPotter => _preferences.getBool(_keyShowPotter);
}
