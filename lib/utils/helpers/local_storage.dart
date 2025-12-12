// filepath: /Users/marcelocesar/Desktop/t4g_dashboard/lib/src/utils/local_storage.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class to handle all SharedPreferences operations in the app
/// This provides a centralized way to work with local storage
class LocalStorageHelper {
  /// Private constructor to prevent instantiation
  LocalStorageHelper._();

  static SharedPreferences? _prefs;

  /// Initialize the SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensures that SharedPreferences is initialized before any operation
  static Future<SharedPreferences> _getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Saves a string value to local storage
  static Future<bool> saveString(String key, String value) async {
    final prefs = await _getInstance();
    return prefs.setString(key, value);
  }

  /// Retrieves a string value from local storage
  static Future<String?> getString(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key);
  }

  /// Saves an integer value to local storage
  static Future<bool> saveInt(String key, int value) async {
    final prefs = await _getInstance();
    return prefs.setInt(key, value);
  }

  /// Retrieves an integer value from local storage
  static Future<int?> getInt(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key);
  }

  /// Saves a double value to local storage
  static Future<bool> saveDouble(String key, double value) async {
    final prefs = await _getInstance();
    return prefs.setDouble(key, value);
  }

  /// Retrieves a double value from local storage
  static Future<double?> getDouble(String key) async {
    final prefs = await _getInstance();
    return prefs.getDouble(key);
  }

  /// Saves a boolean value to local storage
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await _getInstance();
    return prefs.setBool(key, value);
  }

  /// Retrieves a boolean value from local storage
  static Future<bool?> getBool(String key) async {
    final prefs = await _getInstance();
    return prefs.getBool(key);
  }

  /// Saves a list of strings to local storage
  static Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _getInstance();
    return prefs.setStringList(key, value);
  }

  /// Retrieves a list of strings from local storage
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _getInstance();
    return prefs.getStringList(key);
  }

  /// Saves an object to local storage by encoding it to JSON
  static Future<bool> saveObject(String key, dynamic value) async {
    final prefs = await _getInstance();
    try {
      final json = jsonEncode(value);
      return prefs.setString(key, json);
    } catch (e) {
      debugPrint('Error saving object to local storage: $e');
      return false;
    }
  }

  /// Retrieves and decodes a JSON object from local storage
  static Future<dynamic> getObject(String key) async {
    final prefs = await _getInstance();
    try {
      final value = prefs.getString(key);
      if (value == null) {
        return null;
      }
      return jsonDecode(value);
    } catch (e) {
      debugPrint('Error retrieving object from local storage: $e');
      return null;
    }
  }

  /// Removes a value from local storage by key
  static Future<bool> remove(String key) async {
    final prefs = await _getInstance();
    return prefs.remove(key);
  }

  /// Checks if a key exists in local storage
  static Future<bool> containsKey(String key) async {
    final prefs = await _getInstance();
    return prefs.containsKey(key);
  }

  /// Clears all data from local storage
  static Future<bool> clear() async {
    final prefs = await _getInstance();
    return prefs.clear();
  }
}
