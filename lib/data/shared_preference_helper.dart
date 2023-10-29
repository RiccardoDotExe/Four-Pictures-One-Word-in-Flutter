import 'package:shared_preferences/shared_preferences.dart';

//helper class for shared preference
class SharedPreferenceHelper {
  Future<SharedPreferences>? _sharedPreference;
  //name of the key
  static const String currentLevel = "currentLevel";

  //constructor
  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  //gets current level from shared preference
  Future<int> get getCurrentLevelFromSharedPreference async {
    return _sharedPreference!.then((prefs) {
      return prefs.getInt(currentLevel) ?? 0;
    });
  }

  //sets the current level in shared preference
  Future<void> changeLevel(int value) async {
    // ignore: void_checks
    return await _sharedPreference!.then((prefs) {
      return prefs.setInt(currentLevel, value);
    });
  }

  //deletes the current level in shared preference
  Future<void> deleteLevel() async {
    // ignore: void_checks
    return await _sharedPreference!.then((prefs) {
      return prefs.remove(currentLevel);
    });
  }
}
