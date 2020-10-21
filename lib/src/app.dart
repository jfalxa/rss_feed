import 'package:flutter/material.dart';

import 'data/store.dart';
import 'data/models.dart';

import 'nav/feed.dart';
import 'nav/subscriptions.dart';
import 'nav/bookmarks.dart';

const Map<String, Subscription> DEMO = {
  "https://www.lemonde.fr/rss/une.xml": null,
  "https://rss.nytimes.com/services/xml/rss/nyt/Business.xml": null
};

class App extends StatefulWidget {
  final String title;

  App({Key key, this.title}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Store _store;

  Future _future;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    _store = Store(DEMO, []);
    _future = _store.fetchAll();
  }

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
          Feed(store: _store, future: _future),
          Subscriptions(store: _store, future: _future),
          Bookmarks(store: _store, future: _future),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: navigate,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: 'Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: 'Subscriptions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks), label: 'Bookmarks'),
        ],
      ),
    );
  }
}
