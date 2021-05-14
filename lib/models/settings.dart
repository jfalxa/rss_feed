import 'package:sqflite/sqflite.dart';

var tSettings = 'settings';
var cUseExternalApps = 'use_external_apps';
var cUseDarkMode = 'use_dark_mode';

class Settings {
  bool useExternalApps;
  bool useDarkMode;

  Settings.fromMap(Map<String, dynamic> map) {
    useExternalApps = map[cUseExternalApps] == 1;
    useDarkMode = map[cUseDarkMode] == 1;
  }

  static Future createTable(Transaction tx) async {
    await tx.execute('''
      CREATE TABLE $tSettings (
        $cUseExternalApps INTEGER,
        $cUseDarkMode INTEGER
      )
    ''');

    await tx.insert(tSettings, {cUseExternalApps: 1, cUseDarkMode: 0});
  }

  static Future<Settings> getSettings(Database db) async {
    var rows = await db.query(tSettings, limit: 1);
    return Settings.fromMap(rows[0]);
  }

  static Future<bool> toggleUseExternalApps(Database db, bool value) async {
    var flag = value ? 1 : 0;
    await db.update(tSettings, {cUseExternalApps: flag});
    return value;
  }

  static Future<bool> toggleUseDarkMode(Database db, bool value) async {
    var flag = value ? 1 : 0;
    await db.update(tSettings, {cUseDarkMode: flag});
    return value;
  }
}
