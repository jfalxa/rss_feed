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
    var prefs = await SharedPreferences.getInstance();
    useExternalApps = prefs.getBool("use-external-apps") ?? true;
    useDarkMode = prefs.getBool("use-dark-mode") ?? false;
    notifyListeners();
  }

  toggleUseExternalApps(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    useExternalApps = value ?? !useExternalApps;
    await prefs.setBool('use-external-apps', useExternalApps);
    notifyListeners();
  }

  toggleUseDarkMode(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    useDarkMode = value ?? !useDarkMode;
    await prefs.setBool('use-dark-mode', useDarkMode);
    notifyListeners();
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
