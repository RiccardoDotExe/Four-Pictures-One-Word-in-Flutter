import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences>? _sharedPreference;
  static const String currentLevel = "currentLevel";

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  //Theme module
  Future<int> get getCurrentLevelFromSharedPreference async {
    return _sharedPreference!.then((prefs) {
      //print("GET: ${(prefs.getInt(currentLevel) ?? 0) + 1}");
      return prefs.getInt(currentLevel) ?? 0;
    });
  }

  Future<void> changeLevel(int value) async {
    // ignore: void_checks
    return await _sharedPreference!.then((prefs) {
      //print("SET: ${value + 1}");
      return prefs.setInt(currentLevel, value);
    });
  }

  Future<void> deleteLevel() async {
    // ignore: void_checks
    return await _sharedPreference!.then((prefs) {
      return prefs.remove(currentLevel);
    });
  }
}
