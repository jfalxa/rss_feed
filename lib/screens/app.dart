import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
import './feed/feed.dart';
import './bookmarks/bookmarks.dart';
import './sources/sources.dart';

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
      primary: false,
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
