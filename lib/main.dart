import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './services/preferences.dart';
import './services/repository.dart';
import './screens/sources/source_feed.dart';
import './screens/settings/settings.dart';
import './screens/app.dart';
import './themes.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var prefs = context.watch<Preferences>();
    var dark = prefs.useDarkMode;

    return MaterialApp(
      title: 'RSS Feed',
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => App(),
        SourceFeed.routeName: (context) => SourceFeed(),
        SettingsControls.routeName: (context) => SettingsControls(),
      },
    );
  }
}

void main() {
  runApp(
    Provider(
      create: (context) => Repository(),
      child: ChangeNotifierProvider(
        create: (context) => Preferences(),
        child: Main(),
      ),
    ),
  );

  Preferences.setSystemStyle();
}
