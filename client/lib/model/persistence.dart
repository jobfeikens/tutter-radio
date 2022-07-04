import 'package:shared_preferences/shared_preferences.dart';

const _keyVolume = 'volume';

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

  double? get volume => _preferences.getDouble(_keyVolume);
}
