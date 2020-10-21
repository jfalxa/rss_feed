import 'package:flutter/material.dart';

import 'data/store.dart';

import 'nav/feed.dart';
import 'nav/subscriptions.dart';
import 'nav/bookmarks.dart';

class App extends StatelessWidget {
  final Store _store;
  final int _navIndex;
  final Function _onRefresh;
  final Function _onNavigate;

  App(
      {Key key,
      Store store,
      int navIndex,
      Function onRefresh,
      Function onNavigate})
      : _store = store,
        _navIndex = navIndex,
        _onRefresh = onRefresh,
        _onNavigate = onNavigate,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          Feed(store: _store, onRefresh: _onRefresh),
          Subscriptions(store: _store),
          Bookmarks(store: _store, onRefresh: _onRefresh),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavigate,
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
