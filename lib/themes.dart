import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
);

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(centerTitle: true),
);
