import 'package:flutter/material.dart';

import 'nav/feed.dart';
import 'nav/sources.dart';
import 'nav/bookmarks.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  int _navIndex = 0;
  ScrollController _scroll = ScrollController();

  void navigate(int index) {
    _scroll.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );

    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          Feed(scroll: _scroll),
          Sources(scroll: _scroll),
          Bookmarks(scroll: _scroll),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: navigate,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Sources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
