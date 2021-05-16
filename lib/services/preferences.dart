import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  bool useExternalApps = true;
  bool useDarkMode = false;

  Preferences() {
    init();
    setSystemStyle();
  }

  init() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      useExternalApps = prefs.getBool('use-external-apps') ?? true;
      useDarkMode = prefs.getBool('use-dark-mode') ?? false;
      notifyListeners();
    } catch (err) {
      print('Error reading preferences: $err');
    }
  }

  toggleUseExternalApps(bool value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      useExternalApps = value;
      await prefs.setBool('use-external-apps', useExternalApps);
      notifyListeners();
    } catch (err) {
      print('Error toggling use-external-apps: $err');
    }
  }

  toggleUseDarkMode(bool value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      useDarkMode = value;
      await prefs.setBool('use-dark-mode', useDarkMode);
      notifyListeners();
    } catch (err) {
      print('Error toggling use-dark-mode: $err');
    }
  }

  setSystemStyle() {
    addListener(() {
      if (useDarkMode) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      }
    });
  }
}
