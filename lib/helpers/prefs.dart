import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _appThemeModePrefsKey = 'app_theme_mode';
const _recoveryDatabasePrefsKey =
    'recovery_old_data_in_sqflite_to_new_mysql_database';
final int defaultAppThemeModeIndex = Brightness.light.index;

class Prefs {
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<int> getAppThemeMode() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_appThemeModePrefsKey) ?? defaultAppThemeModeIndex;
  }

  Future<int> toggleAppThemeMode() async {
    final prefs = await _getPrefs();
    int appThemeMode = await getAppThemeMode();
    appThemeMode = appThemeMode == Brightness.dark.index
        ? Brightness.light.index
        : Brightness.dark.index;
    prefs.setInt(_appThemeModePrefsKey, appThemeMode);
    return appThemeMode;
  }

  Future<bool> getRecoveryOldDataInSqfliteToNewDatabaseMySql() async {
    final prefs = await _getPrefs();
    return prefs
            .getBool('recovery_old_data_in_sqflite_to_new_mysql_database') ??
        false;
  }

  Future<void> setRecoveryOldDataInSqfliteToNewDatabaseMySql(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_recoveryDatabasePrefsKey, value);
  }
}
