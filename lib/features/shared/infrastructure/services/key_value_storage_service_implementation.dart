import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImplementation extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferences();
    if (prefs.containsKey(key)) {
      if (T == String) {
        return prefs.getString(key) as T?;
      } else if (T == int) {
        return prefs.getInt(key) as T?;
      } else if (T == double) {
        return prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return prefs.getBool(key) as T?;
      } else if (T == List<String>) {
        return prefs.getStringList(key) as T?;
      } else {
        throw Exception('Type not supported');
      }
    }
    return null;
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPreferences();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreferences();

    if (T == String) {
      prefs.setString(key, value as String);
    } else if (T == int) {
      prefs.setInt(key, value as int);
    } else if (T == double) {
      prefs.setDouble(key, value as double);
    } else if (T == bool) {
      prefs.setBool(key, value as bool);
    } else if (T == List<String>) {
      prefs.setStringList(key, value as List<String>);
    } else {
      throw Exception('Type not supported');
    }
  }
}
