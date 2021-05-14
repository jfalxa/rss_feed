import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/repository.dart';
import './widgets/nav_bar.dart';
import './screens/feed/feed.dart';
import './screens/bookmarks/bookmarks.dart';
import './screens/sources/sources.dart';
import './screens/sources/source_feed.dart';
import './screens/settings/settings.dart';

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
    if (index != _navIndex) {
      setState(() {
        _navIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
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
    return MaterialApp(
      title: 'RSS Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => App(),
        Settings.routeName: (context) => Settings(),
        SourceFeed.routeName: (context) => SourceFeed()
      },
    );
  }
}

void main() {
  runApp(Provider(
    create: (context) => Repository(),
    child: Main(),
  ));
}
