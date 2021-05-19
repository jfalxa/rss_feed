import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/database.dart';
import './services/preferences.dart';
import './services/scraper.dart';
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
  static final _nav = [
    () => Feed(),
    () => Sources(),
    () => Bookmarks(),
  ];

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
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: _nav[_navIndex](),
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
    context.watch<Database>(); // rebuild when database is ready

    var prefs = context.watch<Preferences>();
    var themeMode = prefs.useDarkMode ? ThemeMode.dark : ThemeMode.light;

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
        ChangeNotifierProvider(create: (context) => Database()),
        ChangeNotifierProvider(create: (context) => Preferences()),
        Provider(create: (context) => Scraper())
      ],
      child: Main(),
    ),
  );
}
