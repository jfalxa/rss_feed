import 'package:flutter/material.dart';

import 'nav/feed.dart';
import 'nav/subscriptions.dart';
import 'nav/bookmarks.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  int _navIndex = 0;

  void navigate(int index) {
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
          Feed(),
          Subscriptions(),
          Bookmarks(),
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
            label: 'Subscriptions',
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
