import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/repository.dart';
import './services/preferences.dart';
import './widgets/nav_bar.dart';
import './screens/feed/feed.dart';
import './screens/bookmarks/bookmarks.dart';
import './screens/sources/sources.dart';
import './screens/sources/source_feed.dart';
import './screens/settings/settings.dart';

final lightTheme = ThemeData(
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

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(centerTitle: true),
);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  int _navIndex = 0;

  void _navigate(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: IndexedStack(
        index: _navIndex,
        children: [
          Feed(),
          Sources(),
          Bookmarks(),
        ],
      ),
      bottomNavigationBar: NavBar(
        index: _navIndex,
        onTap: _navigate,
      ),
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<Preferences>(); // rebuild when prefs change
    final themeMode = prefs.useDarkMode ? ThemeMode.dark : ThemeMode.light;

    return MaterialApp(
      title: 'RSS Feed',
      themeMode: themeMode,
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
    MultiProvider(
      providers: [
        Provider(create: (context) => Repository()),
        ChangeNotifierProvider(create: (context) => Preferences()),
      ],
      child: Main(),
    ),
  );
}
