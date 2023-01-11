import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum YFStoredItems {
  username,
  refresh,
}

class YFStorage extends ChangeNotifier {
  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();

    notifyListeners();
  }

  T get<T>(YFStoredItems key) {
    final valueFromStorage = _preferences?.getString(key.name) ?? '';

    if (T == bool) {
      return (valueFromStorage == 'true') as T;
    }
    return valueFromStorage as T;
  }

  Future<bool> set(YFStoredItems key, dynamic value) =>
      _preferences?.setString(key.name, '$value') ?? Future.value(false);

  Future<bool> remove(YFStoredItems key) =>
      _preferences?.remove(key.name) ?? Future.value(false);
}
